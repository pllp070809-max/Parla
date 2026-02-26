# Parla – Jemleýji (her ädimde täzelenýär)

**Jikme-jik maglumat:** [MVP_PLAN.md](MVP_PLAN.md) – bu faýl diňe gysgaça jem we ädimleri yzarlaýar.

---

## Häzir
- **Planning tamamlandy.** Režim: **implementasiýa** (plana görä kod). Teklipler: MVP_PLAN.md §4.
- **App işleýär:** Fiziki telefon (SM S931B) we Chrome-da run edilýär. Backend birikdirildi (WiFi IP üsti bilen).
- **Yza dolanmak:** Git ilkinji commit edildi (plan taýýar, kod başlamadyk). Bir zat ýalňyş bolsa: `git log` bilen commit gör, soň `git checkout 020b22a` ýa-da `git reset --hard 020b22a` bilen şu ýagdaýa dolan.

---

## Indiki ädim
**Ädim 4 – Birikdirmek we test** (resmi synag, kiçi düzetmeler) – soň dowam ederis.

## Tamamlanan ädimler
- **Ädim 1 – Backend** ✅ (FastAPI, SQLite, 5 endpoint, seed – 3 salon, 7 hyzmat, doly işleýär).
- **Ädim 2 – Flutter tema we gurluş** ✅ (Riverpod, Material 3 tema, models, API service, bottom bar, 7 placeholder ekran).
- **Ädim 3 – Flutter ekranlar** ✅ (7 ekran hakyky UI bilen: Home, SalonsList, SalonDetail, Booking, Confirmation, MyBookings, Profile).
- **Backend birikdirmek** ✅ (config.dart `kApiHostOverride` = kompýuter WiFi IP; fiziki tel we backend bir WiFi-de).
- **Dizayn kämilleşdirmek** ✅ (tema: arka plan, kartalar, bottom bar öz görnüşi, empty state "Salonlara geçmek" düwmesi).

---

## Run / synag üçin bellenmeli
- **Backend:** `cd parla_backend` → `python -m uvicorn main:app --host 0.0.0.0 --port 8000`
- **Fiziki telefon:** USB bagla, USB debugging açyk. `parla_app/lib/config.dart`-da `kApiHostOverride` = kompýuteriň WiFi IP-si (mysal: `192.168.31.165`). Telefon we kompýuter bir WiFi-de bolmaly.
- **App telefonda:** `cd parla_app` → `flutter run -d RFCY722E15K --android-skip-build-dependency-validation` (ýa-da `flutter run -d android`).
- **App Chrome-da:** `cd parla_app` → `flutter run -d chrome`

---

## Keçen ädimler (birlikde ylalaşylanlar)
1. MVP çäkleri, 7 ekran, backend (tablisalar/endpointler), tehnologiýalar → MVP_PLAN.md.
2. User flow (ekranlar, geçişler, bottom bar) → MVP_PLAN.md §1b.
3. Dizayn (reňk #00ACC1/#00BCD4, font, bottom bar) – ylalaşylan → MVP_PLAN.md §2b.
4. Maglumat/mazmun (seed, slots hasaplanýar, test maglumatlary) – ylalaşylan → MVP_PLAN.md §3b.

---

## Günlük jem
Aýry faýllarda, **sene ady bilen:** `docs/gunluk/YYYY-MM-DD.md` (mysal: [2025-02-26](gunluk/2025-02-26.md)). Her gün üçin bir faýl – şol gün edilen işler gysgaça ýazylýar.
