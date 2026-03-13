# Fresha bilen Parla — UI analizi (detalma detal, içki sahypalar çenli)

**Sene:** 28.02.2026

Bu dokument **Fresha** (salon/spa bron platformasy) bilen **Parla** programmasynyň **UI/UX** tarapyny ekran-ekran, içki sahypalar çenli deňeşdirýär. Kemçilikler (Parla-da ýok bolan ýa-da gowulaşdyrylyan zatlar) aýdyň belgilenen.

---

## 1. Fresha UI – umuman nämä meňzeýär

- **Dizayn:** Ak fon, goýu navy esasy reňk, 2 sany aksent reňk, geometrik formalar, özüne mahsus piktogrammalar (branding).
- **Home:** Gözleg, ýerleşiş, kategoriýalar, “near me” / tanyş salony, arzanladyşlar, bildirişler; reýting we synlar; çalt bron (quick book) mümkinçiligi.
- **Bron:** Gündelik görkeziş, jemgyýet/çäre görünirligi, töleg (öňünden), awtomatik yatladyryş (SMS/email/app).
- **Müşderi:** Profil, bron geçmişi, gapma-gaplylyk (wallet), sadaqat ballary, ikitaraplaýyn habarlaşyk.
- **Karta / ugur:** Salona gidiş ugry, navigasiýa birikmesi.

---

## 2. Home page (Sahypa) — Fresha vs Parla

### 2.1 Parla-da bar bolanlar (Fresha meňzeş)

| Element | Parla | Fresha (umuman) |
|--------|--------|------------------|
| Başlyk / branding | "Gözle" (uly ýazgy) | Uly başlyk / logo |
| Ýerleşiş | Chip (Aşgabat we ş.m.), tap → saýlaw ekrany | Ýerleşiş saýlaw |
| Bildirişler | Ikona + okalanmadyk badge | Bildiriş ikony |
| Profil | Initial (ad ilkinji harpy), tap → Profil tab | Avatar / profil |
| Gözleg | Pill (tap → gözleg ekrany) | Search bar |
| Kategoriýalar | Tegelekler, scroll, sag fade | Kategoriýa tegelekleri |
| Arzanladyşlar | Gradient kartlar, badge (mysal: 2 gün) | Arzanladyş / çekiliş bölümi |
| Salon kartlary | Surat, ad, ýer, reýting, syn sany, uzaklyk, favourite | Reýting, syn, uzaklyk, favourite |
| Boş sanaw | "Bu bölümde häzir salon ýok" | Empty state |
| Çekip täzelemek | RefreshIndicator | Pull to refresh |
| Loading | Skeleton (3 kart) | Shimmer / skeleton |

### 2.2 Home page — Parla-da kemçilikler (Fresha-da bolýan / has gowy)

| # | Kemçilik | Düşündiriş |
|---|----------|------------|
| 1 | **Reýting/syn mock** | Salon kartda reýting we syn sany backend-den gelmeýär; `salon.id` boýunça hasaplanylyar. Fresha-da hakyky syn/reýting. |
| 2 | **Uzaklyk mock** | Kartda "X km" id-den çykarylýar, GPS/ýerleşiş ýok. Fresha "near me" hakyky uzaklyk bilen. |
| 3 | **Bölümler bir mazmun** | "Maslahat berilýän", "Meşhur", "Täze Parla-da" hemmesi bir salon sanawy – backend-de bölüm/curation ýok. |
| 4 | **Iş wagty görkezilmeýär** | Kartda "Açyk" / "Ýapyk" ýa-da iş sagaty ýok. Fresha-da açyk/ýapyk köp ýerde. |
| 5 | **Arzanladyşlar statik** | 3 sany arzanladyş sabit (kodda); möhlet "2 gün" badge-de-de sabit. Backend API ýok. |
| 6 | **Kategoriýa çep fade ýok** | Diňe sag tarapda gradient fade bar; solda scroll başynda fade ýok. |
| 7 | **Soňky gözlegler Home-da ýok** | Soňky gözlegler diňe Gözleg ekranynda; Home pill-e basanda gözleg açylyp, soňky gözlegler görünmeýär. |
| 8 | **Salon kartda "Bron et" ýok** | Kartda diňe tap → jikme-jik. Fresha käbir ýerlerde çalt "Book" düwmäsi. |
| 9 | **"Siziň geljekki bronyňyz" ýok** | Geljekki brony bar bolsa Home-da strip/kart görkezilmeýär. |
| 10 | **Soňky görülen salonlar ýok** | "Soňky görülen" bölümi ýok. |
| 11 | **Ýerleşiş filtiri boş netije** | Ýerleşiş saýlananda salon tapylmasa, mesaj bar ýöne "Ýerleşişi üýtget" düwmäsi aýdyň çakma. |
| 12 | **Shimmer/skeleton birmeňzeş** | Loading-de 3 skeleton kart; Fresha stilinde shimmer efekt ýok. |
| 13 | **Wagt bilen salamlaşyk ýok** | "Gündeniz haýyrly bolsun" ýaly wagt bilen başlyk ýok. |
| 14 | **Section semantics** | "Maslahat berilýän" ýaly bölümler üçin Semantics/live region az. |

