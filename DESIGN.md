---
name: Görevhane
description: Ekibin ortak görevlerini numaralı evrak kaydı olarak tutan, kapanışı tarihli kaşe ve imzayla düşen defter.
colors:
  ground: "#e9efec"
  sheet: "#ffffff"
  row: "#f4f7f5"
  ink: "#1b2733"
  muted: "#55626d"
  grid: "#c5d1cb"
  grid-2: "#dde5e1"
  shell: "#1d3a99"
  shell-hover: "#2a4bb8"
  shell-ink: "#ffffff"
  shell-muted: "#cbd6ff"
  stamp: "#2346b5"
  stamp-soft: "#e6ecfb"
  stamp-line: "#c4d0f3"
  red: "#c42f2b"
  red-soft: "#fbe9e7"
  red-line: "#efc2bd"
  amber: "#9a5200"
  amber-soft: "#fdf0dc"
  amber-line: "#f0d3a8"
typography:
  display:
    fontFamily: "Libre Franklin, Segoe UI, system-ui, sans-serif"
    fontSize: "30px"
    fontWeight: 800
    lineHeight: 1.15
    letterSpacing: "-0.015em"
  headline:
    fontFamily: "Libre Franklin, Segoe UI, system-ui, sans-serif"
    fontSize: "20px"
    fontWeight: 800
    lineHeight: 1.15
    letterSpacing: "-0.005em"
  title:
    fontFamily: "Libre Franklin, Segoe UI, system-ui, sans-serif"
    fontSize: "17px"
    fontWeight: 800
    lineHeight: 1.15
    letterSpacing: "-0.005em"
  record-title:
    fontFamily: "Libre Franklin, Segoe UI, system-ui, sans-serif"
    fontSize: "15.5px"
    fontWeight: 600
    lineHeight: 1.3
  body:
    fontFamily: "Libre Franklin, Segoe UI, system-ui, sans-serif"
    fontSize: "14.5px"
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: "Libre Franklin, Segoe UI, system-ui, sans-serif"
    fontSize: "11.5px"
    fontWeight: 700
    letterSpacing: "0.1em"
  record-number:
    fontFamily: "Courier Prime, Courier New, ui-monospace, monospace"
    fontSize: "14px"
    fontWeight: 700
    fontFeature: "tnum"
  date:
    fontFamily: "Courier Prime, Courier New, ui-monospace, monospace"
    fontSize: "13.5px"
    fontWeight: 400
    fontFeature: "tnum"
  ledger-figure:
    fontFamily: "Courier Prime, Courier New, ui-monospace, monospace"
    fontSize: "30px"
    fontWeight: 700
    lineHeight: 1.15
  signature:
    fontFamily: "Caveat, Segoe Script, cursive"
    fontSize: "30px"
    fontWeight: 600
    lineHeight: 1
rounded:
  none: "0px"
  stamp-button: "5px"
  stamp: "6px"
  ring: "50%"
spacing:
  hair: "4px"
  xs: "8px"
  sm: "10px"
  md: "14px"
  lg: "18px"
  xl: "22px"
  xxl: "26px"
  cell: "10px 14px"
  page: "28px 36px 60px"
  page-mobile: "20px 16px 48px"
components:
  button-primary:
    backgroundColor: "{colors.stamp}"
    textColor: "{colors.shell-ink}"
    rounded: "{rounded.none}"
    padding: "9px 16px"
  button-ghost:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.ink}"
    rounded: "{rounded.none}"
    padding: "9px 16px"
  button-ghost-hover:
    backgroundColor: "{colors.row}"
  button-danger:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.red}"
    rounded: "{rounded.none}"
    padding: "9px 16px"
  button-danger-hover:
    backgroundColor: "{colors.red-soft}"
  input:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.ink}"
    rounded: "{rounded.none}"
    padding: "10px 12px"
  nav-rail:
    backgroundColor: "{colors.shell}"
    textColor: "{colors.shell-muted}"
    width: "232px"
    padding: "22px 16px 18px"
  nav-item-active:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.shell}"
    padding: "9px 12px"
  nav-item-hover:
    backgroundColor: "{colors.shell-hover}"
    textColor: "{colors.shell-ink}"
  record-sheet:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.ink}"
    rounded: "{rounded.none}"
    padding: "{spacing.cell}"
  record-sheet-hover:
    backgroundColor: "{colors.row}"
  card:
    backgroundColor: "{colors.sheet}"
    rounded: "{rounded.none}"
    padding: "{spacing.xl}"
  stamp-completed:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.stamp}"
    rounded: "{rounded.stamp}"
    padding: "3px 9px"
  stamp-button:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.stamp}"
    rounded: "{rounded.stamp-button}"
    padding: "7px 10px"
    height: "38px"
  stamp-urgent:
    textColor: "{colors.red}"
    rounded: "{rounded.none}"
    padding: "0 6px"
  tag:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.ink}"
    rounded: "{rounded.none}"
    padding: "1px 8px"
