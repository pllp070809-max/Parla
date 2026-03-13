# Parla — Programmanyň şuwagtky ýagdaýy we professional derejä çykmak üçin işler

**Sene:** 28.02.2026

Bu dokument **diňe programmanyň** (mobil app + backend) häzirki analizini we **haýsy wagta çenli haýsy işleri** etmeli bolandygyny görkezýär. Marketing we biznes planlar bu ýerde ýok.

**Şuwaglykça:** Diňe **Home page (Sahypa)** – has detalny deadline **PARLA_HOME_DEADLINE.xlsx** faýlynda we aşakdaky tablisada.

---

## 0. Home page (Sahypa) deadline – diňe Sahypa

Esasy faýl: **docs/PARLA_HOME_DEADLINE.xlsx** (Excel – süzgüç, Ýagdaý dropdown, özet sahypalary).

| Deadline | Bölüm | Işler (gysgaça) |
|----------|--------|------------------|
| **2026-03-12** | Header | Gözle başlygy, ýerleşiş chip, bildiriş ikony/badge, profil initial. |
| **2026-03-12** | Gözleg | Pill gözleg (search bar), semantics, haptic. |
| **2026-03-14** | Kategoriýalar | Chip listi, scroll sag fade, tap → salonlar. |
| **2026-03-14** | Arzanladyşlar | Gradient fon, badge (mysal: 2 gün). |
| **2026-03-15** | Salon kart | Material/InkWell, favourite ýürek animasiýasy, semantics, haptic. |
| **2026-03-15** | Sanaw, Ýerleşiş | Boş sanaw mesajy; ýerleşiş filtiri (chip bilen). |
| **2026-03-16** | Umumy | RefreshIndicator, loading/error görkezişi. |

XLSX-de her bir iş aýry setirde, **Bölüm** (Header, Gözleg, Kategoriýalar, …) we **Deadline** boýunça süzüp we sort edip bileriň.

---

## 1. Şuwagtky ýagdaý (analiz)

### 1.1 Mobil app (Flutter)

| Bölüm | Ýagdaý | Bellik |
|-------|--------|--------|
| **Sahypa (Home)** | Taýýar | Kategoriýalar, pill gözleg, ýerleşiş chip, arzanladyşlar (gradient), favourite (lokalde), salon kartlar, boş sanaw, ýerleşiş filtiri. |
| **Salonlar listi** | Taýýar | Karta/list, salon ady, ýer, kategoriýa. |
| **Salon jikme-jik** | Taýýar | Surat, hyzmatlar, "Bron et". |
| **Bron** | Taýýar | Hyzmat → gün → wagt → ad + telefon → backend-e POST. |
| **Tassyklama** | Taýýar | "Bron edildi", bron belgisi. |
| **Meniň bronlarym** | Taýýar | Telefon (profilden) → GET /bookings?phone=; empty state, "Tamamlandy" bölümi. |
| **Profil** | Taýýar | Ad + telefon (SharedPreferences); initial badge. |
| **Bottom nav** | Taýýar | Sahypa \| Meniň bronlarym \| Profil. |
| **API birikmesi** | Taýýar | getSalons, getSalonDetail, getSlots, createBooking, getBookings – backend bilen işleýär. |
| **Config** | Çäklendirme | `config_io.dart`: lokal IP (WiFi) üçin override bar; production URL üçin build-time/remote config gerek. |
| **Bildirişler** | Placeholder | Ekran bar, mazmun/backend ýok. |
| **Reýting/syn** | Placeholder | UI bar, API ýok. |
| **Bron ýatyrmak** | Ýok | "Meniň bronlarym"-da cancel düwmäsi we API ýok. |
| **Profil suraty** | Ýok | Goşup bolmaýar. |
| **Offline / error** | Böl-böl | API ýalňyşlygy gösterilýär; offline režim ýok. |

### 1.2 Backend (FastAPI + SQLite)

| Bölüm | Ýagdaý | Bellik |
|-------|--------|--------|
| **Salonlar** | Taýýar | GET /salons (filtr: category), GET /salons/{id}. |
| **Boş wagtlar** | Taýýar | GET /salons/{id}/slots?date=&service_id= – duration we çaknaşma hasaplanýar. |
| **Bron** | Taýýar | POST /bookings – telefon normalizasiýa, 409 conflict (bir wagt alyndy). |
| **Meniň bronlarym** | Taýýar | GET /bookings?phone=. |
| **DB** | Taýýar | SQLite, salons, services, bookings. Seed skript bar. |
| **Production serwer** | Ýok | Diňe lokal uvicorn (dev). |
| **HTTPS / domain** | Ýok | HTTP, localhost/LAN. |
| **Giriş (auth)** | Ýok | SMS/jan tassyklama ýok; islendik adam islendik nomeriň bronlaryny görip biler. |
| **Güvenlik** | Çäklendirme | CORS \* (hemme ýere açyk); rate limiting ýok. |
| **Backup** | Ýok | DB backup ýok. |
| **Reýting/syn API** | Ýok | Ýok. |
| **Bildirişler API** | Ýok | Push / in-app bildirişler üçin endpoint ýok. |
| **Bron ýatyrmak** | Ýok | PATCH/DELETE booking (cancelled) ýok. |
| **Arzanladyşlar API** | Ýok | Deals häzir app-da mock/statik. |

