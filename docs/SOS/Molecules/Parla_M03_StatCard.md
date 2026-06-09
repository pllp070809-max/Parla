PARLA

Design System

Components — v0.1

MOLECULE 03 — STAT CARD

KPI we analitika karty — salon we ussa görkezijileri


01 / MANYSY

# Stat Card näme?

Stat Card — bir KPI görkeziji. Salon eýesiniň dashboard-ynda we ussa profilinde: şu aý umumy bron, girdejisi, reýtingi ýaly möhüm sanlar bu kart bilen görkezilýär.


┌──────────────────────────────────┐

│ ŞUAÝ BRON                        │ ← eyebrow (micro 11 CAPS)

│                                  │

│ 47                               │ ← display san (Fraunces 40)

│                                  │

│ ↑ 12% geçen aý bilen             │ ← trend (caption 13)

└──────────────────────────────────┘


02 / ANATOMY

# 3 esasy bölüm



03 / TREND GÖRNÜŞLERI

# Trend — ↑ ↓ →


DÜZGÜN — Trend diňe kontekstde ↑ ↓ görnüşi berýär. Gymmatlyk ↑ hemişe "gowy" däl — mysal: Churn rate ↑ = erbet. Goşmaça düşündiriş gerek.

04 / KART SPEC

# Stat Card spec



## Parla-da Stat Card mysallary



### Table 1

| BÖLÜM | FONT | REŇK |
| --- | --- | --- |
| Eyebrow (kategoriýa) | micro 11 SemiBold CAPS +8% LS | text-tertiary |
| San (esasy gymmatlyk) | Fraunces 40px (display token) | text-primary |
| Trend / Bellik | caption 13 | ↑ success-main / ↓ error-main |

### Table 2

| TREND | REŇK | MYSAL |
| --- | --- | --- |
| Ösüş ↑ | success-main (#4A9447) | "↑ 12% geçen aý bilen" |
| Pese düşüş ↓ | error-main (#C93B52) | "↓ 3% geçen aý bilen" |
| Üýtgemedi → | text-tertiary | "→ Geçen aý ýaly" |

### Table 3

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Background | neutral-0 (ak) |
| Border | 1px border-default, radius-lg (16) |
| Padding | space-5 (24px) hemme tarap |
| Shadow | shadow-none |
| Min height | 120px |
| Eyebrow-san gap | space-2 (8px) |
| San-trend gap | space-1 (4px) |
| Grid ulanyşy | 2 sütün (2-3 kart), gap space-3 (12px) |

### Table 4

| EYEBROW | SAN | TREND |
| --- | --- | --- |
| ŞUAÝ BRON | 47 | ↑ 12% geçen aý |
| REÝTING | 4.8 ★ | 127 syn esasynda |
| ŞUAÝ GIRDEJI | 4,200 T | ↑ 8% geçen aý |
| BOŞLUKLAR | 12 | Şu hepde galan |