---

# Design System: Görevhane

## Overview

**Creative North Star: "Evrak Defteri"**

Görevhane bir kayıt defteridir: her görev yıl/sıra numaralı bir evraktır (`2026/0147`), açık yeşil-gri form kağıdı zemin üzerinde beyaz form tabakalarına tek piksellik ızgara çizgileriyle işlenir. Kapanış bir beyan olduğu için arayüzün en güçlü anı da odur: kayıt, çift çerçeveli, hafif eğik, tarihli bir TAMAMLANDI kaşesiyle ve el yazısı imzayla düşülür. Renk az ve görevlidir; kaşe mavisi yetkiyi ve kapanışı, kırmızı aciliyeti ve gecikmeyi taşır.

Yoğunluk masa başı iş ekranı yoğunluğudur: 14.5px gövde, 72px kayıt satırları, tam genişlik tablo. Dekor yoktur; her çizgi bir form alanının sınırıdır, her eğik nesne gerçek bir kaşedir. Yalnızca açık tema vardır (`color-scheme: light`) ve arayüz metni yalnızca Türkçedir.

Dünya, beyaz kartlı ve mor vurgulu genel SaaS listesini reddeder; soğuk kurumsal his istenmez. Sıcaklığı yuvarlak köşeler ya da gölgeler değil, kaşe ve imza gibi insan izleri verir.

**Key Characteristics:**
- Form kağıdı zemin, beyaz tabakalar, 1px ızgara çizgileri; köşeler keskin.
- Solda dolgun kaşe mavisi menü şeridi (232px).
- Evrak numaraları, tarihler ve sayılar daktilo yazısıyla (Courier Prime, tabular).
- Kapanış = tarihli, çift çerçeveli, −7° eğik kaşe + Caveat imza.
- Tek imza hareketi: kaşe basma (reduced-motion korumalı).

## Colors

Soğuk yeşil-gri kağıt nötrleri üzerinde iki mürekkep: kaşe mavisi ve ACİL kırmızısı; kehribar yalnızca "Yüksek" öncelik ve uyarı içindir.

### Primary
- **Kaşe Mavisi** (stamp): Birincil düğmeler, odak halkası, bağlantılar, TAMAMLANDI kaşesi, "Kaşe bas" düğmesi, imza mürekkebi, @bahsetmeler, okunmamış bildirim noktası, grafiklerde kapanan seri. Yumuşak tonu (stamp-soft) seçili durum, odak halesi ve olumlu uyarı zemini; stamp-line bu zeminlerin çerçevesi.
- **Menü Şeridi Laciverti** (shell): Sol menü şeridi, giriş tabakasının başlık şeridi, pencerelerin 6px üst kenarı, `theme-color`. Üzerinde beyaz (shell-ink) ve soluk mavi (shell-muted) metin; üzerine gelindiğinde shell-hover.

### Secondary
- **ACİL Kırmızısı** (red): ACİL kaşesi, geciken son tarih ve "gecikti" metni, hata uyarıları, rapordaki geciken sayısı, tehlikeli düğme (Sil). red-soft / red-line hata zemini ve çerçevesi.

### Tertiary
- **Kehribar** (amber): Yalnızca "Yüksek" öncelik metni ve uyarı kutusu (amber-soft zemin, amber-line çerçeve).

### Neutral
- **Form Kağıdı** (ground): Uygulama zemini; tabakaların altında kalan kağıt.
- **Tabaka Beyazı** (sheet): Tablo, kart, giriş alanı, pencere ve kaşe zemini.
- **Satır Yeşili** (row): Tablo başlık satırı, satır üzerine gelme, alıntı kutusu.
- **Mürekkep** (ink): Gövde metni, başlıklar, etkin sekme alt çizgisi, bildirim balonu (toast) zemini.
- **Soluk Mürekkep** (muted): İkincil metin, sütun başlıkları, alan etiketleri, açılış tarihleri.
- **Form Izgarası** (grid): Tabaka dış çerçevesi, giriş kenarı, sekme çizgisi, kesik kapanış çerçevesi.
- **İnce Izgara** (grid-2): Satır ve hücre ayırıcıları, tanım listesi çizgileri, grafik yardımcı çizgileri.

