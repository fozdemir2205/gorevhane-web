-- Görevhane: ortak görev panosu (Supabase)
-- Tarayıcı tablolara doğrudan yazamaz. Tüm değişiklikler aşağıdaki fonksiyonlardan geçer;
-- böylece kurallar (zorunlu açıklama, admin yetkisi, sürüm kontrolü) ve "kim yaptı" kaydı atlanamaz.

-- ============================================================
-- Yardımcılar
-- ============================================================

-- Türkçe küçük harfe çevirme (İ→i, I→ı); arama metni için.
create function public.tr_lower(t text) returns text
language sql immutable set search_path = ''
as $$ select lower(replace(replace(coalesce(t, ''), 'İ', 'i'), 'I', 'ı')) $$;

-- ============================================================
-- Tablolar
-- ============================================================

create table public.profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  username    text not null unique check (username ~ '^[a-z0-9_]{3,20}$'),
  role        text not null default 'USER' check (role in ('ADMIN', 'USER')),
  status      text not null default 'ACTIVE' check (status in ('ACTIVE', 'DISABLED')),
  created_at  timestamptz not null default now()
);

create table public.tags (
  id          bigint generated always as identity primary key,
  name        text not null unique check (char_length(name) between 2 and 24),
  color       text not null check (color ~ '^#[0-9a-fA-F]{6}$'),
  created_at  timestamptz not null default now()
);

create table public.tasks (
  id               bigint generated always as identity primary key,
  title            text not null check (char_length(title) between 3 and 120),
  description      text not null default '' check (char_length(description) <= 5000),
  priority         text not null default 'ORTA' check (priority in ('DUSUK', 'ORTA', 'YUKSEK', 'ACIL')),
  due_at           timestamptz,
  status           text not null default 'OPEN' check (status in ('OPEN', 'DONE')),
  completion_note  text,
  created_by       uuid not null references public.profiles (id),
  updated_by       uuid references public.profiles (id),
  completed_by     uuid references public.profiles (id),
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  completed_at     timestamptz,
  version          int not null default 1,
  deleted_at       timestamptz,
  search_text      text not null default '',
  reminded_24h     boolean not null default false,
  reminded_1h      boolean not null default false,
  -- Tamamlanmış görevde açıklama veritabanı seviyesinde de zorunlu
  constraint done_requires_note check (
    status = 'OPEN' or (completion_note is not null and char_length(btrim(completion_note)) >= 10 and completed_by is not null)
  )
);
create index tasks_status_due_idx on public.tasks (status, due_at) where deleted_at is null;

create table public.task_tags (
  task_id  bigint not null references public.tasks (id) on delete cascade,
  tag_id   bigint not null references public.tags (id) on delete cascade,
  primary key (task_id, tag_id)
);

create table public.task_followers (
  task_id  bigint not null references public.tasks (id) on delete cascade,
  user_id  uuid not null references public.profiles (id) on delete cascade,
  primary key (task_id, user_id)
);

create table public.comments (
  id          bigint generated always as identity primary key,
  task_id     bigint not null references public.tasks (id) on delete cascade,
  author_id   uuid not null references public.profiles (id),
  body        text not null check (char_length(btrim(body)) between 1 and 2000),
  created_at  timestamptz not null default now()
);
create index comments_task_idx on public.comments (task_id, created_at);

create table public.mentions (
  comment_id  bigint not null references public.comments (id) on delete cascade,
  user_id     uuid not null references public.profiles (id) on delete cascade,
  primary key (comment_id, user_id)
);

create table public.activity_logs (
  id          bigint generated always as identity primary key,
  task_id     bigint not null references public.tasks (id) on delete cascade,
  actor_id    uuid not null references public.profiles (id),
  action      text not null,
  changes     jsonb not null default '{}'::jsonb,
  created_at  timestamptz not null default now()
);
create index activity_task_idx on public.activity_logs (task_id, created_at);

create table public.notifications (
  id          bigint generated always as identity primary key,
  user_id     uuid not null references public.profiles (id) on delete cascade,
  type        text not null,
  task_id     bigint references public.tasks (id) on delete cascade,
  actor_id    uuid references public.profiles (id) on delete set null,
  payload     jsonb not null default '{}'::jsonb,
  is_read     boolean not null default false,
  created_at  timestamptz not null default now()
);
create index notifications_user_idx on public.notifications (user_id, created_at desc);

