PARLA

Design System

Components — v0.1

ATOM 01 — BUTTON

6 variant, 3 size, 5 state, icon ulanyşy


01 / ANATOMY

# Button bölekleri

Button — komponent kitaphanasynyň esasy. Başgalary (form, modal, card) hemmesi button ulanýar.


┌─────────────────────────────────┐

│  [icon]   Label tekst   [icon]   │  height 48

└─────────────────────────────────┘

leading    tekst      trailing



02 / VARIANTLAR

# 6 variant — her biri başga maksat



## Haçan haýsy?

Booking et / Tölegi tassykla   →  Dark CTA   (iň möhüm)

Salon saýla / Dowam et          →  Primary    (esasy)

Yza / Goý                        →  Secondary  (alternatiwa)

Has köp gör →                    →  Ghost      (ikinji derejeli)

Bronu ýatyr / Hasaby poz         →  Destructive

Halanlaryma goş                  →  Soft

DÜZGÜN — Bir ekranda diňe bir Primary ýa Dark CTA. Iki güýçli button — ulanyjy haýsyna basmaly bilmeýär.


03 / ÖLÇEGLER

# 3 size


DÜZGÜN — DEFAULT — Large (48). Small diňe ýörite kompakt ýerlerde. Booking CTA hemişe Large.


04 / STATE-LER

# 5 state — Primary mysaly



## Hemme variant state mapy

PRIMARY:      brand-500 → brand-600 → brand-700

DARK CTA:     neutral-900 → brand-900 → brand-800

SECONDARY:    border-default → border-strong → brand-50 bg

GHOST:        transparent → brand-50 bg → brand-100 bg

DESTRUCTIVE:  error-main → error-strong → error-strong+scale

SOFT:         brand-50 → brand-100 → brand-200

DÜZGÜN — Pressed state hemişe scale 0.96. Disabled state hiç haçan scale däl (interaktiw däl).


05 / LOADING

# Loading state — möhüm detal

Button basylanda we API jogap garaşýarka spinner görkezilýär.


[  ⟳ Spinner  ]    tekst gizlenýär (opacity 0)

spinner reňk: text reňki

button ölçegi üýtgemeýär


Kritik: Loading-da button ölçegini saklamaly. Tekst "Tölegi tassykla" 200px bolsa, loading-da hem 200px. Ýogsa layout "bökýär".

DÜZGÜN — Loading button ölçegi üýtgemez. Spinner tekstiň ortasynda, tekst görünmez (opacity 0) ýöne ýer eýeleýär.


06 / ICON

# Icon ulanyşy



Icon ölçeg: size-icon-md (24) Large/Medium-da, size-icon-sm (20) Small-da. Icon-text gap: space-2 (8px).

DÜZGÜN — Icon-only button hemişe radius-full we 48×48 tap area. Leading/trailing icon tekst bilen 8px gap.


07 / FULL SPEC

# Large Primary — doly spec


DÜZGÜN — Button-da shadow ÝOK. Tegiz durýar. Shadow diňe FAB (floating action button) üçin.


08 / DOĞRY · NÄDOĞRY

# Şahsy düzgünler


## DOĞRY


## NÄDOĞRY


09 / ACCESSIBILITY

# Elýeterlilik


- Min tap target 48×48 — Small button görünýän 36, tap area 48
- Disabled — opacity däl, solgun reňk (brand-200)
- Loading — aria-busy, screen reader "ýüklenýär"
- Focus — focus-ring outline (klawiatura)
- Text contrast — Primary ak/brand-500 = 4.5:1 (uly tekst) ✓
DÜZGÜN — Small button görünýän 36px, ýöne tap area 48px (görünmeýän padding). Hiç button 48px tap-dan kiçi däl.


10 / JEMI

# Button — soňky netije


VARIANTLAR (6):  Primary · Dark CTA · Secondary · Ghost

Destructive · Soft

SIZE (3):        Small 36 · Medium 44 · Large 48 (default)

STATE (5):       Default · Hover · Pressed · Disabled · Loading

ICON (3):        Leading · Trailing · Icon-only

RADIUS:          radius-lg (16), icon-only radius-full

TAP FEEDBACK:    scale 0.96, instant, ease-out

SHADOW:          none


## Iň möhüm 6 düzgün

DÜZGÜN — Bir ekranda diňe 1 Primary ýa Dark CTA.

DÜZGÜN — Button-da shadow ÝOK. Tegiz durýar.

DÜZGÜN — Pressed scale 0.96. Disabled scale ÝOK.

DÜZGÜN — Loading button ölçegi saklaýar.

DÜZGÜN — Icon-only hemişe tegelek (radius-full).

DÜZGÜN — CTA hemişe Large. Min tap 48×48.


11 / INDIKI

# Indiki atom — Input

Button taýyn. Indiki atom — Input (text field). Şu zatlary kesgitläris:

- Input anatomy (label, field, help, error)
- State-ler (default, focus, error, disabled, filled)
- Variant-lar (text, email, password, search, textarea)
- Validation pattern

— Atom 02-ä geçýäris —

PARLA

Design System

Components — v0.1

ATOM 02 — INPUT

6 variant, 5 state, validation pattern, accessibility


01 / ANATOMY

# Input bölekleri — 4 gatly gurluş


[Label tekst]                          ← caption 13, text-secondary

┌─────────────────────────────────┐

│  [lead]  Placeholder...  [trail]  │   height 48

└─────────────────────────────────┘

[Help tekst ýa-da Error tekst]       ← caption 13



## Gap düzgünleri

- Label → Field arasy: space-2 (8px)
- Field → Help/Error arasy: space-1 (4px)
DÜZGÜN — Label hemişe görünýär — placeholder DÄL. Placeholder ýazylanda ýitýär — ulanyjy näme soralandygyny ýatdan çykarýar.


02 / STATE-LER

# 5 ýagdaý



## Focus shadow — premium detal

border: 1.5px solid brand-500

box-shadow: 0 0 0 4px rgba(168, 82, 126, 0.12)

Bu — Stripe, Linear, Apple ulanýan pattern. Diňe border reňk däl — soft brand halo hem goşulýar.

DÜZGÜN — Focus-da border + halo bilelikde. Diňe border reňk — premium detal ýok.

DÜZGÜN — Disabled-da opacity üýtgemeýär. Background neutral-100, border-default, text-tertiary.


03 / VARIANTLAR

# 6 görnüş



04 / PHONE VARIANT

# Türkmen telefon — möhüm detal

Parla Türkmenistan üçin. Phone field — esasy ulanylýan field (login, profil, bron tassyklama).


┌──────────────────────────────────┐

│  +993 │  __  __ - __ - __        │

└──────────────────────────────────┘

prefix    format hint (text-tertiary)


## Gurluşy

- Prefix "+993" — field içinde çep, divider bilen bölünen
- Ulanyjy diňe sanlary girýär (8 san)
- Format mask: XX XX-XX-XX — otomatik goşulýar
- Klaviatura type: numeric (autocomplete="tel")
- Placeholder format hint text-tertiary reňkde
DÜZGÜN — Format ulanyjyda däl, komponentde. Ulanyjy diňe sanlary girýär — formatlama otomatik.

DÜZGÜN — "autocomplete=tel" goýulsa iOS/Android sanly klaviatura açýar. UX gowulanýar.


05 / SEARCH VARIANT

# Search — iki ölçeg

Salon sanawy, hyzmat sanawy — hemmesinde Search gerek.


## Full search bar (ekran ýokarsy)


## Compact search (list içi)

DÜZGÜN — Search bar background neutral-100 (surface). Scaffold bg krem (neutral-50) — ak search bar ýitip gidýär.


06 / TEXTAREA

# Textarea — aýratyn düzgünler


DÜZGÜN — Textarea horizontal resize ÝOK. Horizontal süýşürmek sahypany bozýar. Diňe vertikal.


07 / VALIDATION

# Parla validation pattern — blur-da

Validation — iki ýol bar. Biz "blur-da" saýlaýarys (fokus başga ýere geçende).



## Blur validation işleýiş tertibi

