# Görevhane (Supabase sürümü)

Çok kullanıcılı ortak görev panosu. Tek bir `index.html`; veri ve giriş Supabase'de, onay kodu mailleri Brevo'dan,
yayın GitHub Pages'te. Kurulum `../projectway.md` kılavuzuna göre yapıldı.

**Site:** https://fozdemir2205.github.io/gorevhane-web/

## Özellikler

- Kayıt: kullanıcı adı + e-posta + şifre (2 kez). E-postaya gelen 6 haneli kod (15 dk) kayıt ekranında girilince kayıt tamamlanır.
- Giriş e-posta + şifre ile. Şifremi unuttum: maile gelen kod + yeni şifre (2 kez).
- Görevler herkese açık; herkes açar, düzenler, tamamlar. Her işlem yapan kişiyle birlikte geçmişe yazılır.
- Tamamlarken en az 10 karakter açıklama zorunlu (sayfada ve veritabanında kontrol edilir). Tamamlanan görevi sadece admin, sebep yazarak yeniden açar.
- Öncelik, son tarih, etiketler; yorum + @bahsetme; anlık bildirimler; 1 gün / 1 saat kala hatırlatma; Türkçe uyumlu arama; rapor; admin paneli.
- Sistemde kayıt olan **ilk kullanıcı otomatik admin** olur.

## Dosyalar

| Dosya | İçerik |
| --- | --- |
| `index.html` | Tüm uygulama (HTML + CSS + JavaScript) |
| `supabase/migrations/…_gorevhane.sql` | Tablolar, RLS kuralları, iş kuralı fonksiyonları, hatırlatma zamanlayıcısı |
| `supabase/config.toml` | Giriş ayarları (kod uzunluğu, süreler, şifre kuralı, Brevo SMTP) |
| `supabase/templates/*.html` | Onay ve şifre sıfırlama kodu mailleri |

Gizli dosyalar (`db-password.txt`, `brevo-smtp.env`) `.gitignore` içinde; depoya girmez.

## Güvenlik

- Sayfada sadece Supabase **publishable** anahtarı var.
- Tarayıcı tablolara doğrudan yazamaz; tüm değişiklikler veritabanındaki fonksiyonlardan geçer
  (`create_task`, `complete_task`, `reopen_task`, `add_comment` …). Kurallar ve "kim yaptı" kaydı atlanamaz.
- Giriş yapmamış biri hiçbir tabloyu okuyamaz (401).

## Değişiklik yapmak

```powershell
supabase db push --linked          # yeni migration dosyalarını gönderir
supabase config push               # config.toml'u gönderir (önce brevo-smtp.env yüklenmeli, kılavuz 18. adım)
git push                           # sayfayı yeniden yayınlar
```

## Node.js sürümünden farklar

- Giriş kullanıcı adıyla değil e-postayla yapılıyor (sunucu olmadan kullanıcı adından e-posta bulmak e-postaları herkese açardı).
- Yanlış kod deneme sınırı Supabase'in IP başına sınırıyla sağlanıyor (5 denemede kodu iptal etme yok).
- Onaylanmamış kayıtlar otomatik silinmiyor; kullanıcı adı ayrılmış kalır.