-- Etkinlik kaydı sadece eklenebilir (görev tamamen silinirse birlikte silinir).
create function public.activity_logs_append_only() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if tg_op = 'UPDATE' then
    raise exception 'activity_logs sadece eklenebilir';
  end if;
  if not exists (select 1 from public.tasks where id = old.task_id) then
    return old; -- görevle birlikte silinme (cascade)
  end if;
  raise exception 'activity_logs sadece eklenebilir';
end;
$$;
create trigger activity_logs_no_change before update or delete on public.activity_logs
  for each row execute function public.activity_logs_append_only();

-- ============================================================
-- Yetki yardımcıları
-- ============================================================

create function public.is_active() returns boolean
language sql stable security definer set search_path = ''
as $$ select exists (select 1 from public.profiles where id = auth.uid() and status = 'ACTIVE') $$;

create function public.is_admin() returns boolean
language sql stable security definer set search_path = ''
as $$ select exists (select 1 from public.profiles where id = auth.uid() and status = 'ACTIVE' and role = 'ADMIN') $$;

-- Etkin kullanıcıyı döner; giriş yoksa veya hesap pasifse hata verir.
create function public.require_active() returns uuid
language plpgsql stable security definer set search_path = ''
as $$
declare v uuid := auth.uid();
begin
  if v is null then raise exception 'Oturum açman gerekiyor' using errcode = '28000'; end if;
  if not exists (select 1 from public.profiles where id = v and status = 'ACTIVE') then
    raise exception 'Hesabın bir admin tarafından pasifleştirildi' using errcode = '28000';
  end if;
  return v;
end;
$$;

create function public.require_admin() returns uuid
language plpgsql stable security definer set search_path = ''
as $$
declare v uuid := public.require_active();
begin
  if not exists (select 1 from public.profiles where id = v and role = 'ADMIN') then
    raise exception 'Bu işlemi sadece admin yapabilir' using errcode = '42501';
  end if;
  return v;
end;
$$;

-- ============================================================
-- Kayıt: auth.users → profiles
-- ============================================================

-- Kayıt formundan önce kullanıcı adının boşta olup olmadığını sorar (giriş yapmadan çağrılabilir).
create function public.username_available(p_username text) returns boolean
language sql stable security definer set search_path = ''
as $$ select not exists (select 1 from public.profiles where username = lower(btrim(p_username))) $$;

-- Kayıtta kullanıcı adı profiles tablosuna yazılır. Sistemdeki ilk kullanıcı admin olur.
create function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = ''
as $$
declare uname text := lower(btrim(new.raw_user_meta_data ->> 'username'));
begin
  if uname is null or uname !~ '^[a-z0-9_]{3,20}$' then
    raise exception 'Geçersiz kullanıcı adı';
  end if;
  insert into public.profiles (id, username, role)
  values (new.id, uname, case when exists (select 1 from public.profiles where role = 'ADMIN') then 'USER' else 'ADMIN' end);
  return new;
end;
$$;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- ============================================================
-- Bildirim yardımcıları
-- ============================================================

create function public.notify_users(p_users uuid[], p_type text, p_task bigint, p_actor uuid, p_payload jsonb)
returns void
language sql security definer set search_path = ''
as $$
  insert into public.notifications (user_id, type, task_id, actor_id, payload)
  select p.id, p_type, p_task, p_actor, p_payload
  from public.profiles p
  where p.id = any (p_users) and p.status = 'ACTIVE' and p.id is distinct from p_actor;
$$;

create function public.task_follower_ids(p_task bigint) returns uuid[]
language sql stable security definer set search_path = ''
as $$ select coalesce(array_agg(user_id), '{}') from public.task_followers where task_id = p_task $$;

create function public.follow(p_task bigint, p_user uuid) returns void
language sql security definer set search_path = ''
as $$ insert into public.task_followers (task_id, user_id) values (p_task, p_user) on conflict do nothing $$;

create function public.log_activity(p_task bigint, p_actor uuid, p_action text, p_changes jsonb) returns void
language sql security definer set search_path = ''
as $$ insert into public.activity_logs (task_id, actor_id, action, changes) values (p_task, p_actor, p_action, coalesce(p_changes, '{}')) $$;

