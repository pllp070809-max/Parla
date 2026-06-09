PARLA

Design System

Components — v0.1

MOLECULE 04 — LIST ITEM

Avatar + tekst + trailing action — sanaw elementi


01 / MANYSY

# List Item näme?

List Item — avatar/icon bilen tekst birleşen sanaw setiri. Salon sanawy, ussa sanawy, bron taryhy — hemmesi list item esasynda gurulýar.


┌─────────────────────────────────────────────┐

│ [48 avatar]  At Familiýa       [trailing]   │  56px height

│              Hyzmat · 4.8 ★               │

└─────────────────────────────────────────────┘


02 / 3 GÖRNÜŞ

# List Item variant-lary



03 / ANATOMY SPEC

# List Item spec



04 / TRAILING GÖRNÜŞLERI

# Trailing elementler


DÜZGÜN — Trailing tap area min 48×48. Şewron görünýän 24px, ýöne tap area 48px.

05 / DOĞRY · NÄDOĞRY

# Şahsy düzgünler



### Table 1

| GÖRNÜŞ | LEADING | TRAILING | ULANYŞ |
| --- | --- | --- | --- |
| Avatar | Avatar md (48px) | Icon ýa-da badge | Ussa, müşderi sanawy |
| Icon | Icon md (24px) | Icon ýa-da tekst | Settings, kategoriýa |
| Salon kart | Surat 64×64 | Rating + baha | Salon gözleg sanawy |

### Table 2

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Min height | 56px (size-control-xl) |
| Padding Y | space-3 (12px) |
| Padding X | space-4 (16px) — screen edge |
| Avatar-tekst gap | space-3 (12px) |
| Esasy tekst | headline 17 SemiBold |
| Kömekçi tekst | caption 13 text-secondary |
| Trailing | sag tarap, caption 13 ýa-da icon-md |
| Divider | aşakda, horizontal, border-default |
| Pressed state | bg neutral-100, instant |

### Table 3

| TRAILING | ULANYŞ | MYSAL |
| --- | --- | --- |
| Şewron → | Nawigasion — ýene bir sahypa | Salonuň detaly |
| Tekst + Şewron | Tekst maglumat + nawigasion | "150 TMT →" |
| Badge | Status görkeziji | "● TASSYKLANDY" |
| Toggle / Switch | Sazlama açyk/ýapyk | Settings sahypasy |
| Ýyldyz rating | Baha görkeziji | "4.8 ★" |
| Ýok | Diňe tekst — nawigasion ýok | Maglumat sanawy |

### Table 4

| DOĞRY | NÄDOĞRY |
| --- | --- |
| 56px min height (tap üçin) | 40px height — barmak basyp bilmez |
| Divider list içinde | Divider ýok — item garyşýar |
| Pressed-da bg neutral-100 | Pressed effekti ýok |
| Trailing tap area 48px | Trailing diňe 24px icon (az) |
| Kömekçi tekst caption 13 | Kömekçi tekst body 15 (uly) |