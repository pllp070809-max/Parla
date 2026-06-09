PARLA

Design System

Components — v0.1

ORGANISM 04 — EMPTY STATE

Mazmun ýokka görkezilýän ekran — salon tapylmady, bron ýok


01 / MANYSY

# Empty State näme üçin möhüm?

Ulanyjy gözleg netijesiz bolanda ýa-da sanawy boşlanda — Empty State görkezilýär. Erbet dizaýn edilse: ulanyjy "app döwük" diýip pikir edýär. Gowy dizaýn edilse: ulanyjy näme etmelidigini bilýär we galýar.


┌───────────────────────────────────────────┐

│                                            │

│           [Ikon / illustrasiýa]           │  ← 80×80, neutral-300

│                                            │

│         Başlyk (näme ýok)                 │  ← title 24

│    Düşündiriş (näme etmeli)               │  ← body 15 text-secondary

│                                            │

│          [Esasy hereket CTA]              │  ← Primary button (opsional)

│                                            │

└───────────────────────────────────────────┘


02 / 4 GÖRNÜŞ

# Empty State görnüşleri



03 / SPEC

# Empty State spec



04 / ÝAZGYLAR

# Başlyk we düşündiriş — nähili ýazylýar


DÜZGÜN — Empty State başlygy — "näme ýok" (noun). Düşündiriş — "näme etmeli" (gysga, action). CTA — "hereket" (işlik).

## DOĞRY / NÄDOĞRY



### Table 1

| GÖRNÜŞ | BAŞLYK | DÜŞÜNDIRIŞ | CTA |
| --- | --- | --- | --- |
| Gözleg netijesiz | "Salon tapylmady" | "Başga ady synanyşyň" | Ýok |
| Bron ýok | "Bronuňyz ýok" | "Salon taplyň we bron ediň" | Salon gözle |
| Halanýanlar ýok | "Halanýan ýok" | "♡ basyp salon saklanyňyz" | Salon gözle |
| Syn ýok | "Syn ýok" | "Ilkinji syn goşuň" | Syn ýaz |

### Table 2

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Ikon ölçeg | 80×80px (size-avatar-lg token) |
| Ikon reňk | neutral-300 — ýumşak, gözüň doldurmaýar |
| Ikon bg | neutral-100, radius-full |
| Başlyk font | title 24 Medium, text-primary |
| Düşündiriş font | body 15, text-secondary, max 2 setir |
| Ikon-başlyk gap | space-4 (16px) |
| Başlyk-düşündiriş gap | space-2 (8px) |
| Düşündiriş-CTA gap | space-6 (32px) |
| Hizalanma | Merkez (center-aligned) |
| Sahypada pozisiýa | Dik merkez ýa-da ýokary 1/3 |
| Horizontal padding | space-8 (64px) her tarap |

### Table 3

| NÄDOĞRY | DOĞRY | SEBÄBI |
| --- | --- | --- |
| "Netijer tapylmady" | "Salon tapylmady" | Anyk näme ýok — aýt |
| "Sanawy boş" | "Bronuňyz ýok" | Ulanyjy dilinde |
| "Bron etmek üçin gidiň we tapyň..." | "Salon taplyň we bron ediň" | Düşündiriş gysga |
| CTA her Empty State-de | CTA diňe hereket mümkin bolsa | Syn ýok → CTA zerur däl |

### Table 4

| DOĞRY | NÄDOĞRY |
| --- | --- |
| Ikon neutral-300 — ýumşak | Ikon brand reňk — artyk ünsi çekýär |
| Düşündiriş max 2 setir | 5+ setir düşündiriş |
| Merkez hizalanma | Çep hizalanma — birnäçe element ýaly görünýär |
| Dik merkez ýerleşme | Ekranyň aşagynda — gözüň görenok |
| CTA mümkin bolsa bar | Her empty state-de CTA (zerur däl bolanda) |