create function public.task_tag_names(p_task bigint) returns jsonb
language sql stable security definer set search_path = ''
as $$
  select coalesce(jsonb_agg(g.name order by g.name), '[]'::jsonb)
  from public.task_tags tt join public.tags g on g.id = tt.tag_id where tt.task_id = p_task
$$;

-- Ortak alan doğrulaması (oluşturma ve düzenleme)
create function public.check_task_fields(p_title text, p_description text, p_priority text, p_tag_ids bigint[])
returns void
language plpgsql stable security definer set search_path = ''
as $$
begin
  if char_length(btrim(coalesce(p_title, ''))) < 3 then raise exception 'Başlık en az 3 karakter olmalı'; end if;
  if char_length(btrim(p_title)) > 120 then raise exception 'Başlık en fazla 120 karakter olabilir'; end if;
  if char_length(coalesce(p_description, '')) > 5000 then raise exception 'Açıklama en fazla 5000 karakter olabilir'; end if;
  if p_priority not in ('DUSUK', 'ORTA', 'YUKSEK', 'ACIL') then raise exception 'Geçersiz öncelik'; end if;
  if coalesce(cardinality(p_tag_ids), 0) > 5 then raise exception 'En fazla 5 etiket seçilebilir'; end if;
  if coalesce(cardinality(p_tag_ids), 0) > (select count(*) from public.tags where id = any (p_tag_ids)) then
    raise exception 'Seçilen etiketlerden biri artık yok';
  end if;
end;
$$;

-- ============================================================
-- Görev işlemleri (tarayıcı bunları supabase.rpc ile çağırır)
-- ============================================================

create function public.create_task(p_title text, p_description text, p_priority text, p_due_at timestamptz, p_tag_ids bigint[])
returns bigint
language plpgsql security definer set search_path = ''
as $$
declare
  v_uid uuid := public.require_active();
  v_id bigint;
begin
  perform public.check_task_fields(p_title, p_description, p_priority, p_tag_ids);
  if p_due_at is not null and p_due_at < now() - interval '1 minute' then
    raise exception 'Son tarih geçmişte olamaz';
  end if;
  insert into public.tasks (title, description, priority, due_at, created_by, updated_by, search_text)
  values (btrim(p_title), btrim(coalesce(p_description, '')), p_priority, p_due_at, v_uid, v_uid,
          public.tr_lower(btrim(p_title) || ' ' || coalesce(p_description, '')))
  returning id into v_id;
  insert into public.task_tags (task_id, tag_id) select v_id, unnest(coalesce(p_tag_ids, '{}')) on conflict do nothing;
  perform public.follow(v_id, v_uid);
  perform public.log_activity(v_id, v_uid, 'task.created', jsonb_build_object(
    'title', btrim(p_title), 'priority', p_priority, 'dueAt', p_due_at, 'tags', public.task_tag_names(v_id)));
  return v_id;
end;
$$;

-- Sürüm kontrollü düzenleme: başkası araya girdiyse VERSION_CONFLICT hatası döner.
create function public.update_task(p_id bigint, p_version int, p_title text, p_description text, p_priority text,
                                   p_due_at timestamptz, p_tag_ids bigint[])
returns int
language plpgsql security definer set search_path = ''
as $$
declare
  v_uid uuid := public.require_active();
  t public.tasks;
  v_changes jsonb := '{}'::jsonb;
  v_tags_before jsonb;
  v_tags_after jsonb;
  v_by text;