- 1. Ulanyjy email ýazýar
- 2. Başga field-e geçýär (blur)
- 3. Email barlanýar — ýalňyş bolsa error state görünýär
- 4. Ulanyjy düzedende → error aýrylýar (real-time düzediş)

## Error state anatomy

[Email adres]

┌─────────────────────────────────┐

│  ✕  aman@        │ ✕ trailing   │  border: error-main

└─────────────────────────────────┘

↓ Dogry email adres girizi         caption 13, error-main

DÜZGÜN — Error habar — anyk we konstruktiw. "Ýalňyş" däl-de "Dogry email adres girizi" ýaz.


08 / CHARACTER COUNT

# Haçan ulanmaly?

Diňe textarea we çäkli fieldlerde (at 50 harp max ýaly). Adaty text input-da görkezme.


[23/50]   ← sag, caption 13, text-tertiary

┌─────────────────────────────────────────┐

│  Bellik...                               │

│                                         │

└─────────────────────────────────────────┘


DÜZGÜN — Adaty text input-da character count görkezme — gereksiz maglumat noise.


09 / DOĞRY · NÄDOĞRY

# Şahsy düzgünler


## DOĞRY


## NÄDOĞRY


10 / ACCESSIBILITY

# Elýeterlilik


- Label — hemişe görünýär, aria-labelledby bilen baglanyşyk
- Error — aria-invalid="true", aria-describedby → error tekst
- Help — aria-describedby → help tekst
- Required — * nyşan + aria-required
- Focus ring — visible outline (klawiatura nawigasiýasy)
- autocomplete="tel" — iOS/Android sanly klaviatura açýar
- autocomplete="email" — email klaviatura (@ içeren)
DÜZGÜN — "autocomplete" attributes — UX gowulanýar, ulanyjy klaviatura üçin gysmaýar.


11 / FULL SPEC

# Input — doly spec (Default Text)



12 / JEMI

# Input — soňky netije


BÖLEKLER (4):   Label · Field · Leading/Trailing · Help/Error

VARIANTLAR (6): Text · Email · Password · Phone · Search · Textarea

STATE (5):      Default · Focus · Filled · Error · Disabled

VALIDATION:     blur-da (fokus gitdäkde)

HEIGHT:         48 (default), 44 (compact search), 96+ (textarea)

RADIUS:         radius-md (12), search-full radius-full

FOCUS:          1.5px brand-500 + 4px halo rgba(168,82,126,0.12)


## Iň möhüm 7 düzgün

DÜZGÜN — Label hemişe görünýär. Placeholder ýeterlik däl.

DÜZGÜN — Focus-da border + halo bilelikde.

DÜZGÜN — Validation blur-da — real-time ÝOK.

DÜZGÜN — Error habar konstruktiw we anyk.

DÜZGÜN — Phone: +993 prefix inline, autocomplete="tel".

DÜZGÜN — Search bg neutral-100 — scaffold-da görünýär.

DÜZGÜN — Textarea diňe vertical resize.


13 / INDIKI

# Indiki atom — Badge & Chip

Input taýyn. Indiki atomlar — Badge we Chip. Bular ýakyn, şonuň üçin bilelikde.

- Badge anatomy (status, label, count)
- Chip anatomy (filter, tag, action)
- Badge we Chip tapawudy
- Haçan haýsy?

— Atom 03-e geçýäris —

PARLA

Design System

Components — v0.1

ATOM 02 — INPUT

6 variant, 5 state, validation pattern, accessibility


01 / ANATOMY

# Input bölekleri — 4 gatly gurluş


[Label tekst]                          ← caption 13, text-secondary

┌─────────────────────────────────┐

│  [lead]  Placeholder...  [trail]  │   height 48

└─────────────────────────────────┘

[Help tekst ýa-da Error tekst]       ← caption 13



## Gap düzgünleri

- Label → Field arasy: space-2 (8px)
- Field → Help/Error arasy: space-1 (4px)
DÜZGÜN — Label hemişe görünýär — placeholder DÄL. Placeholder ýazylanda ýitýär — ulanyjy näme soralandygyny ýatdan çykarýar.


02 / STATE-LER

# 5 ýagdaý



## Focus shadow — premium detal

border: 1.5px solid brand-500

box-shadow: 0 0 0 4px rgba(168, 82, 126, 0.12)

Bu — Stripe, Linear, Apple ulanýan pattern. Diňe border reňk däl — soft brand halo hem goşulýar.

DÜZGÜN — Focus-da border + halo bilelikde. Diňe border reňk — premium detal ýok.

DÜZGÜN — Disabled-da opacity üýtgemeýär. Background neutral-100, border-default, text-tertiary.


03 / VARIANTLAR

# 6 görnüş



04 / PHONE VARIANT

# Türkmen telefon — möhüm detal

Parla Türkmenistan üçin. Phone field — esasy ulanylýan field (login, profil, bron tassyklama).


┌──────────────────────────────────┐

│  +993 │  __  __ - __ - __        │

└──────────────────────────────────┘

prefix    format hint (text-tertiary)


## Gurluşy

- Prefix "+993" — field içinde çep, divider bilen bölünen
- Ulanyjy diňe sanlary girýär (8 san)
- Format mask: XX XX-XX-XX — otomatik goşulýar
- Klaviatura type: numeric (autocomplete="tel")
- Placeholder format hint text-tertiary reňkde
DÜZGÜN — Format ulanyjyda däl, komponentde. Ulanyjy diňe sanlary girýär — formatlama otomatik.

DÜZGÜN — "autocomplete=tel" goýulsa iOS/Android sanly klaviatura açýar. UX gowulanýar.


05 / SEARCH VARIANT

# Search — iki ölçeg

Salon sanawy, hyzmat sanawy — hemmesinde Search gerek.


## Full search bar (ekran ýokarsy)


## Compact search (list içi)

DÜZGÜN — Search bar background neutral-100 (surface). Scaffold bg krem (neutral-50) — ak search bar ýitip gidýär.


06 / TEXTAREA

# Textarea — aýratyn düzgünler


DÜZGÜN — Textarea horizontal resize ÝOK. Horizontal süýşürmek sahypany bozýar. Diňe vertikal.


07 / VALIDATION

# Parla validation pattern — blur-da

Validation — iki ýol bar. Biz "blur-da" saýlaýarys (fokus başga ýere geçende).



## Blur validation işleýiş tertibi

- 1. Ulanyjy email ýazýar
- 2. Başga field-e geçýär (blur)
- 3. Email barlanýar — ýalňyş bolsa error state görünýär
- 4. Ulanyjy düzedende → error aýrylýar (real-time düzediş)

## Error state anatomy

[Email adres]

┌─────────────────────────────────┐

│  ✕  aman@        │ ✕ trailing   │  border: error-main

└─────────────────────────────────┘

↓ Dogry email adres girizi         caption 13, error-main

DÜZGÜN — Error habar — anyk we konstruktiw. "Ýalňyş" däl-de "Dogry email adres girizi" ýaz.


08 / CHARACTER COUNT

# Haçan ulanmaly?

Diňe textarea we çäkli fieldlerde (at 50 harp max ýaly). Adaty text input-da görkezme.


[23/50]   ← sag, caption 13, text-tertiary

┌─────────────────────────────────────────┐

│  Bellik...                               │

│                                         │

└─────────────────────────────────────────┘


DÜZGÜN — Adaty text input-da character count görkezme — gereksiz maglumat noise.


09 / DOĞRY · NÄDOĞRY

# Şahsy düzgünler


## DOĞRY


## NÄDOĞRY


10 / ACCESSIBILITY

# Elýeterlilik


- Label — hemişe görünýär, aria-labelledby bilen baglanyşyk
- Error — aria-invalid="true", aria-describedby → error tekst
- Help — aria-describedby → help tekst
- Required — * nyşan + aria-required
- Focus ring — visible outline (klawiatura nawigasiýasy)
- autocomplete="tel" — iOS/Android sanly klaviatura açýar
- autocomplete="email" — email klaviatura (@ içeren)
DÜZGÜN — "autocomplete" attributes — UX gowulanýar, ulanyjy klaviatura üçin gysmaýar.


11 / FULL SPEC

# Input — doly spec (Default Text)



12 / JEMI

# Input — soňky netije


