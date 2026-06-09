PARLA

Design System

Components — v0.1

ORGANISM 01 — SALON DETAIL HEADER

Hero surat + salon maglumaty + action düwmeler


01 / GURLUŞ

# 4 gatlakly header


┌───────────────────────────────────────────┐

│  [← yza]              [♡ halamak] [⬆ paý]│  ← transparent bar (üst-üste)

│                                            │

│         HERO SURAT  (240px, edge-to-edge)  │

│                                            │

├───────────────────────────────────────────┤

│ Salon ady                   [★ 4.8]        │  ← title block

│ Hyzmat görnüşi · Şäher      [127 syn]      │

├───────────────────────────────────────────┤

│ [📍 Adres]       [⏰ Iş wagty: 09:00-19:00]│  ← info row

├───────────────────────────────────────────┤

│  [Hyzmatlar]  [Ussalar]  [Suratlar]  [Syn]│  ← tab bar

└───────────────────────────────────────────┘


02 / GATLAK 1 — HERO SURAT

# Edge-to-edge hero


DÜZGÜN — Hero surat gradient overlay bolmasa, üstündäki ak ← yza düwmesi görünmez. Gradient hökman.

03 / GATLAK 1 — TRANSPARENT NAV

# Üstündäki transparent düwmeler

Hero surat üstünde ← yza, ♡ halamak, ⬆ paýlaşmak düwmeleri. Surat bilen garyşmaýar ýaly:


DÜZGÜN — iOS safe area-ny hasapla (Dynamic Island, kertik). status-bar height = MediaQuery.padding.top.

04 / GATLAK 2 — TITLE BLOCK

# Salon ady we maglumat



05 / GATLAK 3 — INFO ROW

# Adres we iş wagty


│ 📍 Köçe ady, 12, Aşgabat   ⏰ 09:00 — 19:00 │


DÜZGÜN — Adres tap edilende Maps açylmaly (deep link). Öz içinde harita görkezme — V2.0 üçin.

06 / GATLAK 4 — TAB BAR

# Salon içi nawigasion tablar



- Aktif tab — brand-500 tekst + aşaky çyzyk (indicator)
- Inaktif tab — text-tertiary
- Tab switch animation — content fade + slide, 250ms (Motion bölümi)
- Tab bar sticky — scroll edilende öýkünde galýar
DÜZGÜN — Aktif tab indicator — border-bottom 2px brand-500, padding-bottom 12px. Tab content kesilmeýär.



### Table 1

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Height | 240px (ýokary) → 200px (aşak scrollda) |
| Width | 100% edge-to-edge, radius-none |
| Object-fit | cover |
| Gradient overlay | aşaky 40% — transparent → rgba(0,0,0,0.3) |
| Parallax | Scroll aşak basylanda surat biraz haýal hereket edýär |

### Table 2

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Background | rgba(255,255,255,0.85) + blur (glassmorphism) |
| Ölçeg | 40×40px, radius-full |
| Icon reňk | text-primary (neutral-700) |
| Pozisiýa | Safe area top + 16px, screen edge 16px |
| Halamak (aktif) | Icon brand-500, bg brand-50 |

### Table 3

| ELEMENT | FONT | BELLIK |
| --- | --- | --- |
| Salon ady | title 24 Medium | 1-2 setir, gysga bolmaly |
| Kategoriýa · Şäher | body 15 text-secondary | "Gözellik salony · Aşgabat" |
| Ýyldyz rating | headline 17 + star-main | "★ 4.8" |
| Syn sany | caption 13 text-secondary | "(127 syn)" |

### Table 4

| ELEMENT | FONT | TAP ACTION |
| --- | --- | --- |
| 📍 Adres | caption 13 text-secondary | Karta açylýar |
| ⏰ Iş wagty | caption 13 text-secondary | Doly iş wagty sheet açylýar |

### Table 5

| TAB | MAZMUN | DEFAULT? |
| --- | --- | --- |
| Hyzmatlar | Service Card sanawy (Molecule 02) | HWA — ilki açylýar |
| Ussalar | Master Card carousel (Molecule 05) | Ýok |
| Suratlar | Foto galereýa grid | Ýok |
| Synlar | Ulanyjy teswirler + reýting | Ýok |