@echo off
echo ================================
echo   BIODIVERSITY DASHBOARD SETUP
echo ================================
echo.

REM Check for Docker Desktop
tasklist /FI "IMAGENAME eq Docker Desktop.exe" | find /I "Docker Desktop.exe" >nul
if errorlevel 1 (
    echo Docker Desktop is not running!
    echo Please install and start Docker Desktop before continuing.
    echo Download here: https://www.docker.com/products/docker-desktop/
    pause
    exit /b
)

echo Starting dashboard services...
docker compose up -d

echo.
echo Dashboard services are starting!
echo Opening dashboard homepage...
REM Use file:// to ensure correct file protocol
start "" "file:///%cd%\index.html"
echo.
echo If the dashboard doesn't open automatically:
echo - Open 'index.html' in this folder
echo - Or open http://localhost:1880/ui/  (CSV upload)
echo - Or open http://localhost:3000/     (Grafana dashboard)
echo.

pause
