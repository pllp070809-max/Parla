PARLA

Design System

Components — v0.1

TEMPLATE 01 — HOME SCREEN

Baş sahypa layout — mahabat, kategorýa, salonlar


01 / EKRAN GURLUŞY

# Doly wireframe


┌─ STATUS BAR ────────────────────────────────┐

├─ APP BAR ───────────────────────────────────┤

│  Salam, Aman 👋        [🔔 3]  [👤]        │  ← 56px

├─────────────────────────────────────────────┤

│  [🔍  Salon gözle...                    ]  │  ← Search 48px

├─ BÖLÜM 1 ───────────────────────────────────┤

│  Size Maslahat ▸                            │  ← section başlyk

│  ← [Salon kart] [Salon kart] [+] →         │  ← H. scroll

├─ BÖLÜM 2 ───────────────────────────────────┤

│  Kategorýalar                               │

│  [Saç] [Kirpik] [Maniküür] [Spa] [Gözelik] │  ← chips

├─ BÖLÜM 3 ───────────────────────────────────┤

│  Ýakyndaky Salonlar ▸                       │

│  [List Item]                                │

│  [List Item]                                │

│  [List Item]                                │

├─ NAV BAR ───────────────────────────────────┤

│  [🏠]    [🔍]    [📅]    [👤]             │  ← 56px + safe

└─────────────────────────────────────────────┘


02 / APP BAR

# App bar spec



03 / SEARCH BAR

# Gözleg setirleri

Search bar — Full variant (Atom 02). Tap edilende Search Overlay sahypasyna geçiş (push nawigasiýa).


DÜZGÜN — Home screen-daky search bar tap edilende keyboard açylmaýar — Search sahypasyna geçilýär. Keyboard şol sahypada açylýar.

04 / BÖLÜM TERTIPLEME

# Section spacing we hierarhiýa



05 / MASLAHAT BERIŞ SALONLAR

# Horizontal scroll karty

Home screen-iň iň görnükli bölümi — personalaşdyrylan maslahatlar.


06 / KATEGORİÝALAR

# Hyzmat kategoriýa chip-leri

Filter chip-ler (Atom 03). Saýlanylanda şol kategoriýa salonlary görnýär.


- Chip sanawy: Hemmesi · Saç · Kirpik · Maniküür · Pedikür · Spa · Gözelik · Solarium
- "Hemmesi" chip hemişe ilki, default saýlanan
- Horizontal scroll, left-aligned, space-4 (16px) padding-X
- Saýlanan chip → filter list täzelýär (API call)


### Table 1

| ELEMENT | SPEC | BELLIK |
| --- | --- | --- |
| Salamlaşma | title 24 Regular | "Salam, Aman 👋" |
| Ulanyjy ady | title 24 SemiBold | API-den atly |
| Notification icon | icon-md 24 + count badge | Tap → notif. sanawy |
| Avatar | size-avatar-sm 32 | Tap → profil sahypa |
| Bar height | 56px + safe area top | iOS kertik bilen |
| Background | bg-scaffold (neutral-50) | Scroll edilende blur |

### Table 2

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Height | 48px (size-control-lg) |
| Radius | radius-lg (16) |
| Background | neutral-100 (surface) |
| Leading icon | 🔍 icon-md 24, neutral-400 |
| Placeholder | "Salon, hyzmat ýa-da ussa gözle..." |
| Margin | space-4 (16px) horizontal |
| Tap behaviour | Derhal search overlay açýar (fokus ÝERINE sahypa) |

### Table 3

| ELEMENT | SPACING | TOKEN |
| --- | --- | --- |
| App bar → Search | 12px | space-3 |
| Search → Bölüm 1 | 32px | space-6 |
| Bölüm başlyk → content | 12px | space-3 |
| Bölüm arasynda (major) | 48px | space-7 |
| List item arasynda | Divider (1px) | border-default |

### Table 4

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Kart görnüşi | Uly kart: surat 160×200 + maglumat |
| Kart width | 240px (fixed) |
| Radius | radius-xl (20) |
| Scroll padding | space-4 (16px) başy we soňy |
| Kart arasy gap | space-3 (12px) |
| Max görkezilen | 3-5 (scroll bilen galan) |