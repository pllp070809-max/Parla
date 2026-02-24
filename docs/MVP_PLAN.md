# Parla MVP – Jikme-jik plan

## Umumy
- **Taslama:** Parla (Shine) – salon / gözellik / barber / spa bron (Fresha stilinde)
- **MVP çäkleri:** Diňe müşderi app; giriş ýok; profil = ad + telefon; "Meniň bronlarym" = ulanyjy diňe nomerini girizýär (SMS/jan ýok)

---

## 1. Müşderi app – ekranlar

| # | Ekran | Wepaly |
|---|--------|--------|
| 1 | **Sahypa (Home)** | Salonlar/kategoriýalar, göni axtarış |
| 2 | **Salonlar listi** | Karta ýa-da list, salon ady, ýer, reýting |
| 3 | **Salon jikme-jik** | Surat, hyzmatlar, boş wagtlar, "Bron et" |
| 4 | **Bron** | Hyzmat saýlama → wagt saýlama → ad + telefon → tassyklama |
| 5 | **Tassyklama** | "Bron edildi", bron belgisi |
| 6 | **Meniň bronlarym** | Telefon nomerini girizýär → şol nomere degişli bronlar |
| 7 | **Profil** | Diňe ad + telefon (ýazyp saklamak/üýtgetmek) |

### 1b. User flow (ekranlar we geçişler)

| Ekran | Görkezilýär | Nirä geçilýär |
|--------|-------------|----------------|
| **Sahypa** | Kategoriýalar (Salon, Barber, Spa, Gözellik), axtarış; opsional: öňe çykan salonlar | Kategoriýa/axtarış → Salonlar listi; salon karta → Salon jikme-jik |
| **Salonlar listi** | Salonlar: ad, salgy, surat, kategoriýa | Salon saýlansa → Salon jikme-jik; Yza → Sahypa |
| **Salon jikme-jik** | Surat, ad, salgy, hyzmatlar (ad, möhlet, baha), "Bron et" | "Bron et" → Bron; Yza → Salonlar listi |
| **Bron** | Hyzmat saýlama → gün → wagt (slot) → ad + telefon → "Tassyklamak" | "Tassyklamak" → Tassyklama; Yza → Salon jikme-jik |
| **Tassyklama** | "Bron edildi", salon/hyzmat/wagt, bron belgisi | Sahypa ýa-da Meniň bronlarym |
| **Meniň bronlarym** | Telefon input, "Görmek" → bronlar listi (salon, hyzmat, wagt, ýagdaý) | Bottom bar → Sahypa / Profil |
| **Profil** | Ad, telefon input, "Saklamak" (lokalde) | Bottom bar → Sahypa / Meniň bronlarym |

**Navigasiýa:** Aşakda bottom bar – 3 düwmä: **Sahypa** | **Meniň bronlarym** | **Profil**. Bron zynjyry: Sahypa → Salonlar listi → Salon jikme-jik → Bron → Tassyklama.

---

## 2. Backend – API (Python FastAPI)

### Tablisalar (DB)
- **salons** – ad, salgy, surat, kategoriýa (salon/barber/spa/...)
- **services** – salon_id, ad, dowamlylygy (min), bahasy (MVP-da opsional)
- **time_slots** – salon/hyzmat üçin elýeterli wagtlar (ýa-da hasaplanyan)
- **bookings** – salon_id, service_id, müşderi ady, telefon, wagt, ýagdaý (tassyklanan/berilen)

### Endpointler (MVP)
- `GET /salons` – salonlar listi (filtr: kategoriýa)
- `GET /salons/{id}` – bir salon jikme-jik (hyzmatlar bilen)
- `GET /salons/{id}/slots` – berilen gün üçin boş wagtlar (query: date, service_id – hyzmatyň duration-y boýunça çaknaşma hasaplanýar)
- `POST /bookings` – täze bron (ady, telefon, salon_id, service_id, wagt)
- `GET /bookings?phone=...` – nomere görä bronlar (SMS/jan ýok, diňe query)
- Profil: MVP-da frontend-de saklanyp biler (SharedPreferences); isleseň `POST /guest` soň