BÖLEKLER (4):   Label · Field · Leading/Trailing · Help/Error

VARIANTLAR (6): Text · Email · Password · Phone · Search · Textarea

STATE (5):      Default · Focus · Filled · Error · Disabled

VALIDATION:     blur-da (fokus gitdäkde)

HEIGHT:         48 (default), 44 (compact search), 96+ (textarea)

RADIUS:         radius-md (12), search-full radius-full

FOCUS:          1.5px brand-500 + 4px halo rgba(168,82,126,0.12)


## Iň möhüm 7 düzgün

DÜZGÜN — Label hemişe görünýär. Placeholder ýeterlik däl.

DÜZGÜN — Focus-da border + halo bilelikde.

DÜZGÜN — Validation blur-da — real-time ÝOK.

DÜZGÜN — Error habar konstruktiw we anyk.

DÜZGÜN — Phone: +993 prefix inline, autocomplete="tel".

DÜZGÜN — Search bg neutral-100 — scaffold-da görünýär.

DÜZGÜN — Textarea diňe vertical resize.


13 / INDIKI

# Indiki atom — Badge & Chip

Input taýyn. Indiki atomlar — Badge we Chip. Bular ýakyn, şonuň üçin bilelikde.

- Badge anatomy (status, label, count)
- Chip anatomy (filter, tag, action)
- Badge we Chip tapawudy
- Haçan haýsy?

— Atom 03-e geçýäris —

PARLA

Design System

Components — v0.1

ATOM 03 — BADGE & CHIP

Status, label, count badge · Filter, input, suggestion chip


01 / ESASY TAPAWUT

# Badge vs Chip — näme tapawut?


DÜZGÜN — Badge = passif (maglumat). Chip = interaktiw (hereket). Hiç haçan çalşyrma.


BADGE — BÖLÜM A

# Badge — 3 görnüş


## A.1 — Status Badge

Ýagdaý görkezýär. Dot + tekst bilen. Semantic reňkler ulanýar.



## A.2 — Label Badge

Diňe tekst, dot ýok. Roly görkezýär: PRO, NEW, BETA, PREMIUM.

[ PRO ]   [ NEW ]   [ BETA ]   [ PREMIUM ]

Reňk: brand-50 bg + brand-700 tekst (default) ýa-da neutral-100 + neutral-500.


## A.3 — Count Badge (Notification)

Notification sanlary. Avatar ýa-da icon üstünde ýerleşýär.



- Radius: radius-full (hemişe tegelek/pill)
- Font: Plus Jakarta Bold 11
- Background: error-main (default) ýa-da brand-500
- Tekst: neutral-0 (ak)
- Pozisiýa: icon/avatar sag ýokary burç, +50% daşarsy
DÜZGÜN — 100+ bolsa "99+" görkezilýär. Takyk san (127, 243) notification-da gereksiz.


BADGE — ANATOMY

# Badge spec


DÜZGÜN — Badge teksti hemişe UPPERCASE + 8% letter spacing. Kiçi harp + dykyz badge — okalmagy kyn.


BADGE — PARLA MYSALLARY

# Parla-da badge nerede?



CHIP — BÖLÜM B

# Chip — 3 görnüş


## B.1 — Filter Chip

Kategoriýa saýlamak. Toggle behaviour — basyp saýlaýar, täzeden basyp aýyrýar.

Saýlanmadyk:  [ Saç düzümi ]

Saýlanan:     [✓ Saç düzümi ]   ← bg + border üýtgeýär


## B.2 — Input Chip (Tag)

Ulanyjy goşan tag-lar. Trailing ✕ bilen aýrylyp bilner.

[ Saç düzümi  ✕ ]

[ Kirpik        ✕ ]


## B.3 — Suggestion Chip

Bir gezek basylyp saýlanyp ýitýär ýa-da forma goşulýar. Saýlanan bolup galanok.

[ + 14:00 ]   [ + 14:30 ]   [ + 15:00 ]


CHIP — ANATOMY

# Chip spec


[icon/check]  [tekst]  [✕ trailing]

opsional   body 15   opsional



CHIP — STATE-LER

# Chip state mapy


DÜZGÜN — Saýlanan chip — border brand-500 we bg brand-50. Diňe bg üýtgemek ýeterlik däl — border hem üýtgeýär.


CHIP — PARLA MYSALLARY

# Parla-da chip nerede?



SAÝLAMA REHNAMASY

# Badge mi, Chip mi?

Haýsyny ulanmagy karar bermek kyn bolsa, şu soraglar kömek edýär:



DOĞRY · NÄDOĞRY

# Şahsy düzgünler


## DOĞRY


## NÄDOĞRY


JEMI

# Badge & Chip — soňky netije


BADGE GÖRNÜŞLERI (3):

Status badge  — dot + tekst, semantic reňkler

Label badge   — diňe tekst (PRO, NEW, BETA)

Count badge   — san belgi, radius-full


CHIP GÖRNÜŞLERI (3):

Filter chip   — toggle, saýlan/aýyr

Input chip    — goşulan tag, ✕ aýyrmak

Suggestion    — bir gezeklik tap


BADGE:  height 22, radius-sm 8, micro 11 UPPERCASE, +8% LS

CHIP:   height 36, radius-sm 8, body 15 medium, 0 LS


## Iň möhüm 6 düzgün

DÜZGÜN — Badge = passif. Chip = interaktiw. Hiç haçan çalşyrma.

DÜZGÜN — Badge hemişe UPPERCASE + 8% LS.

DÜZGÜN — Chip hemişe lowercase.

DÜZGÜN — Count badge 100+ → "99+".

DÜZGÜN — Saýlanan chip border + bg bilelikde üýtgeýär.

DÜZGÜN — Chip tap area min 48px (görünýän 36).


INDIKI

# Indiki atom — Avatar

Badge & Chip taýyn. Indiki atom — Avatar. Şu zatlary kesgitläris:

- Avatar 4 ölçeg (sm, md, lg, xl)
- Fallback ýagdaýy (surat ýok bolsa — initials)
- Group avatar (üst-üste)
- Avatar + status dot (online/offline)
- Avatar + count badge

— Atom 04-e geçýäris —


PARLA

Design System

Components — v0.1

ATOM 04 — AVATAR

4 ölçeg · fallback · status dot · group · count badge


01 / FILOSOFIÝA

# Avatar — trust element

Parla gözellik platformasy — adamlar esasy. Ussa profili, salon eýesi, müşderi — hemmesi avatar bilen tanalýar. Avatar diňe surat däl — brand-da ynam dörediji element.

Surat hili — premium duýgy berýär. Surat ýoklugy — ýaman görünmez ýaly, fallback aýratyn dizaýn edilmeli.

DÜZGÜN — Avatar hemişe radius-full (tegelek). Square ýa-da rounded-square avatar Parla-da ÝOK — exception ýok.


02 / ÖLÇEGLER

# 4 avatar ölçegi


DÜZGÜN — Avatar ölçegini el bilen girme. Hemişe sizing scale tokenlerini ulan.


03 / FALLBACK HIERARHIÝASY

# Surat ýok bolsa näme?

Surat hemişe bolmaýar. 3 basgançakly fallback — hiç haçan boş gitmez.



## Initials format

"Aman Gurbanow"  →  "AG"  (2 harp)

"Maral"          →  "M"   (1 harp — diňe bir at)

"+3 artyk"       →  "+3"  (group overflow)


04 / INITIALS REŇK

# Deterministik reňk bellemek

Initials bg reňki random däl — at esasly deterministik. Şonuň üçin "Aman" hemişe bir reňk, "Maral" hemişe başga reňk. Ulanyjy her gireninde başga reňk görmeýär.


## 6 sany reňk jübüt (bg / tekst)


## Algoritm

// At harplarynyň ASCII kody jemlenip 6-a bölünende galan san

int index = name.codeUnits.reduce((a, b) => a + b, 0) % 6;

Color bg = avatarColors[index].background;

Color text = avatarColors[index].foreground;

DÜZGÜN — Initials bg reňki random däl — at esasly deterministik. Hemişe birmeňzeş netije.


05 / STATUS DOT

# Online / offline görkeziji

