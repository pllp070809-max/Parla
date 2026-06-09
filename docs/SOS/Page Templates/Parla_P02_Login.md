PARLA

Design System

Components — v0.1

PAGE 02 — LOGIN / REGISTER

Telefon + OTP + profil gurluşy — 3 ädimli girizme


01 / FLOW

# Giriş prosesiniň 3 ädimi


Başla → TELEFON GIRIŞ → OTP → PROFIL → Baş sahypa



02 / TELEFON EKRANY

# Ädim 1 — Telefon belgisi


┌─────────────────────────────────────────────┐

│              [Parla logo]                   │

│                                             │

│   Salam! 👋                                │  ← Fraunces 32 italic

│   Telefon belgiňizi girizi                 │  ← body 15

│                                             │

│   Telefon belgisi                           │  ← label

│   ┌──────────────────────────────────────┐ │

│   │ +993 │  XX  XX - XX - XX              │ │  ← phone input

│   └──────────────────────────────────────┘ │

│                                             │

│   ☐ Ulanyjylyk şertleri bilen razy bolýaryn│  ← required checkbox

│                                             │

│           [SMS KOD AL   Primary]           │

└─────────────────────────────────────────────┘



03 / OTP EKRANY

# Ädim 2 — SMS kody


┌─────────────────────────────────────────────┐

│  [←]                                        │

│                                             │

│   Kody girizi                              │  ← title 24

│   +99361 ****78 belgisine kod iberildi     │  ← caption 13

│                                             │

│   ┌──┐ ┌──┐ ┌──┐    ┌──┐ ┌──┐ ┌──┐       │  ← 6 OTP input

│   │ 3│ │ 7│ │  │    │  │ │  │ │  │       │

│   └──┘ └──┘ └──┘    └──┘ └──┘ └──┘       │

│                                             │

│   Kody almadyňyzmy? Täzeden iber (58s)     │  ← countdown

└─────────────────────────────────────────────┘


DÜZGÜN — OTP 6-njy harp girilende awtomatik tassyklanýar — "Tassykla" düwmesine basma hökman däl. UX gowulanýar.


04 / PROFIL EKRANY

# Ädim 3 — Profil gurluşy


┌─────────────────────────────────────────────┐

│                                             │

│   Özüňiz hakda aýdyň                      │  ← title 24

│                                             │

│              [+ surat goş]                  │  ← 80px avatar, tap + edit

│                                             │

│   Adyňyz *                                  │

│   ┌────────────────────────────────────┐   │

│   │ Aman                               │   │

│   └────────────────────────────────────┘   │

│   Familiýaňyz (opsional)                    │

│   ┌────────────────────────────────────┐   │

│   │ Gurbanow                           │   │

│   └────────────────────────────────────┘   │

│                                             │

│           [BAŞLA   Primary Dark CTA]        │

└─────────────────────────────────────────────┘


## DOĞRY / NÄDOĞRY


🎉 DESIGN SYSTEM — 100%

# Parla Design System doly tamamlandy!


## Tamamlanan tapgyrlar

- ✓ Foundation (7 bölüm)  — Principles · Typography · Color · Spacing · Radius · Shadow · Motion
- ✓ Atoms (5)             — Button · Input · Badge+Chip · Avatar · Divider
- ✓ Molecules (5)         — FormField · ServiceCard · StatCard · ListItem · MasterCard
- ✓ Organisms (5)         — SalonHeader · BottomSheet · Modal · EmptyState · NavBar
- ✓ Templates (3)         — HomeScreen · SalonDetail · BookingFlow
- ✓ Pages (2)             — Onboarding · Login/Register

## Jemi sanaw

- 📄 27 sany doc faýl
- 🎨 44 sany reňk token + 13 alias
- 📐 10 spacing + 12 sizing token
- 🔘 8 radius token + 6 shadow token
- ⚡ 5 duration + 4 easing token
- 🧩 22 sany komponent (atoms + molecules + organisms)
- 📱 5 sany ekran template + page

— PARLA DESIGN SYSTEM TAMAM —


### Table 1

| ÄDIM | EKRAN | MAZMUNY | CTA |
| --- | --- | --- | --- |
| 1 | Telefon | +993 XX XX-XX-XX phone input + "Razy bolýaryn" checkbox | Kod al → |
| 2 | OTP | 6 hanaly SMS kody, countdown timer, täzeden iber | Tassykla → |
| 3 | Profil | At + familiýa + avatar (opsional) — täze ulanyjy üçin | Başla → |

### Table 2

| ELEMENT | SPEC |
| --- | --- |
| Logo | Ekran ýokarsy merkez, space-9 (96px) top margin |
| Başlyk | Fraunces 32px italic — "Salam! 👋" |
| Phone input | Atom 02 Phone variant — +993 prefix |
| Şertler checkbox | Required — tassyklanmasa CTA disabled |
| Şertler linki | text-link (brand-600), underline, browser-da açylýar |
| "SMS KOD AL" CTA | Primary, Large, full-width |

### Table 3

| ELEMENT | SPEC |
| --- | --- |
| OTP input | 6 aýratyn box, 48×56px, radius-md, auto-focus |
| Box arasy | space-2 (8px), ortada boşluk space-3 (12px) |
| Font | title 24 SemiBold, merkez |
| Aktif box | brand-500 border 1.5px + halo |
| Doldurylan box | border-default, text-primary |
| Countdown timer | 60s başlaýar, 0-da "Täzeden iber" aktif |
| Täzeden iber | Ghost düwme, countdown-da disabled + greyed |
| Auto-submit | 6-njy harp girilende awtomatik tassyklama |

### Table 4

| ELEMENT | SPEC |
| --- | --- |
| Avatar | size-avatar-lg 80px, tap → galerеýa/kamera seç |
| Avatar placeholder | neutral-100 bg + "+" icon brand-500 |
| At input | Required, auto-capitalize, autocomplete="given-name" |
| Familiýa input | Opsional, autocomplete="family-name" |
| "BAŞLA" CTA | Dark CTA, full-width — at girilende aktif |
| Skip opsiony | "Soňra" ghost link — profil gurluşy opsional |

### Table 5

| DOĞRY | NÄDOĞRY |
| --- | --- |
| OTP 6-njy harpda auto-submit | Ulanyjy "Tassykla" basyp durýar |
| Countdown timer täzeden iber-de | Derrew täzeden iberip bolar |
| Profil opsional ("Soňra") | Profil hökman — ulanyjy bloklanýar |
| Şertler checkbox required | Şertler diňe tekst — kabul etme ÝOK |
| Phone autocomplete="tel" | Keyboard type adaty — san klawiatura açylmaýar |