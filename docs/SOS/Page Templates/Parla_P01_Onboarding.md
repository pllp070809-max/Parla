PARLA

Design System

Components — v0.1

PAGE 01 — ONBOARDING

3 ekranly giriş prosesi — Parla-nyň ilkinji täsiri


01 / FILOSOFIÝA

# Onboarding düzgünleri

Onboarding — ulanyjynyň Parla bilen ilkinji duşuşygy. Erbet onboarding — ulanyjy çykýar. Gowy onboarding — gyzyklandyrýar we sakladýar.


- Max 3 ekran — artyk bolsa ulanyjy çykýar
- Her ekran — 1 esasy pikir
- "Skip" düwmesi hemişe görünýär — ulanyjy zorlamaly däl
- Soňky ekran — açyk CTA (Başla / Hasaba al)
- Illustrasion ýa-da animasiýa — tekst däl esasy
DÜZGÜN — Onboarding ulanyjyny öwretmeýär — gyzyklandyrýar. Funksiýa öwrenmek ilkinji ulanyşda bolýar.


02 / 3 EKRAN MAZMUNY

# Onboarding ekranlar



03 / EKRAN SPEC

# Her ekran layout


┌─ STATUS BAR ────────────────────────────────┐

│                              [Skip →]       │  ← ghost button

│                                             │

│                                             │

│          [Illustrasion / Animasiýa]         │  ← 60% ekran

│                                             │

│                                             │

│          Başlyk                             │  ← title 24

│          Düşündiriş tekst                   │  ← body 15

│                                             │

│          ● ○ ○   (sahypa nokady)            │  ← indicator

│                                             │

│          [Dowam →   Primary]                │  ← button

│          *** 3-nji ekranda: "Başla"         │

└─────────────────────────────────────────────┘



04 / DOĞRY · NÄDOĞRY

# Onboarding düzgünler



### Table 1

| EKRAN | BAŞLYK | DÜŞÜNDIRIŞ | ILLUS. |
| --- | --- | --- | --- |
| 1 | "Öz salonuňy tap" | Müňlerçe salon barmagyňyň ujunda | Salon görnüşi |
| 2 | "Ussaňy saýla" | Öz söýgüli ussaň bilen her gezek | Ussa karty |
| 3 | "5 sekundda bron et" | Salony tap, wagty saýla, tassykla | Bron aksiýa |

### Table 2

| ELEMENT | SPEC |
| --- | --- |
| Illustrasion ýeri | Ýokary 60% — edge-to-edge ýa-da 80% width |
| Ekran bg | bg-scaffold (neutral-50) ýa-da brand-50 |
| Başlyk font | Fraunces 32px (display token) — premium duýgy |
| Düşündiriş font | body 15 text-secondary, max 2 setir |
| Sahypa nokady | 6×6px radius-full, aktif brand-500, inaktif neutral-300 |
| Skip düwmesi | Ghost, sag ýokary, diňe 1-2 ekranda |
| Swipe gesture | Çepden saga swipe — ekran geçiş |
| Transition | Horizontal slide, 400ms ease-in-out |

### Table 3

| DOĞRY | NÄDOĞRY |
| --- | --- |
| "Skip" hemişe görünýär | "Skip" gizlin — ulanyjy zorlanýar |
| Max 3 ekran | 5-7 ekran — çykýarlar |
| Her ekran 1 pikir | Bir ekranda 4+ aýratynlyk |
| Başlyk Fraunces (duýgy) | Ähli tekst Plus Jakarta (adaty) |
| Illustrasion esasy | Köp tekst, az görsel |