Avatar üstünde kiçi status dot — ulanyjynyň ýagdaýyny görkezýär.


Avatar (48px):

┌──────────┐

│  Surat   │● ← status dot, SAG AŞAGY

└──────────┘


## Status reňkleri


## Dot ölçegi avatar ölçegine görä

DÜZGÜN — Status dot hemişe SAG AŞAGY burç. Ýokary burç — notification count badge bilen çaknyşýar.

DÜZGÜN — Dot töweregindäki ak border — dot avatar surat bilen garyşmaz ýaly.


06 / COUNT BADGE

# Notification san — avatar bilen

Avatar-da notification count badge (Atom 03 Count Badge spec bilen). Pozisiýa: sag ýokary burç.


Avatar (48px):

┌──────────┐

│  Surat  [3] ← count badge, SAG ÝOKARY

└──────────┘


## Möhüm düzgün — status dot + count badge

Status dot we count badge bir wagtda bolmaýar. Eger ikisi bilelikde gerek bolsa — UI patterns gözden geçirilmeli.


DÜZGÜN — Count badge ýokarda, status dot aşakda. Eger ikisi birden gerek bolsa — UI gözden geçir.


07 / GROUP AVATAR

# Birnäçe adam — üst-üste

Birnäçe adam bir ýerde görkezilende group avatar pattern ulanylýar.


[A][B][C] +3   ← 3 avatar üst-üste, soň "+3" chip


## Overlap spec


## Z-order we max sany

- Z-order: soňky goşulan öňde (z-index artýar)
- Max görkezilen: 3-4 avatar
- Galany: "+N" Suggestion Chip bilen (mysal: "+5")
- "+N" chip: neutral-100 bg, text-primary, radius-full
## Parla-da group avatar nerede?

- Salonuň ussalary — detail sahypa (lg ölçeg)
- Booking-de "Bu wagty kim saýlady" — admin view (sm ölçeg)
- Salon kart-da ussalaryň mini görnüşi (sm ölçeg)
DÜZGÜN — Group avatar max 3-4 görkezilýär. Artyk bolanda "+N" Suggestion Chip bilen.


08 / BIRLIKDE PATTERN

# Avatar + tekst kombinasiýalary

Avatar köplenç tekst ýa-da başga element bilen birlikde görünýär.


## List item pattern (md avatar)

┌─────────────────────────────────────────┐

│  [48]   At Familiýa          headline 17 semibold

│         Hyzmat · ↑ 4.8 ★    caption 13 text-secondary

└─────────────────────────────────────────┘

← 12px gap →


## Profile header pattern (xl avatar)

┌─────────────────────────────────────────┐

│           [120]

│         At Familiýa          title 24

│         Hyzmatyň ady         body 15 text-secondary

│         4.8 ★  127 syn       caption 13

└─────────────────────────────────────────┘


## Gap düzgünleri


09 / LOADING

# Avatar skeleton

Avatar ýüklenende skeleton görkezilýär. Radius-full saklanyp, shimmer animation.


[⬤ skeleton]   ← tegelek, neutral-100, shimmer 1500ms


- Shape: radius-full saklanyp dürli ölçekler (32/48/80/120)
- Background: skeleton-base (neutral-100)
- Shimmer: skeleton-shine (neutral-200), 1500ms loop
- Motion: translateX(-100% → 100%) gradient
DÜZGÜN — Avatar skeleton hemişe tegelek — radius-full. Shimmer 1500ms, haýal we ýumşak.


10 / DOĞRY · NÄDOĞRY

# Şahsy düzgünler


## DOĞRY


## NÄDOĞRY


11 / FULL SPEC

# Avatar — doly spec



12 / JEMI

# Avatar — soňky netije


ÖLÇEGLER (4):   sm 32 · md 48 · lg 80 · xl 120

RADIUS:         radius-full (hemişe)

FALLBACK:       Surat → Initials → Icon (3 basgançak)

INITIALS:       deterministik reňk (at esasly)

STATUS DOT:     sag aşagy, ölçege görä 8-16px

COUNT BADGE:    sag ýokary (Atom 03 spec)

GROUP:          -12px overlap (md), max 3-4 + "+N"

SKELETON:       radius-full, shimmer 1500ms


## Iň möhüm 6 düzgün

DÜZGÜN — Avatar hemişe tegelek. Exception ÝOK.

DÜZGÜN — Initials reňki deterministik — random däl.

DÜZGÜN — Status dot sag aşagy. Count badge sag ýokary.

DÜZGÜN — Ikisi bir wagtda bolmaýar.

DÜZGÜN — Group max 3-4 + "+N" chip.

DÜZGÜN — Surat ýok bolsa boş gitme — fallback gerek.


INDIKI

# Indiki atom — Divider

Avatar taýyn. Indiki soňky atom — Divider. Iň ýönekeý görünýän ýöne iň köp ýalňyşylýan komponent.

- Horizontal vs vertical divider
- Tekst bilen divider ("ýa-da" arasyndaky çyzyk)
- Spacing düzgünleri
- Haçan divider, haçan spacing ýeterlik

— Atom 05-e geçýäris —

PARLA

Design System

Components — v0.1

ATOM 05 — DIVIDER

Horizontal · Vertical · Label · Haçan DÄL

SOŇKY ATOM — Molecules başlamaga taýyn


01 / FILOSOFIÝA

# "Iň köp ýalňyşylýan atom"

Divider — iň ýönekeý görünýän komponent. Bir çyzyk. Ýöne iň köp nädogry ulanylýar. Köp dizaýner her bölümiň arasynda divider goýýar. Netije — sahypa "kapas" ýaly bolýar.


## Esas filosofiýa

Divider — spacing ýeterlik bolmadygynda ulanylýar. Spacing birinji, divider ikinçi.

DÜZGÜN — Spacing birinji, divider ikinçi. Divider gereksiz ýerde goýmak sahypany "kapas" edýär.


02 / GÖRNÜŞLER

# Divider 3 görnüş


## A — Horizontal Divider (iň köp ulanylýan)

─────────────────────────────────    1px çyzyk, border-default


## B — Vertical Divider

│  ← 1px, inline tekst arasynda, tab bar, nav


## C — Label Divider ("ýa-da" pattern)

──────────  ýa-da  ──────────

DÜZGÜN — Label divider diňe iki alternatiw arasynda. "ýa-da", "ýa". Bölüm başlygy üçin DÄL — heading ulan.


03 / SPACING DÜZGÜNI

# Divider özi margin almaz — KRITIK

Iň köp ýalňyşylýan ýer: divider özüne marginTop/marginBottom goşmak. Bu ÝOK. Töweregindäki boş ýeri parent element berýär.


## DOĞRY — parent gap berýär

Column:

Section-A

[gap: space-6 (32px)]    ← parent gap

─────────────────────    ← divider (margin: 0)

[gap: space-6 (32px)]    ← parent gap

Section-B


## NÄDOĞRY — divider özünde margin

Section-A

─────────────────────    ← divider

marginTop: 32           ← ÝALŇYŞ — divider özünde

marginBottom: 32        ← ÝALŇYŞ — divider özünde

Section-B


DÜZGÜN — Divider özi margin almaz. Töweregindäki boş ýeri parent element gap/padding bilen berýär.


04 / HAÇAN DIVIDER — HAÇAN DÄL

# KRITIK karar tablisasy

Bu — iň möhüm bölüm. Ýalňyşmak ýeňil, dogry saýlamak tejribe gerek.



05 / REŇK

# Iki reňk variant


DÜZGÜN — border-strong diňe kompakt ýerlerde (modal, bottom sheet). Adaty content-de border-default ýeterlik.


06 / PARLA MYSALLARY

# Hakyky ulanylýan ýerler


## ✓ Ulanylýan ýerler


## ✗ Ulanylmaýan ýerler

- Home screen bölümleri arasynda — space-7 ýeterlik
- Salon kart aşagy — kart özi bölüji
- Hero image + content arasynda — surat edge-to-edge, divider buggy görünýär
- Scaffold-daky dürli bg bölümler — bg özi separator

07 / DRAG HANDLE

# Bottom sheet drag handle

