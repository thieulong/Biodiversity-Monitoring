@echo off
echo BIODIVERSITY DASHBOARD CLEANUP
echo.

REM Check for Docker
where docker >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo Docker is not installed or not in PATH.
    pause
    exit /b
)

REM Stop and remove containers
echo Stopping and removing containers...
docker compose down --volumes --remove-orphans

REM Clean up images
echo.
echo Removing images...
docker image prune -a -f

REM Clean up volumes
echo.
echo Removing dangling volumes...
docker volume prune -f

REM Clean up networks
echo.
echo Removing unused networks...
docker network prune -f

REM Ask to delete project folder
set /p deleteFolder=Do you want to delete this project folder? (y/N): 
IF /I "%deleteFolder%"=="y" (
    echo Deleting folder: %cd%
    cd ..
    rmdir /s /q "%~dp0"
    echo Folder deleted.
) ELSE (
    echo Project folder was not deleted.
)

echo.
echo Uninstallation complete.
pause
