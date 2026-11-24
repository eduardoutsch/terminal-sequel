@echo off
setlocal EnableExtensions

cd /d "%~dp0"

echo ============================================
echo   terminal-sequel: 3-Engine SQL Setup
echo   (PostgreSQL + MySQL + SQLite)
echo ============================================
echo.

where docker >nul 2>&1
if errorlevel 1 (
    if exist "%ProgramFiles%\Docker\Docker\resources\bin\docker.exe" (
        set "PATH=%ProgramFiles%\Docker\Docker\resources\bin;%PATH%"
    )
)

where docker >nul 2>&1
if errorlevel 1 (
    echo Docker not found. Attempting automatic installation via winget...
    where winget >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Neither Docker nor winget was found.
        echo Please install Docker Desktop manually: https://www.docker.com/products/docker-desktop/
        echo.
        pause
        exit /b 1
    )
    winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
    if errorlevel 1 (
        echo [ERROR] Failed to install Docker Desktop via winget.
        echo Please install Docker Desktop manually: https://www.docker.com/products/docker-desktop/
        echo.
        pause
        exit /b 1
    )
    if exist "%ProgramFiles%\Docker\Docker\resources\bin\docker.exe" (
        set "PATH=%ProgramFiles%\Docker\Docker\resources\bin;%PATH%"
    )
)

where wt.exe >nul 2>&1
if errorlevel 1 (
    if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\wt.exe" (
        set "PATH=%LOCALAPPDATA%\Microsoft\WindowsApps;%PATH%"
    )
)

where wt.exe >nul 2>&1
if errorlevel 1 (
    echo Windows Terminal not found. Attempting automatic installation via winget...
    where winget >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Neither Windows Terminal nor winget was found.
        echo Please install Windows Terminal from the Microsoft Store.
        echo.
        pause
        exit /b 1
    )
    winget install -e --id Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements
    if errorlevel 1 (
        echo [ERROR] Failed to install Windows Terminal via winget.
        echo.
        pause
        exit /b 1
    )
    if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\wt.exe" (
        set "PATH=%LOCALAPPDATA%\Microsoft\WindowsApps;%PATH%"
    )
)

docker info >nul 2>&1
if not errorlevel 1 goto docker_ready

if not exist "%ProgramFiles%\Docker\Docker\Docker Desktop.exe" (
    echo [ERROR] Docker Desktop executable was not found at "%ProgramFiles%\Docker\Docker\Docker Desktop.exe".
    echo If Docker Desktop just finished installing, please reboot Windows if prompted and re-run setup.bat.
    echo.
    pause
    exit /b 1
)

echo Docker daemon is not running. Starting Docker Desktop...
start "" "%ProgramFiles%\Docker\Docker\Docker Desktop.exe"
echo Waiting for Docker daemon to become ready...
set /a _tries=0

:wait_docker
timeout /t 3 /nobreak >nul
docker info >nul 2>&1
if not errorlevel 1 goto docker_ready
set /a _tries+=1
if %_tries% geq 60 (
    echo [ERROR] Timed out waiting for Docker Desktop to start.
    echo If this is a fresh install, finish any first-run prompt or reboot Windows, then re-run setup.bat.
    echo.
    pause
    exit /b 1
)
goto wait_docker

:docker_ready
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start.ps1" %*
if errorlevel 1 (
    echo.
    echo [ERROR] Setup failed. See output above for details.
    pause
    exit /b %errorlevel%
)

exit /b 0