begin
  select * into t from public.tasks where id = p_id and deleted_at is null for update;
  if not found then raise exception 'Görev bulunamadı'; end if;
  if t.status = 'DONE' then
    raise exception 'Tamamlanmış görev düzenlenemez. Yeniden açmak için bir admin ile görüş.';
  end if;
  if t.version <> p_version then
    select username into v_by from public.profiles where id = t.updated_by;
    raise exception 'Bu görev sen düzenlerken @% tarafından değiştirildi.', coalesce(v_by, 'başka biri')
      using hint = 'VERSION_CONFLICT';
  end if;
  perform public.check_task_fields(p_title, p_description, p_priority, p_tag_ids);

  if btrim(p_title) <> t.title then v_changes := v_changes || jsonb_build_object('title', jsonb_build_object('from', t.title, 'to', btrim(p_title))); end if;
  if btrim(coalesce(p_description, '')) <> t.description then v_changes := v_changes || jsonb_build_object('description', jsonb_build_object('from', t.description, 'to', btrim(coalesce(p_description, '')))); end if;
  if p_priority <> t.priority then v_changes := v_changes || jsonb_build_object('priority', jsonb_build_object('from', t.priority, 'to', p_priority)); end if;
  if p_due_at is distinct from t.due_at then
    if p_due_at is not null and p_due_at < now() - interval '1 minute' then raise exception 'Son tarih geçmişte olamaz'; end if;
    v_changes := v_changes || jsonb_build_object('dueAt', jsonb_build_object('from', t.due_at, 'to', p_due_at));
  end if;

  v_tags_before := public.task_tag_names(p_id);
  delete from public.task_tags where task_id = p_id;
  insert into public.task_tags (task_id, tag_id) select p_id, unnest(coalesce(p_tag_ids, '{}')) on conflict do nothing;
  v_tags_after := public.task_tag_names(p_id);
  if v_tags_before <> v_tags_after then v_changes := v_changes || jsonb_build_object('tags', jsonb_build_object('from', v_tags_before, 'to', v_tags_after)); end if;

  if v_changes = '{}'::jsonb then return t.version; end if;

  update public.tasks set
    title = btrim(p_title), description = btrim(coalesce(p_description, '')), priority = p_priority, due_at = p_due_at,
    updated_by = v_uid, updated_at = now(), version = version + 1,
    search_text = public.tr_lower(btrim(p_title) || ' ' || coalesce(p_description, '')),
    reminded_24h = case when v_changes ? 'dueAt' then false else reminded_24h end,
    reminded_1h  = case when v_changes ? 'dueAt' then false else reminded_1h end
  where id = p_id;
  perform public.follow(p_id, v_uid);
  perform public.log_activity(p_id, v_uid, 'task.updated', v_changes);
  return t.version + 1;
end;
$$;

-- Tamamla: en az 10 karakterlik açıklama zorunlu.
create function public.complete_task(p_id bigint, p_note text) returns void
language plpgsql security definer set search_path = ''
as $$
declare
  v_uid uuid := public.require_active();
  t public.tasks;
  v_note text := btrim(coalesce(p_note, ''));
begin
  if char_length(v_note) < 10 then raise exception 'Açıklama en az 10 karakter olmalı'; end if;
  if char_length(v_note) > 2000 then raise exception 'Açıklama en fazla 2000 karakter olabilir'; end if;
  select * into t from public.tasks where id = p_id and deleted_at is null for update;
  if not found then raise exception 'Görev bulunamadı'; end if;
  if t.status = 'DONE' then raise exception 'Bu görev zaten tamamlanmış.'; end if;
  update public.tasks set status = 'DONE', completion_note = v_note, completed_by = v_uid, completed_at = now(),
    updated_by = v_uid, updated_at = now(), version = version + 1
  where id = p_id;
  perform public.follow(p_id, v_uid);
  perform public.log_activity(p_id, v_uid, 'task.completed', jsonb_build_object('note', v_note));
  perform public.notify_users(public.task_follower_ids(p_id), 'task_completed', p_id, v_uid,
    jsonb_build_object('title', t.title, 'excerpt', left(v_note, 140)));
end;
$$;

-- Yeniden aç: sadece admin, sebep zorunlu.
create function public.reopen_task(p_id bigint, p_reason text) returns void
language plpgsql security definer set search_path = ''
as $$
declare
  v_uid uuid := public.require_admin();
  t public.tasks;
  v_reason text := btrim(coalesce(p_reason, ''));