Bottom sheet-de ýokarsy "drag handle" görünýär. Divider däl — aýratyn element. Ýöne bilelikde ulanylýar.


▬▬▬       ← drag handle

─────────────────  ← divider (opsional)

Bottom sheet content


DÜZGÜN — Drag handle Parla-da swipe edilip ýapylýan bottom sheet-lerde hökmany. Ol divider däl — aýratyn element.


08 / DOĞRY · NÄDOĞRY

# Şahsy düzgünler


## DOĞRY


## NÄDOĞRY


09 / FULL SPEC

# Divider — doly spec



10 / JEMLEÝJI

# Divider — soňky netije


GÖRNÜŞLER (3):

Horizontal   — 1px, 100% width, border-default

Vertical     — 1px, auto height, border-default

Label        — "ýa-da" pattern, tekst + çyzyk

REŇK:          border-default (default), border-strong

MARGIN:        ÝOK — parent gap/padding berýär

DRAG HANDLE:   40×4px, radius-full, neutral-300


## Iň möhüm 6 düzgün

DÜZGÜN — Spacing birinji, divider ikinçi. Gereksiz ýerde goýma.

DÜZGÜN — Divider özi margin almaz — parent berýär.

DÜZGÜN — Dürli bg arasynda divider ÝOK — bg özi bölýär.

DÜZGÜN — Başlykly bölümde divider ÝOK — başlyk özi bölýär.

DÜZGÜN — border-default köpüsi üçin. border-strong diňe kompakt ýerde.

DÜZGÜN — Hemme bölüm arasynda divider — sahypany "kapas" edýär.


🎉 ATOMS — 100%

# Ähli atomlar tamamlandy!

Parla Design System-iň Atom gatlagy doly. Foundation + 5 atom bilen güýçli esas bar.


## Tamamlanan atomlar

- ✓ Atom 01 — Button (6 variant, 3 size, 5 state)
- ✓ Atom 02 — Input (6 variant, validation, türkmen telefon)
- ✓ Atom 03 — Badge & Chip (3+3 görnüş, saýlama rehnamasy)
- ✓ Atom 04 — Avatar (4 ölçeg, fallback, status dot, group)
- ✓ Atom 05 — Divider (3 görnüş, haçan DÄL karar tablisasy)

## Indiki tapgyr — Molecules

Atomlary birleşdirip Molecules gurýarys. Her molecule — birnäçe atomdan düzülen re-usable blok.

- Molecule 01 — Form Field (Label + Input + Help + Error)
- Molecule 02 — Service Card (Salon hyzmat karty)
- Molecule 03 — Stat Card (KPI we analitika)
- Molecule 04 — List Item (Avatar + tekst + trailing action)
- Molecule 05 — Master Card (Ussa profil mini-karty)

— Molecules başlaýarys —



### Table 1

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Height (default) | 48px (size-control-lg) |
| Padding | 12px (Y) × 20px (X) |
| Radius | 16px (radius-lg) |
| Font | Plus Jakarta SemiBold 17 (headline) |
| Icon size | 24px (size-icon-md) |
| Icon-text gap | 8px (space-2) |
| Shadow | none |
| Tap feedback | scale 0.96, instant 100ms, ease-out |

### Table 2

| VARIANT | MAKSAT | BACKGROUND | TEKST | BORDER |
| --- | --- | --- | --- | --- |
| Primary | Esasy hereket | brand-500 | ak | ýok |
| Dark CTA | Iň güýçli hereket | neutral-900 | ak | ýok |
| Secondary | Alternatiwa | neutral-0 (ak) | brand-600 | border-default |
| Ghost | Ikinji derejeli | transparent | brand-600 | ýok |
| Destructive | Poz, ýatyr | error-main | ak | ýok |
| Soft | Ýumşak aksent | brand-50 | brand-700 | ýok |

### Table 3

| SIZE | HEIGHT | PADDING | FONT | ULANYŞ |
| --- | --- | --- | --- | --- |
| Small | 36 | 8 × 14 | body 15 | Kompakt |
| Medium | 44 | 10 × 18 | headline 17 | Dense form |
| Large | 48 | 12 × 20 | headline 17 | DEFAULT — CTA |

### Table 4

| STATE | BACKGROUND | TRANSFORM | SEBÄBI |
| --- | --- | --- | --- |
| Default | brand-500 | scale 1.0 | Adaty |
| Hover | brand-600 | scale 1.0 | Garaňkylaşýar |
| Pressed | brand-700 | scale 0.96 | Garaňky + tap feedback |
| Disabled | brand-200 | scale 1.0 | Solgun, text brand-400 |
| Loading | brand-500 | scale 1.0 | Spinner + tekst gizlin |

### Table 5

| POSITION | ULANYŞ | MYSAL |
| --- | --- | --- |
| Leading | Hereketi düşündirýär | + Täze bron, ↓ Göçür |
| Trailing | Ugur görkezýär | Dowam →, Has köp ↓ |
| Icon only | Kompakt, tanalýan | ← yza, ✕ ýap, ♡ halamak |

