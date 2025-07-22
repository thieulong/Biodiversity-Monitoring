@echo off
echo ================================
echo   BIODIVERSITY DASHBOARD SETUP
echo ================================
echo.

REM Check if Docker Desktop is running
tasklist /FI "IMAGENAME eq Docker Desktop.exe" | find /I "Docker Desktop.exe" >nul
if errorlevel 1 (
    echo Docker Desktop is not running.
    REM Check if Docker Desktop is installed
    if exist "C:\Program Files\Docker\Docker\Docker Desktop.exe" (
        echo Docker Desktop is installed but not running.
        echo Starting Docker Desktop...
        start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
        echo Waiting 20 seconds for Docker Desktop to start...
        timeout /t 20
    ) else (
        echo Docker Desktop is not installed.
        echo Downloading Docker Desktop installer...
        powershell -Command "Invoke-WebRequest -Uri https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe -OutFile \"$env:USERPROFILE\Downloads\DockerDesktopInstaller.exe\""
        echo The Docker Desktop installer has been downloaded to your Downloads folder.
        echo Please run the installer, complete the installation, and then restart this script.
        echo Or download manually: https://www.docker.com/products/docker-desktop/
        pause
        exit /b
    )
)

REM Wait until Docker is fully started and available
:waitfordocker
docker info >nul 2>&1
if errorlevel 1 (
    echo Waiting for Docker Desktop to be ready...
    timeout /t 5
    goto waitfordocker
)

echo Starting dashboard services...
docker compose up -d

echo.
echo Dashboard services are starting!
echo Opening dashboard homepage...
start "" "file:///%cd%\index.html"
echo.
echo If the dashboard doesn't open automatically. Please manually open 'index.html' in this folder
echo.

pause