Bu kemçilikleriň **Home page bilen bagly** bolanlary **PARLA_HOME_DEADLINE.xlsx**-e goşuldy (aşakda).

---

## 3. Gözleg ekrany — Fresha vs Parla

| Element | Parla | Fresha (umuman) | Kemçilik |
|--------|--------|------------------|----------|
| Input | TextField, autofocus, search submit | Search bar | — |
| Soňky gözlegler | Statik 4 söz (Saç kesmek, Barberhana...) | Soňky gözlegler (lokal saklanýar) | Parla: hakyky soňky gözlegler saklanmaýar |
| Meşhur gözlegler | Statik 4 söz | Meşhur / teklifler | — |
| Netije listi | Salon ady, salgy, leading icon | Reýting, baha, wagt | Parla: reýting/baha netije setirinde ýok |
| Boş netije | "Netije tapylmady" + söz | Empty state | — |
| Gözleg filtiri | Ýok (diňe mätin) | Kategoriýa, ýer, wagt, reýting | Parla: filtir ýok |

---

## 4. Ýerleşiş (Location picker) — Fresha vs Parla

| Element | Parla | Fresha (umuman) | Kemçilik |
|--------|--------|------------------|----------|
| Saýlaw | List: Aşgabat, Türkmenabat, Mary, Balkanabat, Daşoguz | Şäher/raýon saýlaw, "Meniň ýerim" | Parla: GPS "meniň ýerim" ýok, diňe şäher listi |
| Görkeziş | ListTile, check | Chip / dropdown | — |
| Home-da chip | Saýlanan ýer görkezilýär | Ýerleşiş chip | — |

---

## 5. Salonlar listi (kategoriýa / gözleg netijesi) — Fresha vs Parla

| Element | Parla | Fresha (umuman) | Kemçilik |
|--------|--------|------------------|----------|
| Başlyk | Kategoriýa ady ýa-da gözleg sözi | Filtr + sort | Parla: sort (reýting, uzaklyk) ýok |
| Kart/list | Card, surat, ad, salgy, reýting (mock), tap → jikme-jik | List/grid, reýting, baha | Reýting jikme-jikden gelmeýär (salon modelinde) |
| Favourite | Ýok (bu ekranda) | Favourite ikony | Parla: listde favourite ýok |
| Boş | EmptyStateWidget | Empty | — |
| Loading | Skeleton | Shimmer | — |

---

## 6. Salon jikme-jik (detail) — Fresha vs Parla

| Element | Parla | Fresha (umuman) | Kemçilik |
|--------|--------|------------------|----------|
| Surat | SliverAppBar, galeriýa tap → gallery | Galeriýa, suratlar | — |
| Ad / salgy | Bar, salgy setiri | Ad, salgy, açyk/ýapyk | Parla: iş wagty "Suratlary gör" ýaly açylyp görkezilýär, backend-den gelmeýär |
| Iş wagty | Mock (Duş–Şen 09:00–20:00), bottom sheet | Iş wagty, "Open now" | Hakyky iş wagty API ýok |
| Karta | FlutterMap, salon + ulanyjy nokady, uzaklyk | Karta, ugur | Parla: "Ugur" düwmäsi işlemeýär (onPressed: () {}) |
| Synlar | Tile → Synlar ekrany (mock) | Reýting/syn, syn ýazmak | Synlar mock, API ýok |
| Topar | Tile → Topar ekrany (mock) | Usullary görkezmek | Staff mock |
| Hyzmatlar | List, hyzmat ady, möhlet, baha, "Bron et" | Hyzmatlar, baha, wagt, bron | — |
| Full screen karta | Bar, zoom, ulanyjy/salon nokady | Karta | "Ugur" (directions) boş |

---

## 7. Bron ekrany — Fresha vs Parla

