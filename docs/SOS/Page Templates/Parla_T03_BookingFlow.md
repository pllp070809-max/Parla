PARLA

Design System

Components — v0.1

TEMPLATE 03 — BOOKING FLOW

3 ädimli bron prosesi — ussa, wagt, tassyklama


01 / FLOW DÜŞÜNDIRIŞI

# 3 ädim — linear prosess

Booking Flow — Parla-nyň esasy prosesi. Ulanyjy salondan "Bron et" basgandan başlaýar. 3 ädim: ussa+hyzmat → wagt → tassyklama.


Salon Detail →  STEP 1  →  STEP 2  →  STEP 3  →  Tassyklama sahypa

Ussa/Hyz   Wagt saý   Detal/töl



02 / STEP PROGRESS BAR

# Ädim görkezijisi


┌─────────────────────────────────────────────┐

│  [←]  ●━━━━━━●━━━━━━○         ✕           │

│        1      2      3                      │  ← progress

└─────────────────────────────────────────────┘



03 / STEP 1 — USSA & HYZMAT

# Ädim 1 layout


┌─ PROGRESS BAR ──────────────────────────────┐

│  1 ●━━○━━○     Ussa we hyzmaty saýla       │

├─────────────────────────────────────────────┤

│  Ussa saýla                                 │  ← h2 başlyk

│  ← [Master Card] [Master Card] [+] →       │  ← carousel

├─ DIVIDER ──────────────────────────────────┤

│  Saýlanan hyzmatlar                         │  ← h2 başlyk

│  [Service Card saýlanan — brand border]     │

│  [Service Card saýlanan]                    │

├─ STICKY BOTTOM ─────────────────────────────┤

│  150 TMT · 45 min    [Dowam  →  Primary]   │

└─────────────────────────────────────────────┘


DÜZGÜN — Ussa saýlamak hökman däl — "Islendik ussa" default. Hyzmat saýlamak HÖKMAN (CTA disabled bolmaz üçin).

04 / STEP 2 — WAGT SAÝLA

# Ädim 2 layout


┌─ PROGRESS BAR ──────────────────────────────┐

│  ✓●━━2●━━○     Wagty saýla                 │

├─────────────────────────────────────────────┤

│  Sene saýla                                 │

│  ← [Dü] [Si] [Çr] [Pe] [An] [Şe] [Ýe] →  │  ← mini calendar

│         [16] [17] [18*] [19] [20]           │  ← günler scroll

├─────────────────────────────────────────────┤

│  Boş slotlar (18 Iýun)                      │

│  [09:00] [09:30] [10:00]                    │  ← Suggestion Chips

│  [10:30] [11:00] [14:00]                    │

│  [14:30] [15:00] [15:30]                    │

├─ STICKY BOTTOM ─────────────────────────────┤

│  18 Iýun · 14:00 · 45 min  [Dowam Primary] │

└─────────────────────────────────────────────┘



05 / STEP 3 — TASSYKLAMA

# Ädim 3 layout


┌─ PROGRESS BAR ──────────────────────────────┐

│  ✓●━━✓●━━3●    Brony tassykla             │

├─ BRON JIKME-JİK ────────────────────────────┤

│  Salon ady  [48 avatar]  Salon salony        │

│  Ussa:      [32 avatar]  Aman Gurbanow       │

│  Hyzmat:    Saç düzümi (45 min)              │

│  Wagt:      18 Iýun 2026, 14:00             │

│  Baha:      150 TMT                          │

├─ TÖLEG USULY ───────────────────────────────┤

│  ◉ Nagt (ýerde töläris)                     │

│  ○ Online kart                               │

├─ BELLIK ────────────────────────────────────┤

│  [Goşmaça bellik textarea]                   │

├─ STICKY BOTTOM ─────────────────────────────┤

│  Jemi: 150 TMT    [TÖLEGI TASSYKLA Dark CTA]│

└─────────────────────────────────────────────┘


DÜZGÜN — "TÖLEGI TASSYKLA" Dark CTA — iň güýçli düwme, iň möhüm action. Tap edilende loading spinner, soň Tassyklama sahypasy.



### Table 1

| ÄDIM | AT | MAZMUNY | CTA |
| --- | --- | --- | --- |
| 1 | Ussa & Hyzmat | Master Cards + saýlanan hyzmatlar tassyklama | Dowam → |
| 2 | Wagt saýla | Sene saýlaýjy + boş slot Chips | Dowam → |
| 3 | Tassykla | Doly jikme-jik + töleg usuly | Tölä Dark CTA |

### Table 2

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Tamamlanan ädim | ● brand-500 doly, birleşdiriji çyzyk brand-500 |
| Häzirki ädim | ● brand-500 bilen halka, içi ak |
| Galan ädim | ○ neutral-300 |
| Çyzyk height | 2px |
| Nokta ölçeg | 12×12px, radius-full |
| ← yza düwme | Öňki ädime, aýry ädim däl |
| ✕ ýap | Tassyklama modalynyň soňunda ýapylýar |

### Table 3

| ELEMENT | SPEC |
| --- | --- |
| Sene saýlaýjy | Horizontal scroll, gün kartlar, boş günler greyed |
| Saýlanan gün | brand-500 bg, ak tekst, radius-full |
| Slot chip | Suggestion Chip (Atom 03), 3-4 sütün grid |
| Boş slot däl | Greyed, tap ÝOK |
| Saýlanan slot | brand-50 bg + brand-500 border (Filter Chip selected) |