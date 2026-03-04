# Parla — Häzirki kemçilikler

Soňky täzelenen: 2026-03-02

---

## Backend / Serwer
| # | Kemçilik | Derejesi |
|---|----------|----------|
| 1 | Hakyky serwer ýok — diňe lokal dev serwer (uvicorn + SQLite) | Ýokary |
| 2 | Autentifikasiýa ýok — login, parol, SMS tassyklama ýok | Ýokary |
| 3 | Islendik adam islendik nomeriň bronlaryny görüp bilýär | Ýokary |
| 4 | HTTPS ýok — maglumatlar şifrlenmän geçýär | Ýokary |
| 5 | CORS hemme ýere açyk (`allow_origins=["*"]`) | Orta |
| 6 | Rate limiting ýok — spam/brute-force goragy ýok | Orta |
| 7 | Backup ýok — DB pozulsa maglumatlar ýitýär | Orta |

## Profil sahypasy
| # | Kemçilik | Derejesi |
|---|----------|----------|
| 8 | Profil suraty goşup bolmaýar | Orta |
| 9 | Bir nomerden çäksiz bron edip bolýar | Pes |

## Karta / GPS
| # | Kemçilik | Derejesi |
|---|----------|----------|
| 10 | GPS rugsat awtomatik soralmaýar — diňe doly ekran kartada | Orta |
| 11 | Käbir telefonlarda rugsat el bilen açmaly bolýar | Pes |

## Dizaýn / UI
| # | Kemçilik | Derejesi |
|---|----------|----------|
| 12 | Dark Mode ýok | Pes |
| 13 | Dil saýlamak işlemeýär (placeholder) | Pes |
| 14 | Bildirişler işlemeýär (placeholder) | Pes |
| 15 | Gizlinlik syýasaty we Kömek sahypalary boş | Pes |

## Umumy
| # | Kemçilik | Derejesi |
|---|----------|----------|
| 16 | APK-da serwer adresi hardcoded (IP üýtgese işlemeýär) | Orta |
| 17 | Internetde işlemeýär — diňe LAN / lokal | Ýokary |

---

**Jemi: 17 kemçilik** — 4 ýokary, 6 orta, 7 pes derejeli.