| Element | Parla | Fresha (umuman) | Kemçilik |
|--------|--------|------------------|----------|
| Hyzmat saýlaw | ChoiceChip | Hyzmat listi, çylşyrymly saýlaw | — |
| Gün saýlaw | Gorizontal 7 gün (Şu gün, Ertir, dd MMM) | Kalendar / gün strip | — |
| Wagt slotlary | ChoiceChip (HH:mm) | Slot listi, real-time | — |
| Ad / telefon | Form, profil-den doldurylýar | Profil maglumat | — |
| Tassyklamak | Button, 409 conflict dialog | Öňünden töleg, tassyklama | Parla: töleg ýok; 409 gowy görkezilýär |
| Wagty saýlamadyk | SnackBar | Validation | — |

---

## 8. Tassyklama ekrany — Fresha vs Parla

| Element | Parla | Fresha (umuman) | Kemçilik |
|--------|--------|------------------|----------|
| Animasiýa | Check icon, scale + fade | Success animasiýa | — |
| Maglumat | Salon, hyzmat, wagt, müşderi, telefon, Bron # | Tassyklama jikme-jigi | — |
| Yza | "Sahypa", "Meniň bronlarym" | Kalendara goşmak, ugur | Parla: "Kalendara goşmak" / ugur ýok |

---

## 9. Meniň bronlarym — Fresha vs Parla

| Element | Parla | Fresha (umuman) | Kemçilik |
|--------|--------|------------------|----------|
| Telefon ýok | Empty state, "Profile geçmek" | Giriş / profil | — |
| Geljekki / Tamamlandy | Bölünişik, section header, count | Owadan list, ýagdaý | — |
| Bron tile | Bron #, sene/wagt, ýagdaý chip | Salon ady, hyzmat, ýatyrmak/reschedule | Parla: salon/hyzmat ady tile-da ýok; ýatyrmak (cancel) ýok |
| Täzelemek | RefreshIndicator, AppBar refresh | Pull to refresh | — |
| Boş | EmptyStateWidget, "Salonlara geçmek" | Empty | — |

---

## 10. Profil — Fresha vs Parla

| Element | Parla | Fresha (umuman) | Kemçilik |
|--------|--------|------------------|----------|
| Avatar | Initial (2 harp) ýa-da ikon | Surat / avatar | Parla: profil suraty ýok (camera/gallery) |
| Ad, telefon | Form, lokalde, +993 format | Profil, parol üýtgetmek | — |
| Jyns | Erkek / Zenan chip | Jyns saýlaw | — |
| Sazlamalar | AppBar → Settings | Sazlamalar | — |
| Bron geçmişi | Tab-da Meniň bronlarym | Profil içinde ýa-da link | — |

---

## 11. Bildirişler — Fresha vs Parla

| Element | Parla | Fresha (umuman) | Kemçilik |
|--------|--------|------------------|----------|
| List | Mock 3 sany (Täze arzanladyş, Bron tassyklandy...) | Hakyky bildirişler | Parla: backend ýok, "Hemmesini okalan et" işlemeýär |
| Empty | "Bildiriş ýok" | Empty | — |
| Okalan/okalan däl | Icon reňki (read: tertiary) | Görkeziş | — |

---

## 12. Arzanladyşlar (Deals) — Fresha vs Parla

| Element | Parla | Fresha (umuman) | Kemçilik |
|--------|--------|------------------|----------|
| List | Mock 3 deal, salon ady API-den (getSalons) | Arzanladyşlar, möhlet | Parla: deal-lar sabit, API ýok; möhlet (bitme sene) görkezilmeýär |
| Kart | Gradient, discount %, salon ady, tap → salon jikme-jik | Deal kart | — |
| Boş | "Häzir arzanladyş ýok" | Empty | — |

---

## 13. Sazlamalar — Fresha vs Parla

| Element | Parla | Fresha (umuman) | Kemçilik |
|--------|--------|------------------|----------|
| Dil | "Türkmençe", tap → "Ýakyn wagtda" | Dil saýlaw | Parla: placeholder |
| Garaňky rejim | "Ýakynda" | Dark mode | Parla: placeholder |
| Bildirişler | "Ýakynda" | Push sazlamalary | Parla: placeholder |
| Wersiýa | 1.0.0 | App wersiýa | — |
| Gizlinlik / Kömek | Tile bar, onTap boş | Sahypalar | Parla: mätin sahypalary ýok |
| Maglumatlary pozmak | Dialog, prefs clear | Logout / data delete | — |

---

## 14. Ähli kategoriýalar — Fresha vs Parla

