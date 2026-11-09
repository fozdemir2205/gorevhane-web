# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Küçük bir iş ekibi (5–30 kişilik ofis/ekip). Gün içinde masa başında, ortak işleri tek bir panodan takip ederler:
kim hangi işi açtı, kim neyi bitirdi, neyi neden bitirdi. Ekipte bir veya birkaç admin vardır; diğerleri normal kullanıcıdır.

## Product Purpose

Ekibin ortak işlerini tek bir yerde toplamak ve her işin akıbetini izlenebilir kılmak. Başarı: bir işin ne zaman,
kim tarafından ve hangi açıklamayla kapandığı her zaman görülebilir; açık, geciken ve tamamlanan işler bir bakışta okunur.

## Positioning

Hesap verilebilirlik. Görevler ortak bir panoda durur: herkes her görevi görür, düzenler ve kapatabilir,
ama her işlem yapanın adıyla geçmişe yazılır ve hiçbir görev en az 10 karakterlik bir açıklama yazılmadan kapanmaz.
Kapanan görev kilitlenir; yalnızca admin, sebep yazarak yeniden açabilir.

## Operating Context

- Kayıt: kullanıcı adı + e-posta + şifre (2 kez), e-postaya gelen 6 haneli kodla onay. Giriş e-posta + şifre ile. Şifre sıfırlama kodla.
- Günlük döngü: görev açma (başlık, açıklama, öncelik Düşük/Orta/Yüksek/Acil, son tarih, en fazla 5 etiket), arama,
  düzenleme (aynı anda düzenleme çakışması uyarısı), açıklamayla tamamlama, yorum ve @bahsetme, takip etme.
- Bildirimler uygulama içinde anlık gelir (zil); son tarihe 1 gün ve 1 saat kala hatırlatma.
- Rapor ekranı: açık / geciken / bu hafta tamamlanan / ortalama tamamlama süresi, kişi bazında tamamlanan, haftalık açılan-tamamlanan.
- Admin ekranı: kullanıcı rolü ve aktif/pasif, etiket yönetimi, silinen görevleri geri alma.

## Capabilities and Constraints

- Mevcut yapı: tek dosya `index.html` (derleme yok), veri ve giriş Supabase'de, yayın GitHub Pages'te
  (https://fozdemir2205.github.io/gorevhane-web/). Kullanıcı bu yapıyı tasarım için bağlayıcı olarak işaretlemedi.
- Tarayıcı tablolara doğrudan yazmaz; tüm değişiklikler veritabanı fonksiyonlarından geçer.
- Görev durumu yalnızca iki tane: Açık / Tamamlandı. Görünüm yalnızca liste (pano/takvim yok). Arama metin araması (filtre paneli yok).
- Terimler: görev, tamamla, tamamlama açıklaması, yeniden aç, takip et, takipçi, etiket, öncelik, son tarih, geçmiş, bildirim.

## Brand Commitments

- Ad: **Görevhane** (onay işareti fikri taşıyan logo).
- Dil: yalnızca Türkçe.
- Tema: yalnızca açık tema (koyu tema yok).

## Evidence on Hand

- Gerçek kullanıcı verisi yok; canlıda tek hesap (admin) var. Örnek görevler, kişi adları ve rapor rakamları tasarımda
  örnek olarak işaretlenmeli. Müşteri, kullanıcı sayısı veya başarı iddiası yok, uydurulmamalı.

## Product Principles

1. Kim yaptı her zaman görünür: her işlem bir kişiye bağlanır, isimsiz değişiklik yoktur.
2. Kapatmak bir beyandır: tamamlama, yapılan işin yazılı açıklamasıyla olur.
3. Ortak alan, tek gerçek: herkes aynı panoyu görür; yetki ayrımı yalnızca geri alınması zor işlemlerdedir.
4. Bir bakışta durum: açık, geciken ve tamamlanan işler aranmadan okunur.