### Named Rules
**İki Mürekkep Kuralı.** Doygun renk yalnızca iki anlam taşır: mavi = yetki ve kapanış, kırmızı = acil ve gecikme. Üçüncü bir vurgu rengi eklenmez; kehribar yalnızca öncelik/uyarı metnidir.

**Kağıt Üstünde Tabaka Kuralı.** İçerik daima beyaz tabakada (sheet) durur; zemin (ground) yalnızca tabakalar arasındaki boşluktur, üzerine içerik yazılmaz (sayfa başlığı hariç).

## Typography

**Arayüz Yazısı:** Libre Franklin (Segoe UI, system-ui yedekli)
**Kayıt Yazısı:** Courier Prime (Courier New, ui-monospace yedekli)
**İmza Yazısı:** Caveat (Segoe Script yedekli)

**Character:** Libre Franklin sağlam, dar aralıklı bir form başlığı sesi verir; Courier Prime evrakı daktiloyla doldurulmuş gibi numaralandırır ve tarihler. Caveat tek bir işe ayrılmıştır: imza.

### Hierarchy
- **Display** (800, 30px, 1.15, −0.015em): Sayfa başlığı ("Evrak kayıt defteri", kayıt detayı başlığı). Giriş tabakasında 26px.
- **Headline** (800, 20px, 1.15): Pencere (modal) başlıkları.
- **Title** (800, 17px, 1.15): Kart ve bölüm başlıkları ("Kayıt geçmişi", "Son kapanışlar").
- **Record title** (600, 15.5px, 1.3): Tablodaki kayıt konusu; tamamlanınca soluk mürekkebe döner.
- **Body** (400, 14.5px, 1.5): Gövde, girişler, menü öğeleri. Yardım ve ikincil metin 12.5–13.5px.
- **Label** (700, 11.5px, 0.1em, BÜYÜK HARF): Form alanı etiketleri, tanım listesi anahtarları, rapor kutusu başlıkları. Tablo sütun başlıkları 11px / 0.12em.
- **Record number** (Courier Prime 700, 14px, tabular): Evrak no. Tarihler Courier Prime 400, 12.5–13.5px; rapor sayıları Courier Prime 700, 30px.
- **Signature** (Caveat 600, 26–30px, 1, kaşe mavisi): Kapanışı yapan kullanıcı adı.

### Named Rules
**Daktilo Kuralı.** Evrak numarası, tarih, saat, sayaç ve rapor rakamı her zaman Courier Prime ile ve tabular rakamla yazılır; Libre Franklin ile sayı kaydı yazılmaz.

**Tek İmza Kuralı.** Caveat yalnızca kapanış imzasında kullanılır. Başlık, vurgu ya da dekor için el yazısı kullanılmaz.

**Form Etiketi Kuralı.** Büyük harf ve açık harf aralığı yalnızca bir verinin hemen üstündeki/yanındaki alan adıdır (sütun başlığı, alan etiketi). Başlığın üstüne bölüm etiketi olarak konmaz.

## Layout

Masaüstünde iki sütunlu kabuk: solda 232px yapışkan menü şeridi, sağda en fazla 1240px genişlikte sayfa (28px 36px 60px iç boşluk). Sayfa başlığı solda; arama (320px) ve birincil eylem sağda, alta hizalı. Altında Açık/Tamamlandı sekmeleri (26px aralık) ve tam genişlik kayıt tablosu.

Kayıt tablosu bir form ızgarasıdır: sütunlar 112px · 88px · esnek · 150px · 120px · 158px (EVRAK NO · AÇILIŞ · KONU · AÇAN · SON TARİH · DURUM); hücreler 10px 14px, satır en az 72px, başlık satırı 38px. Detay ekranı 1.45fr / 1fr iki sütun, 22px aralık; rapor dört kutulu bir döküm şeridi ve iki grafik kartıdır. Boşluk ritmi 4 · 8 · 10 · 14 · 18 · 22 · 26px adımlarıdır.

900px altında şerit üstte yatay bir bara döner (menü yatay kayar, düğme etiketleri gizlenir), sayfa iç boşluğu 20px 16px 48px olur, tüm iki sütunlu düzenler tek sütuna iner, döküm 2×2 olur ve kayıt satırı başlıksız üç sıralı karta dönüşür: "no · son tarih / konu / açan · durum"; açılış tarihi gizlenir.

## Elevation & Depth

Sistem düzdür; derinliği çizgi ve ton taşır: zemin → beyaz tabaka → 1px ızgara. Kalıcı yüzeylerde gölge yoktur. Gölge yalnızca zeminden kopan geçici katmanlarda, yumuşak ve aşağı düşen biçimde kullanılır.