| Element | Parla | Fresha (umuman) | Kemçilik |
|--------|--------|------------------|----------|
| Grid | 2 sütun, tegelek ikon, kategoriýa ady | Kategoriýa grid/list | — |
| Tap | → Salonlar listi (category) | → Filtrli list | — |

---

## 15. Synlar ekrany — Fresha vs Parla

| Element | Parla | Fresha (umuman) | Kemçilik |
|--------|--------|------------------|----------|
| List | Mock 3 syn (Aýna, Mähri, Gulya) | Hakyky synlar | Parla: API ýok, syn ýazmak ýok |
| Görkeziş | Avatar initial, reýting, mätin, wagt | Syn + jogap | — |

---

## 16. Galeriýa / Topar (staff) — Fresha vs Parla

Parla: Salon galeriýasy (suratlar) we Salon staff ekranlary bar; Fresha-da hem meňzeş. Parla-da staff we galeriýa maglumaty çäkli (mock ýa-da lokal).

---

## 17. Jemi — Fresha vs Parla UI (gysgaça)

| Bölüm | Parla güçli | Parla kemçilik (UI/UX) |
|--------|-------------|-------------------------|
| **Home** | Header, pill gözleg, kategoriýalar, arzanladyş strip, salon kartlar, favourite, boş sanaw, ýerleşiş filtiri | Reýting/uzaklyk mock, bölümler bir mazmun, iş wagty ýok, arzanladyş statik, çep fade ýok, "Bron et" kartda ýok, geljekki bron strip ýok, soňky görülen ýok |
| **Gözleg** | Input, soňky/meşhur statik, netije listi, boş netije | Soňky gözleg hakyky saklanmaýar, netije setirinde reýting/baha ýok, filtir ýok |
| **Ýerleşiş** | Şäher listi, chip | "Meniň ýerim" (GPS) ýok |
| **Salon list** | Card, skeleton | Sort ýok, listde favourite ýok |
| **Salon jikme-jik** | AppBar, karta, hyzmatlar, bron | Iş wagty mock, Ugur boş, syn/staff mock |
| **Bron** | Gün/slot, form, 409 | Töleg ýok |
| **Tassyklama** | Animasiýa, maglumat | Kalendara goşmak, ugur ýok |
| **Meniň bronlarym** | Geljekki/Tamamlandy, empty | Tile-da salon/hyzmat ady az, ýatyrmak (cancel) ýok |
| **Profil** | Ad, telefon, jyns | Surat ýok |
| **Bildirişler** | List UI, empty | Mock, backend ýok |
| **Deals** | Kartlar | Statik, API ýok |
| **Settings** | Bölümler, pozmak | Dil/dark/bildiriş placeholder, Gizlinlik/Kömek boş |
| **Synlar** | List UI | Mock, syn ýazmak ýok |

---

## 18. Home page kemçilikleri — deadline-a goşulanlar

Bu **Home page** kemçilikleri **PARLA_HOME_DEADLINE.xlsx** faýlyna täze setirler hökmünde goşuldy (Fresha vs Parla analizi boýunça):

| # | Wepaly | Deadline | Bölüm |
|---|--------|----------|--------|
| 1 | Reýting/syn salon kartda backend-den ýa-da aýdyň mock belgisi | 2026-03-20 | Salon kart |
| 2 | Uzaklyk salon kartda: GPS/ýerleşiş bilen ýa-da mock belgisi | 2026-03-20 | Salon kart |
| 3 | Bölümler (Maslahat berilýän/Meşhur/Täze): aýry data ýa-da aýdyň görkeziş | 2026-03-22 | Sahypa |
| 4 | Kartda Açyk/Ýapyk ýa-da iş wagty (backend taýýar bolsa) | 2026-03-22 | Salon kart |
| 5 | Arzanladyşlar: backend API ýa-da "Täzelikler ýakyn" mesajy | 2026-03-22 | Arzanladyşlar |
| 6 | Kategoriýa scroll: çep tarapda fade gradient | 2026-03-22 | Kategoriýalar |
| 7 | Salon kartda çalt "Bron et" düwmäsi (opsional) | 2026-03-25 | Salon kart |
| 8 | Boş netije (ýerleşiş): "Ýerleşişi üýtget" düwmäsi aýdyň | 2026-03-25 | Sanaw |
| 9 | Loading: shimmer efekt ýa-da skeleton täzelemek | 2026-03-25 | Umumy |
| 10 | Section semantics (Maslahat berilýän we ş.m.) accessibility | 2026-03-28 | Umumy |

Täzelemek: `python docs/build_parla_deadline_xlsx.py` → **PARLA_HOME_DEADLINE.xlsx** döredilýär.
