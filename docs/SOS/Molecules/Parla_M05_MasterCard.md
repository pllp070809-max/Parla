PARLA

Design System

Components — v0.1

MOLECULE 05 — MASTER CARD

Ussa mini-profil karty — salon içindäki ussa saýlamak üçin


01 / MANYSY

# Master Card näme?

Master Card — salon detail sahypasynda ussa saýlamak üçin mini-kart. Ulanyjy haýsy ussada bron etjegini şu kartdan saýlaýar. Parla-nyň wajyp konwersion elementi.


┌──────────────────────────────┐

│         [80 avatar]           │

│         Aman G.              │ ← at (title 24 ýok, headline 17)

│         4.8 ★  · 127 syn     │ ← caption 13

│         Saç düzümi           │ ← caption 13 text-secondary

│    [BOŞLUK BAR / ÝOK badge]  │

└──────────────────────────────┘


02 / ANATOMY

# 5 bölüm — dik tertipde



03 / KART SPEC

# Master Card spec



04 / SAÝLANAN STATE

# Ussa saýlananda


DÜZGÜN — Saýlanan ussanyň avatary töwereginde brand-500 halka görünýär — premium detal we anyk görünüş.

05 / BOŞLUK BADGE

# "Boşluk bar / ýok" badge


DÜZGÜN — "BOŞLUK ÝOK" ussanyň karty greyed (opacity 0.5) we tap edilmeýär. Ýöne görünýär — ulanyjy başgasyny saýlaýar.

06 / CAROUSEL PATTERN

# Master Card nähili yerleşýär

Master Card-lar horizontal scroll carousel-da görkezilýär. Salon detail sahypasynda.


Ekran:

← [Ussa 1] [Ussa 2] [Ussa 3] [+] →   (horizontal scroll)

gap: space-3 (12px)

padding-X: space-4 (16px)


- Her kart 140px fixed width
- Horizontal scroll — edge-to-edge (padding-X bilen)
- Gap: space-3 (12px) kart arasynda
- Max görkezilen: 4-5 (galany scroll bilen görünýär)
- Saýlanmadyk ussalar opacity 1.0; Boşluk ýok 0.5
DÜZGÜN — Carousel-yň başlangyç paddingini screen edge margin bilen deňleşdir (space-4 = 16px).

07 / DOĞRY · NÄDOĞRY

# Şahsy düzgünler


🎉 MOLECULES — 100%

# Ähli molecule-lar tamamlandy!

Foundation + Atoms + Molecules — Parla Design System-iň gurluş gatlaklary doly.


## Tamamlanan molecule-lar

- ✓ Molecule 01 — Form Field (label, validation, forma tertip)
- ✓ Molecule 02 — Service Card (saýlanan state, baha)
- ✓ Molecule 03 — Stat Card (Fraunces san, trend ↑↓)
- ✓ Molecule 04 — List Item (avatar, trailing, divider)
- ✓ Molecule 05 — Master Card (carousel, halka, boşluk badge)

## Indiki tapgyr — Organisms

Atomlar + Molecule-lary birleşdirip Organisms gurýarys.

- Organism 01 — Salon Detail Header
- Organism 02 — Bottom Sheet
- Organism 03 — Modal
- Organism 04 — Empty State
- Organism 05 — Navigation Bar

— Organisms başlaýarys —


### Table 1

| BÖLÜM | FONT / ÖLÇEG | BELLIK |
| --- | --- | --- |
| Avatar | size-avatar-lg (80px) | Merkez hizalanma |
| At (gysga) | headline 17 SemiBold | Aman G. (familiýa ilki harp) |
| Rating + syn sany | caption 13 text-secondary | "4.8 ★ · 127 syn" |
| Hünär | caption 13 text-secondary | "Saç düzümi, Kirpik" |
| Boşluk badge | Status badge (Atom 03) | success/error reňk |

### Table 2

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Width | Scroll carousel — 140px (fixed) |
| Background | neutral-0 |
| Border | 1px border-default, radius-xl (20) |
| Padding | space-4 (16px) |
| Hizalanma | Merkez (center-aligned) |
| Avatar-at gap | space-2 (8px) |
| At-rating gap | space-1 (4px) |
| Rating-hünär gap | space-1 (4px) |
| Hünär-badge gap | space-2 (8px) |
| Shadow | shadow-none → shadow-sm (hover) |

### Table 3

| ATRIBUT | DEFAULT | SELECTED |
| --- | --- | --- |
| Border | border-default 1px | brand-500 2px |
| Background | neutral-0 | brand-50 |
| Checkmark | ýok | brand-500, sag ýokary 16px |
| Avatar border | ýok | brand-500 2px halka |

### Table 4

| BADGE | REŇK | MANYSY |
| --- | --- | --- |
| ● BOŞLUK BAR | success-soft + success-strong | Bron etmäge açyk |
| ● BOŞLUK ÝOK | error-soft + error-strong | Şu gün ýapyk (greyed kart) |
| ● DYNÇ GÜNI | neutral-100 + text-tertiary | Şu gün dynç alyş |

### Table 5

| DOĞRY | NÄDOĞRY |
| --- | --- |
| Saýlanan — avatar halka + border | Diňe background üýtgeýär |
| "BOŞLUK ÝOK" greyed — tap ýok | "BOŞLUK ÝOK" aýrylýar |
| At gysga (At F. görnüşde) | Doly at-familiýa (uzyn, kart gysýar) |
| Merkez hizalanma | Çep hizalanma (list item bilen bulaşyk) |
| radius-xl (20) — salon karty | radius-lg (16) — service card bilen meňzeş |