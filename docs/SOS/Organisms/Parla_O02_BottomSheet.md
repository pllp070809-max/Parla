PARLA

Design System

Components — v0.1

ORGANISM 02 — BOTTOM SHEET

Aşakdan çykýan panel — bron tassyklama, filter, action menu


01 / MANYSY

# Bottom Sheet näme?

Bottom Sheet — ekranyň aşagyndan çykýan panel. Modal-dan tapawudy: aşakdan gelýär, swipe bilen ýapylýar, backdrop has açyk. Parla-da iň köp ulanylýan organism.


┌───────────────────────────────────────────┐  ← backdrop overlay

│                  (tap-da ýapylýar)        │

├───────────────────────────────────────────┤

│            ▬▬▬                            │  ← drag handle

│                                            │

│  [Başlyk]                    [✕ Ýap]      │  ← header (opsional)

├───────────────────────────────────────────┤

│                                            │

│   Content                                  │  ← body (scroll bolup biler)

│                                            │

├───────────────────────────────────────────┤

│  [Secondary button]   [Primary button]    │  ← footer (opsional)

└───────────────────────────────────────────┘


02 / GÖRNÜŞLER

# 4 görnüş



03 / SPEC

# Bottom Sheet spec



04 / ANIMASIÝA

# Açylyş / ýapylyş


DÜZGÜN — Swipe-down 30% geçse — snap close. 30%-den az bolsa — snap open (yza gaýdýar).

05 / PARLA MYSALLARY

# Parla-da Bottom Sheet


## DOĞRY / NÄDOĞRY



### Table 1

| GÖRNÜŞ | ULANYŞ | HEIGHT |
| --- | --- | --- |
| Action menu | Saýlaw opsiýalary (Paýlaş, Redaktirle, Poz) | Auto (content) |
| Forma | Gysga forma girişi (filter, bellik) | 50% ekran |
| Tassyklama | Bron tassyklamasy, poz tassyklamasy | Auto (content) |
| Doly ekran | Kamera, galerеýa, giňişleýin mazmuny | 90% ekran |

### Table 2

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Radius | radius-2xl (28px) diňe ýokary iki burç |
| Background | bg-card (neutral-0) |
| Shadow | shadow-xl top-shadow |
| Backdrop | overlay-strong rgba(46,32,40,0.60) |
| Drag handle | 40×4px, radius-full, neutral-300 |
| Handle margin | 12px aşak (space-3) |
| Content padding | space-5 (24px) X, space-4 (16px) Y |
| Footer padding | space-4 (16px) + safe area bottom |
| Min height | 200px |
| Max height | 90% ekran beýikligi |

### Table 3

| ACTION | ANIMATION | DURATION | EASING |
| --- | --- | --- | --- |
| Açylyş | translateY 100% → 0 | 250ms | ease-out |
| Ýapylyş | translateY 0 → 100% | 150ms | ease-in |
| Backdrop açyl. | opacity 0 → 0.60 | 250ms | ease-out |
| Swipe-down | Follow finger → snap close | 150ms | ease-in |

### Table 4

| ÝAGDAÝ | GÖRNÜŞ | FOOTER |
| --- | --- | --- |
| Salon üçin action menu | Action menu | Ýok |
| Bron tassyklamasy | Tassyklama | "Tassykla" Dark CTA |
| Filter (kategoriýa, mesafe) | Forma | "Ulat" Primary |
| Wagt saýlama slot-lary | 50% ekran | "Saýla" Dark CTA |
| Bron ýatyrma | Tassyklama | "Ýatyr" Destructive |

### Table 5

| DOĞRY | NÄDOĞRY |
| --- | --- |
| Drag handle hemişe görünýär | Drag handle ýok — swipe bilmeýär |
| Backdrop tap ýapýar | Backdrop tap çalışmaýar |
| Safe area bottom footer-da | Footer ekran aşagy kesilýär |
| Swipe 30%+ → ýapylýar | Diňe düwme bilen ýapylýar |
| Max height 90% ekran | 100% — onda full page açmaly |