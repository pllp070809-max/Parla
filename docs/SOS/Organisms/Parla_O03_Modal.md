PARLA

Design System

Components — v0.1

ORGANISM 03 — MODAL

Merkez overlay — tassyklama, duýduryş, forma


01 / MANYSY

# Modal vs Bottom Sheet

Modal — ekranyň ortasynda çykýan panel. Bottom Sheet-den tapawudy: ortada, swipe ýok, has resmi, az ulanylmaly. Modal ulanyjy akymyny böldürýär — şonuň üçin diňe wajyp pursatlarda.


┌───────────────────────────────────────────┐  ← backdrop

│                                            │

│   ┌────────────────────────────────┐      │

│   │  [Ikon]                  [✕]  │      │  ← header

│   │  Başlyk                        │      │

│   ├────────────────────────────────┤      │

│   │  Content                       │      │  ← body

│   ├────────────────────────────────┤      │

│   │  [Ýatyr]     [Tassykla / OK]  │      │  ← footer

│   └────────────────────────────────┘      │

│                                            │

└───────────────────────────────────────────┘


02 / GÖRNÜŞLER

# 3 görnüş


DÜZGÜN — Bron tassyklamasy üçin aýratyn sahypa bar — Modal ÝOK. Modal diňe wagtal-wagtal çykýan wajyp habarlar üçin.

03 / SPEC

# Modal spec



04 / ANIMASIÝA

# Açylyş / ýapylyş


## DOĞRY / NÄDOĞRY



### Table 1

| GÖRNÜŞ | ULANYŞ | IKON |
| --- | --- | --- |
| Tassyklama | "Hasaby pozuň tassyklanyňyzmy?" | Soragyň nyşany |
| Duýduryş (Alert) | "Bron möhleti geçdi" | Duýduryş nyşany |
| Success | "Bron tassyklandy!" — alternatiw | Tassyk nyşany |

### Table 2

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Width | ekran width − 64px (32px her tarap) |
| Max width | 360px |
| Radius | radius-2xl (28px) — dört burç |
| Background | bg-card (neutral-0) |
| Shadow | shadow-lg |
| Backdrop | overlay-strong rgba(46,32,40,0.60) |
| Padding | space-5 (24px) |
| Header-body divider | border-strong |
| Body-footer divider | border-strong |
| Pozisiýa | Ekran ortasy (center-center) |

### Table 3

| ACTION | ANIMATION | DURATION | EASING |
| --- | --- | --- | --- |
| Açylyş | scale 0.95→1.0 + opacity 0→1 | 250ms | ease-out |
| Ýapylyş | scale 1.0→0.95 + opacity 1→0 | 150ms | ease-in |
| Backdrop | opacity 0→0.60 | 250ms | ease-out |

### Table 4

| DOĞRY | NÄDOĞRY |
| --- | --- |
| Diňe wajyp pursatlarda | Her tassyklama modal bilen |
| Footer-da max 2 düwme | 3+ düwme — ulanyjy ikirjiňleýär |
| Backdrop tap ýapýar (tassyk däl) | Backdrop tap işlemeýär |
| Başlyk gysga (3-5 söz) | Uzyn başlyk — modal uly bolýar |
| ✕ düwme header-da | ✕ ýok — diňe düwme bilen ýapylýar |