### 1.3 Jemi (gysgaça)

- **App:** Esasy flow taýýar (sahypa → salon → bron → tassyklama, meniň bronlarym, profil). API bilen birikýär. Kemçilikler: config production üçin, bildirişler/reýting placeholder, bron ýatyrmak ýok, profil suraty ýok.
- **Backend:** MVP API taýýar; production, HTTPS, auth, güvenlik, backup, reýting, bildirişler, bron cancel ýok.

---

## 2. Doly professional derejä çykmak üçin gerek işler

Bu bölümde **diňe programma** (app + backend) boýunça işler we **haýsy wagta çenli** tamamlamaly (deadline) sanawda. Marketing we şertnama işleri bu sanawa girmeýär.

- **Şuwaglykça (diňe Home page):** Sanaw **PARLA_HOME_DEADLINE.xlsx** – Sahypa boýunça has detalny işler.
- **Soňra (doly UI / programma):** **PARLA_UI_DEADLINE.xlsx** ýa-da **PARLA_PROGRAMMA_DEADLINE.xlsx** – ähli ekranlar / backend boýunça ulanyp bileriň.

---

### 2.1 Backend

| # | Wepaly | Deadline (çenli) | Dereje |
|---|--------|-------------------|--------|
| 1 | Production serwer (HTTPS, domain) – app internetden backend-e girebilmelidir | 2026-04-30 | Ýokary |
| 2 | Giriş / tassyklama (SMS ýa-da Telegram jan) – bronlary diňe tassyklanandan soň görmek | 2026-04-30 | Ýokary |
| 3 | Backup we güvenlik: DB backup, CORS çäklemek, rate limiting | 2026-04-30 | Orta |
| 4 | Bron ýatyrmak: PATCH/DELETE booking (ýagdaý = cancelled) | 2026-05-15 | Orta |
| 5 | Bildirişler API (push / in-app) – bron yatladyryş, täzelikler | 2026-05-31 | Orta |
| 6 | Reýting we syn API (salonlar üçin) | 2026-06-30 | Orta |
| 7 | Arzanladyşlar API (deals backend-den) – islense | 2026-06-30 | Pes |

### 2.2 Mobil app

| # | Wepaly | Deadline (çenli) | Dereje |
|---|--------|-------------------|--------|
| 8 | Production URL config – APK-da serwer adresi hardcoded bolmasyn (build flavor / remote config) | 2026-04-30 | Ýokary |
| 9 | APK ýaýlym – Play Store ýa-da direct link bilen ýüklenip biler ýagdaýy | 2026-04-30 | Ýokary |
| 10 | Giriş ekrany (SMS/jan tassyklama) – backend auth taýýar bolandan soň | 2026-04-30 | Ýokary |
| 11 | Bron ýatyrmak – "Meniň bronlarym"-da "Ýatyrmak" düwmäsi we API çagyryşy | 2026-05-15 | Orta |
| 12 | Bildirişler – backend API bilen birikdirmek, push (FCM) islense | 2026-05-31 | Orta |
| 13 | Reýting/syn – salon jikme-jik we listde reýting/syn görkezmek, syn ýazmak (API taýýar bolandan) | 2026-06-30 | Orta |
| 14 | Offline / internet ýok mesajy we täzeden synag | 2026-05-31 | Orta |
| 15 | Arzanladyşlar backend-den çekmek (API bar bolsa) | 2026-06-30 | Pes |
| 16 | Profil suraty (goşmak / camera/gallery) | 2026-06-30 | Pes |

---

### 2.2 Sene boýunça özet

- **2026-04 (Aprel):** Production serwer + HTTPS, auth (SMS/jan), backup + güvenlik, app production URL + APK, giriş ekrany.
- **2026-05:** Bron ýatyrmak (backend + app), bildirişler API + app, offline/error mesajy.
- **2026-06:** Reýting/syn API + app, arzanladyşlar API (islense), profil suraty (islense).

**Täzelemek:** Home deadline üçin `python docs/build_parla_deadline_xlsx.py` işlediň – **PARLA_HOME_DEADLINE.xlsx** döredilýär.