begin
  if char_length(v_reason) < 10 then raise exception 'Sebep en az 10 karakter olmalı'; end if;
  select * into t from public.tasks where id = p_id and deleted_at is null for update;
  if not found then raise exception 'Görev bulunamadı'; end if;
  if t.status <> 'DONE' then raise exception 'Bu görev zaten açık.'; end if;
  update public.tasks set status = 'OPEN', completion_note = null, completed_by = null, completed_at = null,
    updated_by = v_uid, updated_at = now(), version = version + 1, reminded_24h = false, reminded_1h = false
  where id = p_id;
  perform public.log_activity(p_id, v_uid, 'task.reopened',
    jsonb_build_object('reason', v_reason, 'previousNote', t.completion_note, 'previousCompletedBy', t.completed_by));
  perform public.notify_users(public.task_follower_ids(p_id), 'task_reopened', p_id, v_uid,
    jsonb_build_object('title', t.title, 'excerpt', left(v_reason, 140)));
end;
$$;

create function public.delete_task(p_id bigint) returns void
language plpgsql security definer set search_path = ''
as $$
declare v_uid uuid := public.require_admin();
begin
  update public.tasks set deleted_at = now() where id = p_id and deleted_at is null;
  if not found then raise exception 'Görev bulunamadı'; end if;
  perform public.log_activity(p_id, v_uid, 'task.deleted', '{}');
end;
$$;

create function public.restore_task(p_id bigint) returns void
language plpgsql security definer set search_path = ''
as $$
declare v_uid uuid := public.require_admin();
begin
  update public.tasks set deleted_at = null where id = p_id and deleted_at is not null;
  if not found then raise exception 'Silinmiş görev bulunamadı'; end if;
  perform public.log_activity(p_id, v_uid, 'task.restored', '{}');
end;
$$;

-- Yorum + @bahsetme
create function public.add_comment(p_task bigint, p_body text) returns bigint
language plpgsql security definer set search_path = ''
as $$
declare
  v_uid uuid := public.require_active();
  v_body text := btrim(coalesce(p_body, ''));
  v_title text;
  v_id bigint;
  v_mentioned uuid[];
  v_payload jsonb;
begin
  if char_length(v_body) = 0 then raise exception 'Yorum boş olamaz'; end if;
  if char_length(v_body) > 2000 then raise exception 'Yorum en fazla 2000 karakter olabilir'; end if;
  select title into v_title from public.tasks where id = p_task and deleted_at is null;
  if not found then raise exception 'Görev bulunamadı'; end if;

  insert into public.comments (task_id, author_id, body) values (p_task, v_uid, v_body) returning id into v_id;
  select coalesce(array_agg(p.id), '{}') into v_mentioned
  from public.profiles p
  where p.status = 'ACTIVE'
    and p.username in (select lower(m[2]) from regexp_matches(v_body, '(^|[^a-zA-Z0-9_])@([a-zA-Z0-9_]{3,20})', 'g') as m);
  insert into public.mentions (comment_id, user_id) select v_id, unnest(v_mentioned) on conflict do nothing;

  perform public.follow(p_task, v_uid);
  perform public.log_activity(p_task, v_uid, 'comment.created', jsonb_build_object('commentId', v_id));
  v_payload := jsonb_build_object('title', v_title, 'excerpt', left(v_body, 140));
  perform public.notify_users(v_mentioned, 'mention', p_task, v_uid, v_payload);
  perform public.notify_users(
    array(select unnest(public.task_follower_ids(p_task)) except select unnest(v_mentioned)),
    'comment', p_task, v_uid, v_payload);
  -- Görev listesindeki yorum sayısı için görevin değiştiğini bildir (sürümü değiştirmeden)
  update public.tasks set updated_at = updated_at where id = p_task;
  return v_id;
end;
$$;

create function public.set_follow(p_task bigint, p_follow boolean) returns void
language plpgsql security definer set search_path = ''
as $$
declare v_uid uuid := public.require_active();
begin
  if p_follow then perform public.follow(p_task, v_uid);
  else delete from public.task_followers where task_id = p_task and user_id = v_uid;
  end if;
end;
$$;

create function public.mark_notifications_read(p_ids bigint[]) returns void
language plpgsql security definer set search_path = ''
as $$
declare v_uid uuid := public.require_active();
begin
  update public.notifications set is_read = true
  where user_id = v_uid and not is_read and (p_ids is null or id = any (p_ids));
end;
$$;

-- ============================================================
-- Rapor
-- ============================================================