### Shadow Vocabulary
- **Tabaka kalkışı** (`box-shadow: 0 18px 40px -30px rgba(27, 39, 51, .5)`): Yalnızca giriş/kayıt tabakası.
- **Açılır menü** (`box-shadow: 0 18px 40px -20px rgba(27, 39, 51, .45)`): Bildirim paneli.
- **Öneri listesi** (`box-shadow: 0 12px 28px -16px rgba(27, 39, 51, .4)`): @bahsetme önerileri.
- **Pencere** (`box-shadow: 0 24px 60px -20px rgba(0, 0, 0, .45)`): Modal, rgba(27, 39, 51, .45) perde üzerinde.
- **Odak halesi** (`box-shadow: 0 0 0 3px` stamp-soft): Giriş ve arama odağı; derinlik değil durumdur.

### Named Rules
**Düz Defter Kuralı.** Tablo, kart ve döküm kutuları gölgesizdir; ayrım 1px ızgara çizgisiyle yapılır. Gölge yalnızca üstte süzülen geçici katmanlara aittir.

## Shapes

Köşeler keskindir (0px): düğmeler, girişler, tabakalar, sekmeler, etiketler, pencereler. Form dilini 1px çizgiler kurar; kapanış açıklaması kesik (dashed) çerçeveli bir form kutusudur, pencerenin üst kenarı 6px lacivert bir şerittir.

Yuvarlaklık yalnızca gerçek nesnelerin kendi biçiminden gelir: lastik kaşe 6px köşeli, çift çerçeveli (2px kenar + 1px dış çizgi, 2px aralık) ve −7° eğik; "Kaşe bas" düğmesi 5px köşeli ve −3° eğik; ACİL kaşesi keskin köşeli, tek 2px kenarlı ve −3° eğik. Logo, −8° eğik bir kaşe halkası (50%) içinde onay işaretidir; etiket renk noktaları 8px dairedir.

**Gerçek Nesne Kuralı.** Keskin köşe kuralının tek istisnası kaşelerdir; eğiklik ve yuvarlak köşe yalnızca kaşe olan nesneye verilir, kartlara veya düğmelere dekor olarak verilmez.

## Components

### Buttons
Tok ve kararlı; mühür gibi düz dolgu.
- **Shape:** Keskin köşe (0px), 1px kenar.
- **Primary:** Kaşe mavisi dolgu, beyaz 700 / 14px metin, 9px 16px. Üzerine gelince lacivert tona koyulaşır; geçiş `background-color .15s`.
- **Ghost:** Beyaz tabaka, mürekkep metin, ızgara kenarı; üzerine gelince satır yeşili zemin ve soluk mürekkep kenar.
- **Danger:** Beyaz zemin, kırmızı metin ve kenar; üzerine gelince red-soft.
- **Small:** 5px 10px, 12.5px. Devre dışı: %45 opaklık.
- **Link button:** Kaşe mavisi, 700, altı çizili (3px offset).

### Stamp Button ("Kaşe bas")
Açık kayıt satırının DURUM hücresinde, kapanışı başlatan düğme. Beyaz zemin, kaşe mavisi 2px kenar + 1px dış çizgi (2px aralık), 5px köşe, −3° eğik, 800 / 11.5px büyük harf, en az 38px yükseklik. Üzerine gelince stamp-soft zemin ve %4 büyüme; odakta 2px mürekkep dış çizgi.

### TAMAMLANDI Stamp (imza bileşeni)
Kapanmış kaydın mührü: "TAMAMLANDI" (800, 12px, 0.1em) ve altında Courier Prime tarih (`gg.aa.yyyy`). Kaşe mavisi, çift çerçeve, 6px köşe, −7° eğik. Büyük boyu (15px / 13px tarih) detay ekranındaki kapanış kutusunda.
- **Kaşe basma hareketi:** Tamamlama anında `press .42s cubic-bezier(.16, 1, .3, 1)`; kaşe 1.7× büyüklükten, −15° ve bulanık gelip −7°'de yerine oturur. `prefers-reduced-motion: reduce` altında animasyon kapanır. Sistemin tek imza hareketi budur.
- Her zaman imzayla (Caveat, kaşe mavisi) ve Courier Prime tarih-saatle birlikte görünür.

### ACİL Stamp
Acil öncelikli kaydın konusunun üstünde: kırmızı 2px kenar, keskin köşe, 800 / 11px, 0.14em, −3° eğik. Geciken son tarih aynı kırmızıyla, 700 ağırlıkla ve altında "gecikti" yazısıyla verilir.

