# Fresha bilen Parla — Edilmedik zatlar (Home + içki sahypalar)

**Sene:** 28.02.2026

Bu sanawda **Fresha-da bar, Parla-da heniz edilmedik** (ýa-da diňe mock/placeholder) zatlar bar. Salon içine girenden soňky ähli ekranlar hem goşuldy.

---

## 1. Home page (Sahypa)

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 1 | Reýting we syn sany backend-den gelmeýär | Kartda id boýunça hasaplanylyar (mock) |
| 2 | Uzaklyk hakyky GPS-den gelmeýär | Kartda ~X km id-den (mock) |
| 3 | "Maslahat berilýän" / "Meşhur" / "Täze Parla-da" aýry mazmun ýok | Hemmesi bir sanaw, tertip üýtgeýär |
| 4 | Kartda "Açyk" / "Ýapyk" ýa-da iş wagty ýok | Fresha "Open now" görkezýär |
| 5 | Arzanladyşlar backend-den gelmeýär | 3 sany sabit deal, API ýok |
| 6 | Soňky gözlegler hakyky saklanmaýar | Gözleg ekranynda diňe statik sözler |
| 7 | "Siziň geljekki bronyňyz" strip ýok | Home-da geljekki bron karty ýok |
| 8 | "Soňky görülen salonlar" bölümi ýok | — |
| 9 | Wagt bilen salamlaşyk ýok | "Gündeniz haýyrly" ýaly ýok |

---

## 2. Salon jikme-jik (bir salonyň içi — detail)

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 10 | Iş wagty backend-den gelmeýär | Duş–Şen 09:00–20:00 mock; "Open now" ýok |
| 11 | **"Ugur" (directions) düwmäsi işlemeýär** | onPressed: () {} boş; Maps/Navigator açylmaýar |
| 12 | Synlar hakyky API-den gelmeýär | Synlar ekrany mock (Aýna, Mähri, Gulya) |
| 13 | Syn ýazmak funksiýasy ýok | Fresha-da müşderi syn goşup biler |
| 14 | Topar (staff) mock | Salon staff ekrany hakyky ussallar sanawy däl |
| 15 | Salonda reýting/syn jikme-jikde görkezilmeýär | Başda reýting/jem syn sany ýok (diňe "Synlar" tile) |

---

## 3. Karta (salon jikme-jik içinde)

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 16 | Full screen kartada "Ugur" düwmäsi işlemeýär | Salon salgysyna ugur açylmaýar |
| 17 | Ugur açanda Maps/Google Maps ýa-da platform navigasiýasy ýok | Backend/API gerek däl, link ýa-da url_launcher |

---

## 4. Bron ekrany

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 18 | Öňünden töleg ýok | Fresha-da töleg saýlaw bar; Parla-da ýok |
| 19 | Bron soň SMS/email yatladyryş ýok | Backend bildiriş API taýýar bolmaly |

---

## 5. Tassyklama ekrany (bron edilenden soň)

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 20 | "Kalendara goşmak" ýok | Brony günlüge goşup bolmaýar |
| 21 | "Salona ugur" / navigasiýa düwmäsi ýok | Tassyklamadan soň ugur açylmaýar |

---

## 6. Meniň bronlarym

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 22 | Bron tile-da salon ady we hyzmat ady görkezilmeýär | Diňe Bron #, sene/wagt, ýagdaý |
| 23 | **Bron ýatyrmak (cancel) ýok** | Düwmä we backend PATCH/DELETE ýok |
| 24 | Reschedule (wagty üýtgetmek) ýok | Fresha-da mümkin |

---

## 7. Profil

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 25 | **Profil suraty ýok** | Camera/gallery, avatar goşup bolmaýar |

---

## 8. Bildirişler

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 26 | Bildirişler backend-den gelmeýär | Mock 3 sany; hakyky list ýok |
| 27 | "Hemmesini okalan et" işlemeýär | Backend we state gerek |

---

## 9. Arzanladyşlar (Deals)

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 28 | Deal-lar backend API-den gelmeýär | 3 sany sabit; möhlet (bitme sene) görkezilmeýär |

---

## 10. Gözleg ekrany

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 29 | Soňky gözlegler hakyky saklanmaýar | SharedPreferences ýa-da ýaly zat bilen saklanmaly |
| 30 | Netije setirinde reýting we baha ýok | Diňe salon ady, salgy |
| 31 | Gözleg filtiri ýok | Kategoriýa, reýting, wagt sort/filtr ýok |

---

## 11. Ýerleşiş saýlaw

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 32 | **"Meniň ýerim" (GPS) ýok** | Diňe şäher listi; GPS bilen ýerleşiş saýlaw ýok |

---

## 12. Salonlar listi (kategoriýa / gözleg netijesi)

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 33 | Sort ýok | Reýting, uzaklyk, baha boýunça sort ýok |
| 34 | Listde favourite ikony ýok | Home-da bar, bu ekranda ýok |

---

## 13. Sazlamalar

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 35 | Dil saýlaw işlemeýär | "Ýakyn wagtda" placeholder |
| 36 | Garaňky rejim (Dark mode) ýok | "Ýakynda" placeholder |
| 37 | Bildirişler sazlamalary ýok | "Ýakynda" placeholder |
| 38 | Gizlinlik syýasaty sahypasy boş | onTap boş |
| 39 | Kömek / Habarlaşmak sahypasy boş | onTap boş |

---

## 14. Synlar ekrany (salon jikme-jikden "Synlar" basylanda)

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 40 | Synlar listi backend-den gelmeýär | Mock 3 syn |
| 41 | **Syn ýazmak formy ýok** | Müşderi syn goşup bilmeýär |

---

## 15. Galeriýa / Topar (salon içinden)

| # | Edilmedik | Bellik |
|---|-----------|--------|
| 42 | Galeriýa suratlary backend-den gelmeýär | Salon modelinde çäkli |
| 43 | Topar (staff) hakyky ussallar sanawy däl | Mock / placeholder |

---

## Jemi — prioritet boýunça (gysgaça)

| Prioritet | Nämä (edilmedik) |
|-----------|-------------------|
| **Ýokary** | Ugur (directions) işletmek; Bron ýatyrmak (cancel); Reýting/syn we iş wagty backend-den |
| **Orta** | Profil suraty; Bildirişler we Deals API; Soňky gözlegler saklamak; Meniň bronlarym-da salon/hyzmat ady; Syn ýazmak; Gizlinlik/Kömek sahypalary |
| **Pes** | "Meniň ýerim" GPS; Sort/filtr gözlegde; Dark mode / Dil; Geljekki bron strip; Soňky görülen salonlar; Kalendara goşmak; Töleg |

---

*Çeşme: FRESHA_VS_PARLA_UI_ANALIZ.md we häzirki kod (home_screen, salon_detail_screen, booking_screen, my_bookings_screen we ş.m.).*