create function public.report_summary() returns json
language plpgsql stable security definer set search_path = ''
as $$
begin
  perform public.require_active();
  return json_build_object(
    'open', (select count(*) from public.tasks where deleted_at is null and status = 'OPEN'),
    'overdue', (select count(*) from public.tasks where deleted_at is null and status = 'OPEN' and due_at < now()),
    'doneThisWeek', (select count(*) from public.tasks where deleted_at is null and status = 'DONE' and completed_at >= date_trunc('week', now())),
    'avgCompletionDays', (select round((avg(extract(epoch from completed_at - created_at)) / 86400)::numeric, 1)
                          from public.tasks where deleted_at is null and status = 'DONE' and completed_at >= now() - interval '30 days'),
    'perUser', coalesce((
      select json_agg(x order by x.count desc, x.username) from (
        select p.username, count(*) as count from public.tasks t join public.profiles p on p.id = t.completed_by
        where t.deleted_at is null and t.status = 'DONE' and t.completed_at >= now() - interval '30 days'
        group by p.username order by count(*) desc, p.username limit 8) x), '[]'::json),
    'weekly', (
      select json_agg(json_build_object(
        'weekStart', w,
        'opened', (select count(*) from public.tasks t where t.deleted_at is null and t.created_at >= w and t.created_at < w + interval '7 days'),
        'completed', (select count(*) from public.tasks t where t.deleted_at is null and t.completed_at >= w and t.completed_at < w + interval '7 days')
      ) order by w)
      from generate_series(date_trunc('week', now()) - interval '3 weeks', date_trunc('week', now()), interval '1 week') as w)
  );
end;
$$;

-- ============================================================
-- Admin
-- ============================================================

create function public.admin_list_users()
returns table (id uuid, username text, email text, role text, status text, created_at timestamptz, created_count bigint, completed_count bigint)
language plpgsql stable security definer set search_path = ''
as $$
begin
  perform public.require_admin();
  return query
    select p.id, p.username, u.email::text, p.role, p.status, p.created_at,
      (select count(*) from public.tasks t where t.created_by = p.id),
      (select count(*) from public.tasks t where t.completed_by = p.id)
    from public.profiles p join auth.users u on u.id = p.id
    where u.email_confirmed_at is not null
    order by p.username;
end;
$$;

create function public.admin_set_user(p_id uuid, p_role text, p_status text) returns void
language plpgsql security definer set search_path = ''
as $$
declare
  v_admin uuid := public.require_admin();
  p public.profiles;
begin
  select * into p from public.profiles where id = p_id for update;
  if not found then raise exception 'Kullanıcı bulunamadı'; end if;
  if p_role not in ('ADMIN', 'USER') or p_status not in ('ACTIVE', 'DISABLED') then raise exception 'Geçersiz değer'; end if;
  if p_id = v_admin and p_status = 'DISABLED' then raise exception 'Kendi hesabını pasifleştiremezsin'; end if;
  if p.role = 'ADMIN' and p.status = 'ACTIVE' and (p_role <> 'ADMIN' or p_status <> 'ACTIVE')
     and not exists (select 1 from public.profiles where role = 'ADMIN' and status = 'ACTIVE' and id <> p_id) then
    raise exception 'Sistemde en az bir aktif admin kalmalı.';
  end if;
  update public.profiles set role = p_role, status = p_status where id = p_id;
end;
$$;

create function public.create_tag(p_name text, p_color text) returns bigint
language plpgsql security definer set search_path = ''
as $$
declare v_id bigint;
begin
  perform public.require_admin();
  if exists (select 1 from public.tags where lower(name) = lower(btrim(p_name))) then raise exception 'Bu isimde bir etiket zaten var'; end if;
  insert into public.tags (name, color) values (btrim(p_name), p_color) returning id into v_id;
  return v_id;
end;
$$;

create function public.delete_tag(p_id bigint) returns void
language plpgsql security definer set search_path = ''
as $$
begin
  perform public.require_admin();
  delete from public.tags where id = p_id;
end;
$$;

-- ============================================================
-- Arka plan işleri (pg_cron, dakikada bir)
-- ============================================================

