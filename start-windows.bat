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
echo Your browser will open the Dashboard Start Page.
start "" "%cd%\index.html"
echo.
echo If the dashboard doesn't open automatically, open 'index.html' in this folder.
echo.

pause

