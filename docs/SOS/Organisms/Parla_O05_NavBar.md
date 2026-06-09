PARLA

Design System

Components — v0.1

ORGANISM 05 — NAVIGATION BAR

Aşaky tab bar — esasy nawigasion


01 / MANYSY

# Bottom Navigation Bar

Bottom tab bar — Parla-nyň esasy nawigasion elementi. Her tab — bir esasy bölüm. Ulanyjy Parla-ny açanda şuny görýär we şu bilen hereket edýär.


┌───────────────────────────────────────────┐

│                                            │

│   Sahypa content                           │

│                                            │

├───────────────────────────────────────────┤

│  [🏠]      [🔍]      [📅]      [👤]       │  ← tab bar

│  Baş      Gözleg    Bron     Profil       │

│   ●                                       │  ← aktif indicator

└───────────────────────────────────────────┘  ← safe area


02 / TAB SANY

# 4 tab — Parla üçin optimal

Apple HIG: 3-5 tab. 3-den az — az mazmun. 5-den köp — ykjamly görünmeýär. Parla 4 tab saýlaýar.



03 / SPEC

# Navigation Bar spec



04 / AKTIF STATE

# Aktif vs Inaktif tab



05 / NOTIFICATION BADGE

# Tab-da notification

Bronlar tab-ynda täze/garaşylýan bron bolsa — count badge (Atom 03).


DÜZGÜN — Badge diňe Bronlar tab-ynda. Baş sahypa, Gözleg, Profil tab-ynda badge ÝOK.

06 / SAFE AREA

# iOS / Android safe area

iPhone X we täzelerinde aşaky Home Indicator — bar padding "safe area" gerek.


DÜZGÜN — Flutter-da MediaQuery.padding.bottom bilen safe area auto hasaplanýar. Hardcode ÝOK.

## DOĞRY / NÄDOĞRY


🎉 ORGANISMS — 100%

# Ähli organism-lar tamamlandy!

Foundation + Atoms + Molecules + Organisms — Parla Design System-iň dört gatlagy doly.


## Tamamlanan organism-lar

- ✓ Organism 01 — Salon Detail Header
- ✓ Organism 02 — Bottom Sheet
- ✓ Organism 03 — Modal
- ✓ Organism 04 — Empty State
- ✓ Organism 05 — Navigation Bar

## Indiki tapgyr — Templates & Pages

Häzire çenli guran zatlarymyzy birleşdirip real Parla ekranlary ýasaýarys.

- Template 01 — Home Screen layout
- Template 02 — Salon Detail layout
- Template 03 — Booking Flow layout
- Page 01 — Onboarding / Welcome
- Page 02 — Login / Register

— Templates & Pages başlaýarys —


### Table 1

| TAB | IKON | AT | MAZMUNY |
| --- | --- | --- | --- |
| 1 | 🏠 | Baş sahypa | Maslahat beriş salonlar, kampaniýalar |
| 2 | 🔍 | Gözleg | Salon gözleg, filter, karta |
| 3 | 📅 | Bronlar | Häzirki we geçen bronlar |
| 4 | 👤 | Profil | Ulanyjy profili, sazlamalar |

### Table 2

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Height | 56px + safe area bottom (iPhone X+) |
| Background | bg-card (neutral-0) + blur (overlay-blur) |
| Top border | 1px border-default |
| Top shadow | shadow-sm (top-shadow) |
| Ikon ölçeg | size-icon-md (24px) |
| At font | micro 11 Regular |
| Ikon-at gap | 4px (space-1) |
| Tap area | 100% / 4 (ýekebir tab) |
| Aktif indicator | 4×4px tegelek, brand-500, ikon aşagy |

### Table 3

| ATRIBUT | AKTIF | INAKTIF |
| --- | --- | --- |
| Ikon reňk | brand-500 | neutral-400 |
| At reňk | brand-500 | neutral-400 |
| At font weight | Medium (500) | Regular (400) |
| Indicator dot | bar — brand-500 | ýok |
| Tap animation | scale 0.9 → 1.0, instant | — |

### Table 4

| ÝAGDAÝ | BADGE | POZISIÝA |
| --- | --- | --- |
| Täze bron tassyklandy | ● dot (san ýok) | Ikon sag ýokary |
| 1-9 garaşylýan | San badge (e.g. 3) | Ikon sag ýokary |
| 10+ garaşylýan | "9+" badge | Ikon sag ýokary |

### Table 5

| PLATFORMA | SAFE AREA | UMUMY HEIGHT |
| --- | --- | --- |
| iPhone (Face ID) | 34px | 56 + 34 = 90px |
| iPhone (Touch ID) | 0px | 56px |
| Android (gesture nav) | 16-24px | 56 + 16-24px |

### Table 6

| DOĞRY | NÄDOĞRY |
| --- | --- |
| 4 tab — optimal | 6+ tab — gysylan, barmak basyp bilmez |
| Ikon + at label | Diňe ikon (at ýok) — manysy düşüniksiz |
| Safe area bottom padding | Content aşak kesilýär |
| Aktif ikon brand-500 | Hemme ikon bir reňk — aktif bilinmez |
| Tap area 100%/4 | Tap area diňe ikon ölçegi |