create function public.run_reminders() returns void
language plpgsql security definer set search_path = ''
as $$
declare r record;
begin
  -- 1 saat kala
  for r in
    update public.tasks set reminded_1h = true, reminded_24h = true
    where status = 'OPEN' and deleted_at is null and not reminded_1h
      and due_at is not null and due_at > now() and due_at <= now() + interval '1 hour'
    returning id, title
  loop
    perform public.notify_users(public.task_follower_ids(r.id), 'due_1h', r.id, null, jsonb_build_object('title', r.title));
  end loop;
  -- 1 gün kala
  for r in
    update public.tasks set reminded_24h = true
    where status = 'OPEN' and deleted_at is null and not reminded_24h
      and due_at is not null and due_at > now() and due_at <= now() + interval '24 hours'
    returning id, title
  loop
    perform public.notify_users(public.task_follower_ids(r.id), 'due_24h', r.id, null, jsonb_build_object('title', r.title));
  end loop;
end;
$$;

create extension if not exists pg_cron;
select cron.schedule('gorevhane-reminders', '* * * * *', $$select public.run_reminders()$$);

-- ============================================================
-- Erişim: RLS + yetkiler
-- ============================================================

alter table public.profiles       enable row level security;
alter table public.tags           enable row level security;
alter table public.tasks          enable row level security;
alter table public.task_tags      enable row level security;
alter table public.task_followers enable row level security;
alter table public.comments       enable row level security;
alter table public.mentions       enable row level security;
alter table public.activity_logs  enable row level security;
alter table public.notifications  enable row level security;

-- Tarayıcı hiçbir tabloya doğrudan yazamaz; sadece okur.
revoke all on all tables in schema public from anon, authenticated;
grant select on public.profiles, public.tags, public.tasks, public.task_tags, public.task_followers,
  public.comments, public.mentions, public.activity_logs, public.notifications to authenticated;

create policy "aktif kullanicilar okur" on public.profiles for select to authenticated using ((select public.is_active()));
create policy "aktif kullanicilar okur" on public.tags for select to authenticated using ((select public.is_active()));
create policy "silinmemis gorevler, admin hepsini" on public.tasks for select to authenticated
  using ((select public.is_active()) and (deleted_at is null or (select public.is_admin())));
create policy "gorunen gorevlerin etiketleri" on public.task_tags for select to authenticated
  using (exists (select 1 from public.tasks t where t.id = task_id));
create policy "gorunen gorevlerin takipcileri" on public.task_followers for select to authenticated
  using (exists (select 1 from public.tasks t where t.id = task_id));
create policy "gorunen gorevlerin yorumlari" on public.comments for select to authenticated
  using (exists (select 1 from public.tasks t where t.id = task_id));
create policy "gorunen yorumlarin bahsetmeleri" on public.mentions for select to authenticated
  using (exists (select 1 from public.comments c where c.id = comment_id));
create policy "gorunen gorevlerin gecmisi" on public.activity_logs for select to authenticated
  using (exists (select 1 from public.tasks t where t.id = task_id));
create policy "kendi bildirimlerim" on public.notifications for select to authenticated
  using ((select auth.uid()) = user_id);

-- Fonksiyonlar: varsayılan herkese açık çalıştırma yetkisi kapatılır, sadece gerekenler açılır.
revoke execute on all functions in schema public from public, anon, authenticated;
grant execute on function public.username_available(text) to anon, authenticated;
grant execute on function public.is_active(), public.is_admin(), public.tr_lower(text) to authenticated;
grant execute on function
  public.create_task(text, text, text, timestamptz, bigint[]),
  public.update_task(bigint, int, text, text, text, timestamptz, bigint[]),
  public.complete_task(bigint, text),
  public.reopen_task(bigint, text),
  public.delete_task(bigint),
  public.restore_task(bigint),
  public.add_comment(bigint, text),
  public.set_follow(bigint, boolean),
  public.mark_notifications_read(bigint[]),
  public.report_summary(),
  public.admin_list_users(),
  public.admin_set_user(uuid, text, text),
  public.create_tag(text, text),
  public.delete_tag(bigint)
to authenticated;

-- Anlık güncellemeler (Realtime): RLS'e göre herkes sadece görebildiği satırları alır.
alter publication supabase_realtime add table public.tasks, public.notifications, public.profiles;

-- Başlangıç etiketleri
insert into public.tags (name, color) values
  ('Altyapı', '#6b3fd4'), ('İçerik', '#ff7a1a'), ('Pazarlama', '#e0367a'), ('Web', '#1f9d63'), ('Ofis', '#6b6380');