### Logika we Backend (möhüm)

- **Hyzmatyň dowamlylygy we slotlar:** Boş wagtlary hasaplanda diňe başlanýan wagt däl, **saýlanan hyzmatyň dowamlylygy (duration)** hem hasaba alynýar. Meselem: "Massaž" 60 minut bolsa, 10:00-da massaž bron edilse, 10:30 sloty hem awtomatiki ýapylýar (şol 60 min içindäki ähli slotlar doly). Backend `GET /salons/{id}/slots` berilen gün + saýlanan hyzmat (service_id) bilen çagyrylanda, bar bolan bronlary we olaryň hyzmatlarynyň duration-laryny göz öňünde tutup diňe elýeterli slotlary gaýtarýar.
- **Telefon nomeriniň standart formady:** "Meniň bronlarym" diňe nomer arkaly işleýändigi üçin, **nomer formaty berk bellenmeli**. Saklamak we gözleg wagtynda hemişe bir format (mysal: **+993XXXXXXXX** – boşluk/defis-siz, +993 bilen). Ulanyjy "65..." ýazsa app ony **+99365...** hökmünde normalizir edýär (girişde we GET /bookings?phone= çagyrylanda). Şeýle etmezlik öňki bronlary tapylmayar.
- **Bir wagtyň özünde bron (concurrency):** Iki müşderi şol bir salon üçin takyk bir wagtda "Tassyklamak" bassa, backend **diňe birini** kabul edip, ikinjisine **409 Conflict** ýa-da aýdyň habar: "Bagyşlaň, bu wagt eýýäm alyndy" gaýtarmaly. DB-de **constraint** goýulýar: meselem salon_id + slot_at (we/ýa-da slot soňy) üçin unique ýa-da check, şol aralykda çaknaşýan bron bolup bilmez.

---

## 2b. Dizayn (MVP) – ylalaşylan

- **Parla (Shine) – many we renk:** "Parla" = parlaklyk, ýagtylyk. **Esasy reňk sazlama (biraz goýurak cyan):**
  - **Primary (esasy):** #00ACC1 (Cyan 600) – düwmeler, bottom bar saýlanan, esasy UI.
  - **Secondary (ýagty vurgu):** #00BCD4 (Cyan 500) – hover, ikonlar, kiçi vurgular.
  - **Açyk (opsional):** #26C6DA (Cyan 400) – arka vurgu, has ýagty ýerler.
  Arka plan ak ýa-da çökgün ak; mät gara/goýu çal. Üýtgeşik reňk ýok – arassagy we yzygiderli.
- **Dereje:** Senior UI/UX – typography, spacing, ierarhiýa we kontrast professional. Netije: gymmat görünmeli, arassagy we sada, oňat okalýan.
- **Platforma:** Material 3 (Flutter); esasy reňk tema; arassagy komponentler.
- **Font:** Bir sözbaşy, bir gövde – aýdyň we okalýan; ierarhiýa sylag.
- **Bottom bar we düwmeler:** Az reňk, belli hereketler; esasy reňk wagt-wagtda vurguly. Gymmat duýgusy – boşluk we tertip bilen.

### 2c. Dizayn we UX (ulanyjy tejribesi)

- **Boş ýagdaýlar (empty states):** "Meniň bronlarym" bölümünde bron ýok wagty (ýa-da ilkinji giriş) boş ekran däl, **owadan boş ýagdaý**: "Siziň entäk bronyňyz ýok" ýazgy we "Salonlara geçmek" düwmesi. Şeýle-de axtarış netijesi ýok, salonlar listi boş ýaly ýerlerde gerek bolsa gysga mesel/empty state.
- **Wagt / gün saýlamak (bron ekrany):** Tutuş aýyň uly kalendarynyň ýerine **gorizontal aýlanýan günler**: Şu gün, Ertir, we indiki 5–7 gün ekranyň ýokarsynda – has tiz we "premium" duýgusy.
- **Köne bronlar:** "Meniň bronlarym" listinde wagty geçen bronlar **iň aşakda** ýa-da açyk çal reňkde **"Tamamlandy"** diýip bölüp görkezmek – logika taýdan dogry we anyk.

