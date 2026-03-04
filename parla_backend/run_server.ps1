# Parla backend - gurmak we işletmek
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "=== Parla backend - gurmak we işletmek ===" -ForegroundColor Cyan

if (-not (Test-Path "venv")) {
    Write-Host "Venv döredilýär..." -ForegroundColor Yellow
    try {
        python -m venv venv
    } catch {
        Write-Host "YALNYS: Python tapylmady. Python ýükleyň: https://www.python.org/downloads/" -ForegroundColor Red
        Read-Host "Dewam etmek üçin Enter basyň"
        exit 1
    }
}

& ".\venv\Scripts\Activate.ps1"
Write-Host "Paketler barlanýar..." -ForegroundColor Yellow
pip install -r requirements.txt -q

if (-not (Test-Path "parla.db")) {
    Write-Host "Seed işlenýär (ilkinji gezek)..." -ForegroundColor Yellow
    python seed_db.py
}

Write-Host ""
Write-Host "Serwer işledilýär: http://localhost:8000" -ForegroundColor Green
Write-Host "Dokumantasiýa: http://localhost:8000/docs" -ForegroundColor Green
Write-Host "Durdurmak üçin Ctrl+C basyň." -ForegroundColor Gray
Write-Host ""
uvicorn main:app --reload --host 0.0.0.0 --port 8000