### Table 6

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Background | brand-500 (#A8527E) |
| Text color | text-on-brand (#FFFFFF) |
| Font | Plus Jakarta SemiBold 17px |
| Height | 48px (size-control-lg) |
| Padding | 12px (Y) × 20px (X) |
| Radius | 16px (radius-lg) |
| Icon size | 24px (size-icon-md) |
| Icon gap | 8px (space-2) |
| Shadow | none |
| Tap feedback | scale 0.96, instant 100ms, ease-out |

### Table 7

| MYSAL | SEBÄBI |
| --- | --- |
| Bir ekranda 1 Primary + birnäçe Ghost | Anyk hierarhiýa |
| "Tölegi tassykla" — Dark CTA Large | Iň möhüm hereket |
| Loading-da ölçeg saklaýar | Layout shift ÝOK |
| Pressed scale 0.96 | Tap feedback |
| Destructive diňe poz/ýatyr üçin | Howp anyk |

### Table 8

| ÝALŇYŞLYK | SEBÄBI |
| --- | --- |
| Bir ekranda 2 Primary | Ulanyjy ikirjiňleýär |
| Button-da shadow | Tegiz bolmaly — FAB däl |
| Disabled-da scale animation | Interaktiw däl ahyry |
| Loading-da ölçeg üýtgemegi | Layout "bökýär" |
| Cancel button Destructive | Cancel howply däl — Secondary |
| Icon-only square radius | Icon-only hemişe tegelek |
| Small button esasy CTA-da | CTA hemişe Large |

### Table 9

| BÖLÜM | TOKEN | BELLIK |
| --- | --- | --- |
| Label | caption 13 / text-secondary | Field ýokarsy. Hemişe görünýär |
| Field (container) | height 48, radius-md 12 | Padding: 12×16 |
| Placeholder | body 15 / text-tertiary | Field boş wagty görünýär |
| Value tekst | body 15 / text-primary | Ulanyjy ýazanda |
| Leading element | icon-sm 20 | Field içinde çep tarap |
| Trailing element | icon-sm 20 | Field içinde sag tarap |
| Help tekst | caption 13 / text-tertiary | Field aşagy — kömek |
| Error tekst | caption 13 / error-main | Help ýerine — ýalňyşda |

### Table 10

| STATE | BORDER | BACKGROUND | TEKST |
| --- | --- | --- | --- |
| Default | border-default 1px | neutral-0 | placeholder: text-tertiary |
| Focus | brand-500 1.5px + halo | neutral-0 | text-primary (ulanyjy) |
| Filled | border-default 1px | neutral-0 | text-primary |
| Error | error-main 1.5px | neutral-0 | text-primary (value) |
| Disabled | border-default 1px | neutral-100 | text-tertiary |

### Table 11

| VARIANT | AÝRATYNLYGY | ULANYŞ |
| --- | --- | --- |
| Text | Adaty giriş | At, familiýa, adres |
| Email | @-işaret icon leading | Email adres |
| Password | Görkezme toggle trailing | Açar söz |
| Phone | +993 prefix inline | Türkmen telefon belgi |
| Search | 🔍 leading, ✕ trailing (text girizilende) | Salon, hyzmat gözleg |
| Textarea | Birnäçe setir, vertical resize | Bellik, goşmaça habar |

### Table 12

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Height | 48 (size-control-lg) |
| Radius | radius-lg (16) — card bilen meňzeş |
| Leading | 🔍 icon (size-icon-md 24) |
| Trailing | ✕ — diňe text girizilende görünýär |
| Background | neutral-100 (surface) — ak DÄL |

### Table 13

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Height | 44 (size-control-md) |
| Radius | radius-full — pill görnüş |
| Background | neutral-100 |

### Table 14

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Min height | 96px (3 setir) |
| Max height | 200px — soň awtomatik scroll |
| Resize | Diňe vertikal |
| Radius | radius-md (12) — adaty input bilen sync |
| Padding | 12×16 — adaty input ýaly |

### Table 15

| USUL | ARTYKMAÇLYGY | KEMÇILIGI |
| --- | --- | --- |
| Real-time | Derrew habar | Tamamlamanka "ýalňyş" — gyjyndyrýar |
| Submit-da | Soňra barlanýar | Ýalňyşy gaty soň tapýar |
| Blur-da ← | Ýazyp gutaransoň barlanýar | PARLA SAÝLAWY — orta ýol |

### Table 16

| ÝAGDAÝ | REŇK |
| --- | --- |
| 0-79% dolan | text-tertiary — görünmez ýaly |
| 80%+ dolan | warning-main — üns ber |
| 100% dolan | error-main — goşmak rugsat berilmeýär |

### Table 17

| MYSAL | SEBÄBI |
| --- | --- |
| Label hemişe görünýär | Ulanyjy ýatdan çykarmaýar |
| Focus-da border + halo | Premium detal |
| Validation blur-da | Gyjyndyrmaýar |
| Error habar konstruktiw | Näme etmeli — aýdyň |
| Phone field +993 prefix inline | Format ulanyjyda däl, komponentde |
| Search bg neutral-100 | Scaffold-da görünýär |
| Textarea vertical-only resize | Sahypa bozulmaýar |

### Table 18

| ÝALŇYŞLYK | SEBÄBI |
| --- | --- |
| Diňe placeholder (label ýok) | Ýazanda ýitýär — ulanyjy bilmeýär |
| Real-time validation her harpda | Tamamlamanka ýalňyş görkezilýär |
| "Ýalňyş" diýen error habar | Näme etmeli? Düşüniksiz |
| Focus-da diňe border reňk | Premium halo ýok |
| Disabled opacity bilen | bg+border üýtgemeli |
| Textarea horizontal resize | Sahypa bozulýar |
| Search ak bg scaffold-da | Ýitip gidýär |
| Character count hemme ýerde | Gereksiz maglumat noise |

### Table 19

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Height | 48px (size-control-lg) |
| Padding | 12px (Y) × 16px (X) |
| Radius | 12px (radius-md) |
| Border default | 1px solid border-default |
| Border focus | 1.5px solid brand-500 |
| Border error | 1.5px solid error-main |
| Focus shadow | 0 0 0 4px rgba(168,82,126,0.12) |
| Background | neutral-0 (default/focus/error) |
| Background disabled | neutral-100 |
| Value font | Plus Jakarta Regular 15px |
| Label font | Plus Jakarta Regular 13px, text-secondary |
| Help/Error font | Plus Jakarta Regular 13px |
| Label-field gap | 8px (space-2) |
| Field-help gap | 4px (space-1) |

### Table 20

| BÖLÜM | TOKEN | BELLIK |
| --- | --- | --- |
| Label | caption 13 / text-secondary | Field ýokarsy. Hemişe görünýär |
| Field (container) | height 48, radius-md 12 | Padding: 12×16 |
| Placeholder | body 15 / text-tertiary | Field boş wagty görünýär |
| Value tekst | body 15 / text-primary | Ulanyjy ýazanda |
| Leading element | icon-sm 20 | Field içinde çep tarap |
| Trailing element | icon-sm 20 | Field içinde sag tarap |
| Help tekst | caption 13 / text-tertiary | Field aşagy — kömek |
| Error tekst | caption 13 / error-main | Help ýerine — ýalňyşda |

### Table 21

| STATE | BORDER | BACKGROUND | TEKST |
| --- | --- | --- | --- |
| Default | border-default 1px | neutral-0 | placeholder: text-tertiary |
| Focus | brand-500 1.5px + halo | neutral-0 | text-primary (ulanyjy) |
| Filled | border-default 1px | neutral-0 | text-primary |
| Error | error-main 1.5px | neutral-0 | text-primary (value) |
| Disabled | border-default 1px | neutral-100 | text-tertiary |

### Table 22

| VARIANT | AÝRATYNLYGY | ULANYŞ |
| --- | --- | --- |
| Text | Adaty giriş | At, familiýa, adres |
| Email | @-işaret icon leading | Email adres |
| Password | Görkezme toggle trailing | Açar söz |
| Phone | +993 prefix inline | Türkmen telefon belgi |
| Search | 🔍 leading, ✕ trailing (text girizilende) | Salon, hyzmat gözleg |
| Textarea | Birnäçe setir, vertical resize | Bellik, goşmaça habar |

### Table 23

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Height | 48 (size-control-lg) |
| Radius | radius-lg (16) — card bilen meňzeş |
| Leading | 🔍 icon (size-icon-md 24) |
| Trailing | ✕ — diňe text girizilende görünýär |
| Background | neutral-100 (surface) — ak DÄL |

### Table 24

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Height | 44 (size-control-md) |
| Radius | radius-full — pill görnüş |
| Background | neutral-100 |

### Table 25

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Min height | 96px (3 setir) |
| Max height | 200px — soň awtomatik scroll |
| Resize | Diňe vertikal |
| Radius | radius-md (12) — adaty input bilen sync |
| Padding | 12×16 — adaty input ýaly |

### Table 26

| USUL | ARTYKMAÇLYGY | KEMÇILIGI |
| --- | --- | --- |
| Real-time | Derrew habar | Tamamlamanka "ýalňyş" — gyjyndyrýar |
| Submit-da | Soňra barlanýar | Ýalňyşy gaty soň tapýar |
| Blur-da ← | Ýazyp gutaransoň barlanýar | PARLA SAÝLAWY — orta ýol |

### Table 27

| ÝAGDAÝ | REŇK |
| --- | --- |
| 0-79% dolan | text-tertiary — görünmez ýaly |
| 80%+ dolan | warning-main — üns ber |
| 100% dolan | error-main — goşmak rugsat berilmeýär |

### Table 28

| MYSAL | SEBÄBI |
| --- | --- |
| Label hemişe görünýär | Ulanyjy ýatdan çykarmaýar |
| Focus-da border + halo | Premium detal |
| Validation blur-da | Gyjyndyrmaýar |
| Error habar konstruktiw | Näme etmeli — aýdyň |
| Phone field +993 prefix inline | Format ulanyjyda däl, komponentde |
| Search bg neutral-100 | Scaffold-da görünýär |
| Textarea vertical-only resize | Sahypa bozulmaýar |

### Table 29

| ÝALŇYŞLYK | SEBÄBI |
| --- | --- |
| Diňe placeholder (label ýok) | Ýazanda ýitýär — ulanyjy bilmeýär |
| Real-time validation her harpda | Tamamlamanka ýalňyş görkezilýär |
| "Ýalňyş" diýen error habar | Näme etmeli? Düşüniksiz |
| Focus-da diňe border reňk | Premium halo ýok |
| Disabled opacity bilen | bg+border üýtgemeli |
| Textarea horizontal resize | Sahypa bozulýar |
| Search ak bg scaffold-da | Ýitip gidýär |
| Character count hemme ýerde | Gereksiz maglumat noise |

### Table 30

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Height | 48px (size-control-lg) |
| Padding | 12px (Y) × 16px (X) |
| Radius | 12px (radius-md) |
| Border default | 1px solid border-default |
| Border focus | 1.5px solid brand-500 |
| Border error | 1.5px solid error-main |
| Focus shadow | 0 0 0 4px rgba(168,82,126,0.12) |
| Background | neutral-0 (default/focus/error) |
| Background disabled | neutral-100 |
| Value font | Plus Jakarta Regular 15px |
| Label font | Plus Jakarta Regular 13px, text-secondary |
| Help/Error font | Plus Jakarta Regular 13px |
| Label-field gap | 8px (space-2) |
| Field-help gap | 4px (space-1) |

### Table 31

|  | BADGE | CHIP |
| --- | --- | --- |
| Wezipesi | Passif maglumat görkezýär | Interaktiw saýlaw |
| Tap bolýarmy? | ÝOK (ýa-da manysy ýok) | HAWA — saýlaýar/aýyrýar |
| State-leri | Diňe görünýär/görünmeýär | Default, selected, hover, pressed |
| Font | micro 11 UPPERCASE | body 15 Medium |
| Height | 22px (auto) | 36px (size-control-sm) |
| Mysal | "● ACTIVE", "PRO", "4" belgi | "Saç düzümi", "14:00", "✕ Kirpik" |

### Table 32

| VARIANT | BG | TEKST | DOT |
| --- | --- | --- | --- |
| Success | success-soft | success-strong | success-main |
| Warning | warning-soft | warning-strong | warning-main |
| Error | error-soft | error-strong | error-main |
| Info | info-soft | info-strong | info-main |
| Neutral | neutral-100 | neutral-500 | neutral-400 |
| Brand | brand-50 | brand-700 | brand-500 |

### Table 33

| ÝER | ÖLÇEG | GYMMATLYK |
| --- | --- | --- |
| Ýekebir san (1-9) | 18 × 18px | Tegelek |
| Iki san (10-99) | 18 × 22px | Pill |
| 100+ | "99+" | Kesmek — takyk san däl |

### Table 34

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Height | 22px (auto content) |
| Padding | 4px (Y) × 8px (X) |
| Radius | radius-sm (8px) |
| Font | Plus Jakarta SemiBold 11px |
| Text case | UPPERCASE — hemişe |
| Letter spacing | +8% (micro token) |
| Dot size | 6 × 6px, border-radius: 50% |
| Dot-text gap | 4px (space-1) |
| Shadow | none |
| Tap area | ÝOK — badge interaktiw däl |

### Table 35

| ÝAGDAÝ | GÖRNÜŞ | REŇK |
| --- | --- | --- |
| Salon kartynda "● PREMIUM" | Label badge | brand-50 bg + brand-700 tekst |
| Booking "● TASSYKLANDY" | Status badge | success-soft + success-strong |
| Booking "● GARAŞYLÝAR" | Status badge | warning-soft + warning-strong |
| Booking "● ÝATYRYLDY" | Status badge | error-soft + error-strong |
| Avatar üstünde "3" notification | Count badge | error-main bg + ak tekst |
| Ussa kartynda "● BOŞLUK ÝOK" | Status badge | error-soft + error-strong |
| Täze salon "NEW" label | Label badge | brand-50 bg + brand-700 tekst |

### Table 36

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Height | 36px (size-control-sm) |
| Padding | 8px (Y) × 14px (X) |
| Radius | radius-sm (8px) |
| Font | Plus Jakarta Medium 15px |
| Text case | Lowercase — badge bilen tapawutlanmak |
| Letter spacing | 0 (badge +8% CAPS bilen tapawut) |
| Leading icon | size-icon-sm (20px) |
| Trailing icon (✕) | size-icon-sm (20px) |
| Icon-text gap | 6px |
| Tap area | min 48px height (görünýän 36, tap 48) |

### Table 37

| STATE | BACKGROUND | BORDER | TEKST |
| --- | --- | --- | --- |
| Default | neutral-100 | border-default 1px | text-primary |
| Selected | brand-50 | brand-500 1.5px | brand-700 |
| Hover | neutral-200 | border-default 1px | text-primary |
| Pressed | brand-50 | brand-400 1px | brand-600 |
| Disabled | neutral-100 | border-default 1px | text-tertiary |

### Table 38

| ÝAGDAÝ | GÖRNÜŞ | BELLIK |
| --- | --- | --- |
| Salon filter: "Saç düzümi", "Kirpik" | Filter chip | Toggle — köp saýlanyp bilner |
| Wagt saýlama: "14:00", "14:30" | Suggestion chip | Bir gezeklik — saýlanyp ýitýär |
| Gözleg taryhy tag-lary | Input chip | ✕ bilen aýrylyp bilner |
| Mesafe filter: "1 km", "3 km", "5 km" | Filter chip | Bir gezekde 1 saýlamak (radio) |
| Ussa saýlama kartyndaky hyzmatlary | Filter chip | Saýlanylanda bron formuna geçýär |

### Table 39

| SORAG | JOGAP | NETIJE |
| --- | --- | --- |
| Ulanyjy basyp bilýärmi? | ÝOK | → Badge |
| Saýlanan/saýlanmadyk ýagdaýy barmy? | HAWA | → Chip |
| Diňe maglumat görkezýärmi? | HAWA | → Badge |
| Aýrylyp bilnermi (✕ bilen)? | HAWA | → Input Chip |
| Bir gezeklik action (goş, saýla)? | HAWA | → Suggestion Chip |
| Status görkezýärmi (ACTIVE, PENDING)? | HAWA | → Status Badge |
| Notification sany barmy? | HAWA | → Count Badge |

### Table 40

| MYSAL | SEBÄBI |
| --- | --- |
| Badge teksti UPPERCASE | Micro font okalmagy üçin |
| Count badge 99+ | Takyk san gerek däl |
| Filter chip saýlananda border + bg | Kontrast gowy, anyk saýlanan |
| Input chip-de ✕ aýyrmak | Ulanyjy öz goşanyny aýryp bilýär |
| Chip tap area 48px (görünýän 36) | Barmak bilen basmak aňsat |

### Table 41

| ÝALŇYŞLYK | SEBÄBI |
| --- | --- |
| Badge basyp bolmaly | Badge passif — tap area ÝOK |
| Chip-i status üçin ulanmak | Chip interaktiw — ýalňyş signal |
| Count badge 127, 243 görkezmek | 99+ ýeterlik |
| Chip teksti CAPS | Chip lowercase — badge bilen bulaşmaz |
| Saýlanan chip diňe bg üýtgeýär | Border hem gerek — kontrast |
| Badge-da ✕ goýmak | Badge aýrylyp bilinmez — chip ulan |

### Table 42

| TOKEN | PX | RADIUS | ULANYŞ |
| --- | --- | --- | --- |
| size-avatar-sm | 32 | radius-full | Gepleşik, inline tekst içi, list item secondary |
| size-avatar-md | 48 | radius-full | List item primary, comment, notification |
| size-avatar-lg | 80 | radius-full | Ussa kart, salon kart, profil preview |
| size-avatar-xl | 120 | radius-full | Profil sahypa hero, ussa detail |

### Table 43

| # | ÝAGDAÝ | GÖRÜNÜŞ |
| --- | --- | --- |
| 1 | Surat bar | Surat görkezilýär — iň gowy |
| 2 | Surat ýok, at bar | Initials (At + Familiýa ilki harp) |
| 3 | At hem ýok | Generic adam silhueti icon |

### Table 44

| # | BG TOKEN | TEKST TOKEN | SWATCH |
| --- | --- | --- | --- |
| 0 | brand-100 (#F8E0EC) | brand-700 (#6F2B4F) | AG |
| 1 | success-soft (#E3F0E5) | success-strong (#2D6A35) | MN |
| 2 | info-soft (#DFE8F2) | info-strong (#103E72) | BB |
| 3 | warning-soft (#FBF0DC) | warning-strong (#8E5510) | SH |
| 4 | neutral-200 (#E8D9E3) | neutral-700 (#2E2028) | GK |
| 5 | brand-50 (#FCF2F7) | brand-600 (#8E3D66) | RM |

### Table 45

| STATUS | REŇK | MANYSY |
| --- | --- | --- |
| Online | success-main (#4A9447) | Häzir bar, aktif |
| Busy | warning-main (#C77A1A) | Meşgul, häzir boş däl |
| Offline | neutral-300 (#C4AEBA) | Ýok, göçmedi |

### Table 46

| AVATAR | DOT SIZE | BORDER | BORDER REŇK |
| --- | --- | --- | --- |
| sm (32px) | 8 × 8px | 2px | neutral-0 (ak) |
| md (48px) | 10 × 10px | 2px | neutral-0 (ak) |
| lg (80px) | 12 × 12px | 3px | neutral-0 (ak) |
| xl (120px) | 16 × 16px | 3px | neutral-0 (ak) |

### Table 47

| ELEMENT | POZISIÝA | BILELIKDE? |
| --- | --- | --- |
| Count badge (3, 99+) | Sag ýokary burç | Status dot bilen — ÝOK |
| Status dot (●) | Sag aşagy burç | Count badge bilen — ÝOK |

### Table 48

| AVATAR ÖLÇEG | OVERLAP | BELLIK |
| --- | --- | --- |
| sm (32px) | -8px | Her avatar öňkiден 8px çep |
| md (48px) | -12px | Her avatar öňkiден 12px çep |
| lg (80px) | -20px | Her avatar öňkiден 20px çep |

### Table 49

| AVATAR ÖLÇEG | AVATAR → TEKST | TOKEN |
| --- | --- | --- |
| sm (32) / md (48) | 12px | space-3 |
| lg (80) / xl (120) | 16px | space-4 |

### Table 50

| MYSAL | SEBÄBI |
| --- | --- |
| Avatar hemişe tegelek | Brand personality — exception ÝOK |
| Initials deterministik reňk | Hemişe birmeňzeş — ulanyjy tanalýar |
| Status dot sag aşagy | Count badge bilen çaknyşmaýar |
| Count badge sag ýokary | Status dot bilen çaknyşmaýar |
| Group max 3-4 + "+N" | Köp avatar bulaşyklyk döredýär |
| Fallback 3 basgançak (surat → initials → icon) | Hemme ýagdaý örtülýär |

### Table 51

| ÝALŇYŞLYK | SEBÄBI |
| --- | --- |
| Square avatar | Parla-da ÝOK — hemişe tegelek |
| Random initials reňk | Her gireninde başga reňk — täsin |
| Status dot + count badge bir burçda | Çaknyşyp görünmez |
| Surat ýok bolsa boş gitmek | Fallback initials ýa icon gerek |
| Group-da 7-8 avatar görkezmek | Bulaşyk, "+N" ulan |
| Avatar ölçegini el bilen 60px diýip girme | Scale tokenlerini ulan |

### Table 52

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Ölçegler | 32 / 48 / 80 / 120px (sizing tokens) |
| Radius | radius-full (hemişe — exception ÝOK) |
| Object-fit | cover — surat kesmek, deformirlemezlik |
| Fallback 1 | Initials (2 harp), deterministik reňk |
| Fallback 2 | Generic adam silhueti icon |
| Initials font | Plus Jakarta SemiBold (ölçege görä) |
| Status dot pozisiýa | Sag aşagy burç |
| Count badge pozisiýa | Sag ýokary burç |
| Dot border | 2-3px solid neutral-0 (ak) |
| Group overlap | -8px (sm) / -12px (md) / -20px (lg) |
| Group max | 3-4 avatar + "+N" chip |
| Skeleton | radius-full, neutral-100, shimmer 1500ms |
| Shadow | none |

### Table 53

| ILKI ÖZÜŇE SOR | NETIJE |
| --- | --- |
| "Bu ýerde spacing ýeterlik däl bolsa gerek?" | Ýok → divider ulan. Hawa → spacing ulan. |
| "Bu iki bölüm birbirine garyşýarmy?" | Hawa → divider. Ýok → divider gereksiz. |
| "Bg reňki tapawutlymy?" | Hawa → divider ÝOK. Bg özi bölýär. |

### Table 54

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Width | 100% (parent doly ini) |
| Height | 1px |
| Color | border-default (neutral-200 / #E8D9E3) |
| Margin | 0 — parent gap/padding berýär |

### Table 55

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Width | 1px |
| Height | auto ýa-da anyk (tekst beýikligi) |
| Color | border-default |
| Ulanyş | Inline stat, tab bar, action toplumy |

### Table 56

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Çyzyk reňk | border-default |
| Tekst font | caption 13 |
| Tekst reňk | text-tertiary |
| Çyzyk-tekst gap | space-3 (12px) |
| Gurluş | [Divider flex:1] [gap] [Tekst] [gap] [Divider flex:1] |

### Table 57

| ÝAGDAÝ | NÄME ULAN | SEBÄBI |
| --- | --- | --- |
| List item-ler arasynda (ýakyn) | ✓ Divider | Ýakyn spacing-da anyk bölmek gerek |
| Modal header / body arasynda | ✓ Divider | Kompakt, az boş ýer |
| Bottom sheet header aşagy | ✓ Divider | Anyk bölme gerek |
| Login "ýa-da" arasynda | ✓ Label | Iki alternatiw anyk bölündi |
| Inline stat: "4.8 ★ | 127 syn" | ✓ Vertical | Inline bölüji gerek |
| Dürli bg reňkli bölümler arasynda | ✗ Divider ÝOK | Bg reňki özi separator |
| Uly spacing (space-6+) bolan bölümler | ✗ Divider ÝOK | Spacing ýeterlik |
| Başlykly (title/heading) bölümler | ✗ Divider ÝOK | Başlyk özi separator |
| Full-bleed surat aşagy | ✗ Divider ÝOK | Surat özi bölýär |
| Card içi (kart özi bölüji) | Opsional | Card-da kompakt bolsa divider bolup biler |

### Table 58

| TOKEN | HEX | ULANYŞ |
| --- | --- | --- |
| border-default | #E8D9E3 | DEFAULT — ähli adaty divider |
| border-strong | #C4AEBA | Modal footer, güýçli tapawut gerek ýerlerde |

### Table 59

| ÝER | GÖRNÜŞ | REŇK |
| --- | --- | --- |
| Booking form step arasynda | Horizontal | border-default |
| Login "ýa-da" pattern | Label | border-default + caption |
| Modal header / footer arasynda | Horizontal | border-strong |
| Bottom sheet header aşagy | Horizontal | border-default |
| Salon detail — hyzmat/ussa list item | Horizontal | border-default |
| "4.8 ★ | 127 syn | 2 km" inline stat | Vertical | border-default |
| Profil sahypa — bölüm arasynda | Horizontal | border-default |

### Table 60

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Width | 40px |
| Height | 4px |
| Radius | radius-full (tegelek) |
| Color | neutral-300 (#C4AEBA) |
| Pozisiýa | Ýokary merkez (center-aligned) |
| Aşaky boşluk | space-3 (12px) |

### Table 61

| MYSAL | SEBÄBI |
| --- | --- |
| List item arasynda divider | Ýakyn ýerde anyk bölmek |
| Modal header aşagy divider | Kompakt ýer, bölmek gerek |
| "ýa-da" label divider login-da | Iki alternatiw anyk bölündi |
| Divider margin almaz | Parent gap/padding berýär |
| Dürli bg arasynda divider ÝOK | Bg özi bölýär |

### Table 62

| ÝALŇYŞLYK | SEBÄBI |
| --- | --- |
| Hemme bölümiň arasynda divider | Sahypa "kapas" — gözüň ýoly ýitýär |
| Divider özi margin alýar | Parent responsibility — divider ÝOK |
| Başlykly bölüm arasynda divider | Başlyk özi separator |
| Full-bleed surat aşagy divider | Surat özi bölýär — artyk |
| border-strong hemme ýerde | border-default köpüsi üçin ýeterlik |
| Vertical divider height-y kontrolsyz | Height anyk bellenilmeli (tekst beýikligi) |

### Table 63

| ATRIBUT | GYMMATLYK |
| --- | --- |
| Horizontal height | 1px |
| Horizontal width | 100% (parent) |
| Vertical width | 1px |
| Vertical height | auto ýa-da tekst beýikligi |
| Default reňk | border-default (neutral-200 / #E8D9E3) |
| Strong reňk | border-strong (neutral-300 / #C4AEBA) |
| Margin | 0 — parent berýär |
| Label tekst font | caption 13 / text-tertiary |
| Label-čyzyk gap | space-3 (12px) |
| Drag handle size | 40 × 4px, radius-full, neutral-300 |