PARLA

Design System

Components — v0.1

MOLECULE 02 — SERVICE CARD

Salon hyzmat karty — surat, at, baha, wagt


01 / MANYSY

# Service Card näme?

Service Card — salonuň bir hyzmatyny görkezýän kart. Ulanyjy şuny saýlap bron edýär. Parla-nyň esasy konwersion elementi — gowy dizaýn edilse, bron artýar.


┌──────────────────────────────────────┐

│ [Hyzmat suratjygy / icon]  40×40     │

│                                      │

│ Hyzmatyň ady              headline   │

│ Beýan (opsional)          caption    │

│                                      │

│ 45 min              [150 TMT]        │

│ ← wagt             baha →            │

└──────────────────────────────────────┘


02 / ANATOMY

# 4 esasy bölüm



03 / KART SPEC

# Service Card spec



04 / SAÝLANAN STATE

# Service Card saýlananda

Ulanyjy hyzmaty saýlanda kart state üýtgeýär:


DÜZGÜN — Saýlanan service card — border + bg üýtgeýär (badge/chip principy bilen meňzeş). Diňe bg ÝOK.

05 / DOĞRY · NÄDOĞRY

# Şahsy düzgünler



### Table 1

| BÖLÜM | TOKEN | ULANYŞ |
| --- | --- | --- |
| Hyzmat suratjygy | size-icon-lg (32) ýa-da surat 48×48 | Hyzmat görnüşi anyk bildirýär |
| Hyzmatyň ady | headline 17 SemiBold | Gysga, anyk: "Saç düzümi" |
| Beýan (opsional) | caption 13 text-secondary | Goşmaça maglumat |
| Wagt | body 15 text-secondary | "45 min" |
| Baha | headline 17 SemiBold text-primary | "150 TMT" — anyk görünmeli |

### Table 2

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Background | neutral-0 (ak) |
| Border | 1px border-default, radius-lg (16) |
| Padding | space-4 (16px) hemme tarap |
| Shadow | shadow-none (default) → shadow-sm (hover) |
| Pressed state | scale 0.97, bg neutral-50 |
| Icon-at gap | space-3 (12px) |
| At-baha gap | auto (flex spacer) |
| Wagt-baha arasynda | flex row, justify space-between |

### Table 3

| ATRIBUT | DEFAULT | SELECTED |
| --- | --- | --- |
| Border | border-default 1px | brand-500 1.5px |
| Background | neutral-0 | brand-50 |
| Checkmark | ýok | brand-500, sag ýokary |
| Animation | — | scale 0.97 → 1.0, 150ms |

### Table 4

| DOĞRY | NÄDOĞRY |
| --- | --- |
| Hyzmat ady gysga (2-3 söz) | Uzyn düşündiriş at (7+ söz) |
| Baha anyk görünýär (uly) | Baha kiçi ýa gizlin |
| Saýlananda border+bg üýtgeýär | Diňe bg üýtgeýär |
| Hover shadow-sm | Hemişe shadow (artyk) |
| Wagt we baha aşakda, bir setirde | Wagt we baha dürli ýerlerde |