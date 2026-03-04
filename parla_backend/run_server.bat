@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo === Parla backend - gurmak we işletmek ===

if not exist "venv" (
    echo Venv döredilýär...
    python -m venv venv
    if errorlevel 1 (
        echo YALNYS: Python tapylmady. Python ýükleyň: https://www.python.org/downloads/
        pause
        exit /b 1
    )
)

call venv\Scripts\activate.bat

echo Paketler barlanýar...
pip install -r requirements.txt -q
if errorlevel 1 (
    echo YALNYS: pip install başartmady.
    pause
    exit /b 1
)

if not exist "parla.db" (
    echo Seed işlenýär (ilkinji gezek)...
    python seed_db.py
)

echo.
echo Serwer işledilýär: http://localhost:8000
echo Dokumantasiýa: http://localhost:8000/docs
echo Durdurmak üçin Ctrl+C basyň.
echo.
uvicorn main:app --reload --host 0.0.0.0 --port 8000

pause