### Record Sheet (kayıt tablosu)
Beyaz tabaka, ızgara dış çerçeve; satırlar ve hücreler ince ızgara ile bölünür. Başlık satırı satır yeşili zemin, 11px / 0.12em büyük harf soluk mürekkep. Satır üzerine gelince satır yeşili; tüm satır tıklanabilir. Tamamlanan kaydın konusu soluk mürekkebe döner.

### Cards / Containers
- **Corner Style:** Keskin (0px).
- **Background:** Tabaka beyazı.
- **Shadow Strategy:** Gölgesiz (Düz Defter Kuralı).
- **Border:** 1px ızgara; son kapanış kartlarında üzerine gelince soluk mürekkep kenar.
- **Internal Padding:** Detay/rapor kartı 22px; son kapanış kartı 14px 16px; döküm kutusu 14px 18px.
- **Tanım listesi:** 130px anahtar sütunu (mobilde 110px), satırlar ince ızgarayla çizilmiş form alanları.

### Inputs / Fields
- **Style:** Beyaz zemin, 1px ızgara kenar, keskin köşe, 10px 12px, 14.5px. Üstte Label tipinde alan adı.
- **Hover:** Kenar soluk mürekkebe döner.
- **Focus:** Kaşe mavisi kenar + 3px stamp-soft hale; dış çizgi yok.
- **Error:** Kırmızı kenar ve kırmızı yardım metni. Doğrulama kodu altı ayrı Courier Prime 24px kutudur.

### Chips (etiketler ve seçiciler)
- **Style:** Beyaz zemin, 1px ızgara kenar, keskin köşe, 12px; başta 8px renk noktası.
- **State:** Seçicide seçili etiket stamp-soft zemin, kaşe mavisi kenar ve 700 metin.
- **Pill (admin tabloları):** 11px / 0.1em büyük harf, renk kenardan gelir (Açık mavi, Tamamlandı soluk, Acil kırmızı).

### Navigation
- **Style:** 232px lacivert şerit; üstte logo, ortada dikey menü, altta Bildirimler düğmesi ve kullanıcı bloğu.
- **Items:** 600 / 14.5px, 9px 12px, shell-muted metin. Üzerine gelince shell-hover zemin ve beyaz; etkin sayfa beyaz tabaka zemin ve lacivert metin (şeritten kesilmiş kağıt gibi).
- **Şerit düğmeleri:** Şeffaf, yarı saydam beyaz 1px kenar; bildirim sayacı beyaz kutuda Courier Prime.
- **Sekmeler:** Metin sekmeleri, etkin olan mürekkep rengi ve 2px mürekkep alt çizgi; sayılar Courier Prime.
- **Mobile:** 900px altında üst bar; menü yatay kayar, düğme etiketleri ve kullanıcı ayrıntıları gizlenir.

### Modal
Beyaz tabaka, 6px lacivert üst kenar, 22px iç boşluk, en fazla 500px; Headline başlık ve soluk alt metin.

## Do's and Don'ts

### Do:
- **Do** her kaydı Courier Prime ile `yyyy/nnnn` evrak numarası ve `gg.aa.yy` tarihle göster.
- **Do** kapanışı her zaman tarihli TAMAMLANDI kaşesi + Caveat imza + Courier Prime tarih-saat üçlüsüyle düş.
- **Do** yeni yüzeyleri beyaz tabaka + 1px ızgara (#c5d1cb dış, #dde5e1 iç) ile kur; köşeleri 0px tut.
- **Do** odakta kaşe mavisi kenar ve 3px stamp-soft hale kullan; genel odak 2px kaşe mavisi dış çizgi, 2px offset.
- **Do** kaşe basma hareketini yalnızca tamamlama anında oynat ve reduced-motion korumasını koru.
- **Do** ikonları satır içi SVG olarak, currentColor çizgiyle, 10–16px çiz.

### Don't:
- **Don't** beyaz kartlı, mor vurgulu genel SaaS listesine ya da soğuk kurumsal görünüme kay.
- **Don't** koyu tema ekleme; sistem yalnızca açık temadır.
- **Don't** Caveat'i imza dışında, Courier Prime'ı kayıt verisi dışında kullan.
- **Don't** kalıcı yüzeylere (tablo, kart, döküm) gölge verme.
- **Don't** eğiklik ve yuvarlak köşeyi kaşe olmayan nesnelere dekor olarak uygula.
- **Don't** mavi ve kırmızıya ek bir vurgu rengi ekle; kırmızıyı acil/gecikme/hata dışında kullanma.
