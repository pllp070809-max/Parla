# Parla Backend (MVP)

## Bir düwmä bilen işletmek (Python ýüklü bolmaly)

- **run_server.bat** — CMD-de çalşyryň ýa-da faýly çift basyň (Windows).
- **run_server.ps1** — PowerShell-de: `.\run_server.ps1`

Skript özü: venv döreder (ýok bolsa), paketleri gurar, seed işler (ilkinji gezek), serweri işleder.

## El bilen

- **Gurmak:** `pip install -r requirements.txt`
- **Seed:** `python seed_db.py` (bir gezek – 3 salon, 7 hyzmat)
- **Işletmek:** `uvicorn main:app --reload --host 0.0.0.0 --port 8000`
- **API:** http://localhost:8000 — docs: http://localhost:8000/docs
