PARLA

Design System

Components — v0.1

TEMPLATE 02 — SALON DETAIL

Salon maglumat sahypasy — hyzmatlar, ussalar, syn


01 / DOLY WIREFRAME

# Scroll edilýän sahypa gurluşy


┌─ HERO SURAT (edge-to-edge 240px) ──────────┐

│  [← yza]              [♡]  [⬆ paýlaş]     │  ← transparent

├─────────────────────────────────────────────┤

│  Salon ady                        [★ 4.8]  │

│  Kategoriýa · Şäher               [127 syn]│

├─────────────────────────────────────────────┤

│  📍 Köçe ady, 12    ⏰ 09:00 — 19:00       │

├─ STICKY TAB BAR ────────────────────────────┤

│  [Hyzmatlar★]  [Ussalar]  [Suratlar] [Syn] │

├─ TAB CONTENT ───────────────────────────────┤

│                                             │

│  ── Saç düzümi ──  (kategoriýa başlyk)     │

│  [Service Card]                             │

│  [Service Card]                             │

│  ── Kirpik ──                               │

│  [Service Card]                             │

│                                             │

├─ STICKY BOTTOM ─────────────────────────────┤

│  [150 TMT · 45 min]    [BRON ET Dark CTA]  │  ← 80px + safe

└─────────────────────────────────────────────┘


02 / HYZMATLAR TAB

# Hyzmatlar kategorýa bilen

Hyzmatlar kategoriýa başlyklary bilen bölünýär. Kategoriýa başlygy — sticky (scroll edilende ýokaryn galýar).



03 / USSALAR TAB

# Ussa carousel

Master Card carousel (Molecule 05). Horizontal scroll. Ussa saýlananda bron forma geçilýär.


- Master Card carousel — horizontal scroll, 140px width
- "Islendik ussa" opsiony hemişe iň başda
- Boşluk ýok ussalar greyed, tap ÝOK
- Ussa tap edilende detail bottom sheet açylýar

04 / STICKY BOTTOM CTA

# Bron et düwmesi


DÜZGÜN — Sticky CTA — top-shadow, safe area bottom. Hyzmat saýlanmazdan öň disabled ýa-da pes visible.



### Table 1

| ELEMENT | SPEC |
| --- | --- |
| Kategoriýa başlyk | headline 17 SemiBold, bg-scaffold (sticky) |
| Service Card | Molecule 02 — doly spec |
| Kart arasy gap | space-3 (12px) |
| Kategoriýa arasy | space-6 (32px) |
| Saýlanma behaviour | Multi-select — birnäçe hyzmat saýlanyp bilner |
| Saýlananda sticky CTA | Jemi baha we wagt täzelýär |

### Table 2

| ÝAGDAÝ | GÖRÜNÜŞ |
| --- | --- |
| Hyzmat saýlanmadyk | "Bron et" Dark CTA — disabled (ýa-da gizlin) |
| Hyzmat saýlanan | "150 TMT · 45 min" + "Bron et" Dark CTA — aktif |
| Köp hyzmat saýlanan | "370 TMT · 1s 15min" + "Bron et" — jemi |