---

## 3. Tehnologiýalar
- **Frontend:** Flutter, Riverpod, http/dio
- **Backend:** Python, FastAPI, SQLite (MVP) / PostgreSQL (soň)
- **Auth:** MVP-da ýok; "Meniň bronlarym" = diňe telefon parametry bilen

---

## 3b. Maglumat / mazmun (MVP) – ylalaşylan

- **Salonlar we hyzmatlar nädip girizilýär (MVP):** Business app MVP-da ýok. Teklip: backend-de **seed skript** (bir gezek işledilýär) – 1–3 sany test salony we her salonda 2–4 sany hyzmat DB-e goşulýar. Soňra isleseň DB-e el bilen (SQL/Adminer) ýa-da kiçi admin endpoint (POST /salons, POST /services) goşup bileris.
- **Boş wagtlar (slots):** Backend berilen gün üçin **hasaplaýar** (meselem 09:00–18:00, 30 min aralyk); alnan bronlar şol gündäki slotlary "doly" edip çykarýar. Aýratyn time_slots tablisasy MVP-da gerek däl – hasaplanyan.
- **Test maglumatlary:** Seed-de meselem: "Parla Salon" (salon), "Style Barber" (barber), "Relax Spa" (spa); hyzmatlar: Saç kesim 30 min, Sakal 15 min, Massaž 60 min we ş.m. Bahalary opsional.
- **Müşderi ady/telefon:** Bron wagty app-da girizilýär; backend-e diňe bron (POST /bookings) bilen gidýär. Profil lokalde (telefon) saklanýar.
- **Suratlar (salon):** MVP üçin **Flutter içinde lokal asset** (assets/images/salon1.png we ş.m.). Backend-de salon üçin diňe faýl ady ýa-da key (meselem "salon1") saklanýar; app şony lokal surata öwrýär. Statik faýl/URL backend-den MVP-da gerek däl – has çalt we aňsat.
- **Brony ýatyrmak (cancel):** MVP-da **diňe görmek** – "Meniň bronlarym" ekranynda bronlary list etmek, ýatyrmak funksiýasy ýok. Soň goşup bileris (PATCH/DELETE booking, ýagdaý = cancelled).

---

## 4. Implementasiýa tertibi we dowam etmek – teklipler

**Ädim 1 – Backend (Python FastAPI)**  
- Taslama: `parla_backend/` (requirements.txt, main.py, database, models, schemas).  
- DB: SQLite, tablisalar salons, services, bookings (duration + concurrency logic).  
- API: GET /salons, GET /salons/{id}, GET /salons/{id}/slots?date=&service_id=, POST /bookings, GET /bookings?phone= (telefon normalizasiýa).  
- Seed skript: 2–3 salon, 2–4 hyzmat, lokal surat key-leri.

**Ädim 2 – Flutter: tema we gurluş**  
- Riverpod, http/dio; API base URL config.  
- Material 3 tema: primary #00ACC1, secondary #00BCD4.  
- Papka: lib/screens, lib/widgets, lib/services, lib/models; bottom bar (Sahypa, Meniň bronlarym, Profil).

**Ädim 3 – Flutter: ekranlar tertip bilen**  
- Sahypa (kategoriýalar, axtarış) → Salonlar listi → Salon jikme-jik (hyzmatlar, "Bron et").  
- Bron: hyzmat → gorizontal günler (Şu gün, Ertir, +5–7) → slotlar → ad + telefon (normalizasiýa) → Tassyklama.  
- Tassyklama ekrany; Meniň bronlarym (telefon input, list, empty state, köne bronlar "Tamamlandy"); Profil (ad + telefon lokalde).

**Ädim 4 – Birikdirmek we test**  
- Backend + Flutter birikdirip, seed işledip, bron we "Meniň bronlarym" yzygiderli synag.

Razy bolsaň **Ädim 1 (Backend)**-den başlaýarys.
