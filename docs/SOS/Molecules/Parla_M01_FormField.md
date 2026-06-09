PARLA

Design System

Components — v0.1

MOLECULE 01 — FORM FIELD

Label + Input + Help + Error — doly forma elementi


01 / MANYSY

# Form Field näme?

Form Field = Label + Input + Help tekst + Error tekst. Bular hemişe bilelikde — aýratyn ulanylmaýar. Atom 02 (Input) bir element, Form Field bolsa doly forma elementi.


┌─ Form Field ─────────────────────────────────┐

│  [Label tekst]          ← caption 13, text-secondary  │

│  ┌─────────────────────────────────┐         │

│  │  Placeholder...                 │ ← Input  │

│  └─────────────────────────────────┘         │

│  [Help ýa-da Error tekst]  ← caption 13       │

└───────────────────────────────────────────────┘


02 / LABEL DÜZGÜNLERI

# Label — hemişe anyk



DÜZGÜN — Label hiç haçan placeholder bilen çalşyrylmaýar. Placeholder kömekçi, label hökmany.

03 / VALIDATION MESAJLARY

# Error we Help — nähili ýazylýar

Error mesaj — ulanyjynyň pikir edişini görkezýär. "Ýalňyş" diýme — näme etmelidigini aýt.


DÜZGÜN — Error mesaj — anyk, konstruktiw, 1 setir. "Ýalňyş" ýaly umumy söz — ÝOK.

04 / FORMA TERTIPLEME

# Köp fieldli forma


## Ýekebir sütün (mobile default)

E-poçta        ← field

Parol          ← field

Telefon        ← field

[Hasaba al]    ← primary button


## Iki sütün (giňişleýin forma)

[At]           [Familiýa]

[E-poçta]      [Telefon]

[Şäher]        [Poçta kody]


Mobile-da hemişe ýekebir sütün. Iki sütün diňe tablet/desktop üçin.

DÜZGÜN — Forma ýokary-aşak okalýar. Baglanyşykly field-ler ýakyn. "E-poçta" bilen "Parol" hemişe biri-biriniň aşagynda.

05 / GAP DÜZGÜNLERI

# Form içindäki aralyklar


DÜZGÜN — Form Field arasynda space-5 (24px). Space-3 (12px) gysylan görünýär. Space-6+ forma uzyn bolsa bölümlere bölünip biler.

06 / FULL SPEC

# Form Field doly spec


## DOĞRY / NÄDOĞRY



### Table 1

| ÝAGDAÝ | DÜZGÜN | MYSAL |
| --- | --- | --- |
| Required | * goşulýar (error-main reňk) | E-poçta ✱ |
| Optional | "(opsional)" goşulýar (text-tertiary) | Bellik (opsional) |
| Gizlin label | aria-label bilen (görünmez, ýöne bar) | Search bar ýaly |

### Table 2

| ÝAGDAÝ | NÄDOĞRY | DOĞRY |
| --- | --- | --- |
| Boş field | "Bu meýdan hökmany" | "E-poçta adresiňizi girizi" |
| Nädogry format | "Nädogry e-poçta" | "Dogry e-poçta: aman@mysal.com" |
| Gysga parol | "Parol gysga" | "Parol iň az 8 harp bolmaly" |
| Eýýäm bar | "Ulanyjy bar" | "Bu e-poçta eýýäm hasaba alnan" |

### Table 3

| ELEMENT | GAP | TOKEN |
| --- | --- | --- |
| Label → Field | 8px | space-2 |
| Field → Help/Error | 4px | space-1 |
| Field-den Field-e (forma içi) | 20px | space-5 |
| Forma bölümleri arasynda | 32px | space-6 |
| Forma → Button | 24px | space-5 |

### Table 4

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Label font | Plus Jakarta Regular 13px |
| Label reňk | text-secondary (neutral-500) |
| Required star | error-main (#C93B52) |
| Help font | Plus Jakarta Regular 13px |
| Help reňk | text-tertiary (neutral-400) |
| Error font | Plus Jakarta Regular 13px |
| Error reňk | error-main (#C93B52) |
| Label-Field gap | 8px (space-2) |
| Field-Help gap | 4px (space-1) |
| Field arasy gap | 24px (space-5) |

### Table 5

| DOĞRY | NÄDOĞRY |
| --- | --- |
| Label hemişe görünýär | Diňe placeholder (label ýok) |
| Required * error-main reňk | * gara ýa-da başga reňk |
| Error konstruktiw tekst | "Ýalňyş" diýen umumy habar |
| Mobile ýekebir sütün | Mobile iki sütün |
| Field arasy space-5 (24px) | Field arasy space-2 (8px) gysylan |