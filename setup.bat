@echo off
setlocal EnableExtensions

cd /d "%~dp0"

echo ============================================
echo   terminal-sequel: 3-Engine SQL Setup
echo   (PostgreSQL + MySQL + SQLite)
echo ============================================
echo.

call :ensure_docker
if errorlevel 1 goto fail

call :ensure_wt

call :ensure_docker_daemon
if errorlevel 1 goto fail

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\start.ps1" %*
if errorlevel 1 goto fail

exit /b 0

:ensure_docker
where docker >nul 2>&1
if not errorlevel 1 exit /b 0
if exist "%ProgramFiles%\Docker\Docker\resources\bin\docker.exe" (
    set "PATH=%ProgramFiles%\Docker\Docker\resources\bin;%PATH%"
    exit /b 0
)
echo Docker not found. Attempting automatic installation via winget...
where winget >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Neither Docker nor winget was found.
    echo Please install Docker Desktop manually: https://www.docker.com/products/docker-desktop/
    exit /b 1
)
winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
if errorlevel 1 (
    echo [ERROR] Failed to install Docker Desktop via winget.
    exit /b 1
)
if exist "%ProgramFiles%\Docker\Docker\resources\bin\docker.exe" (
    set "PATH=%ProgramFiles%\Docker\Docker\resources\bin;%PATH%"
)
exit /b 0

:ensure_wt
where wt.exe >nul 2>&1
if not errorlevel 1 exit /b 0
if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\wt.exe" (
    set "PATH=%LOCALAPPDATA%\Microsoft\WindowsApps;%PATH%"
    exit /b 0
)
where winget >nul 2>&1
if errorlevel 1 exit /b 0
echo Windows Terminal not found. Attempting automatic installation via winget...
winget install -e --id Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements >nul 2>&1
if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\wt.exe" (
    set "PATH=%LOCALAPPDATA%\Microsoft\WindowsApps;%PATH%"
)
exit /b 0

:ensure_docker_daemon
docker info >nul 2>&1
if not errorlevel 1 exit /b 0
if not exist "%ProgramFiles%\Docker\Docker\Docker Desktop.exe" (
    echo [ERROR] Docker Desktop executable was not found.
    echo If Docker Desktop just finished installing, reboot Windows if prompted and re-run setup.bat.
    exit /b 1
)
echo Docker daemon is not running. Starting Docker Desktop...
start "" "%ProgramFiles%\Docker\Docker\Docker Desktop.exe"
echo Waiting for Docker daemon to become ready...
set /a _tries=0

:wait_docker
timeout /t 3 /nobreak >nul
docker info >nul 2>&1
if not errorlevel 1 exit /b 0
set /a _tries+=1
if %_tries% geq 60 (
    echo [ERROR] Timed out waiting for Docker Desktop to start.
    echo If this is a fresh install, finish any first-run prompt or reboot Windows, then re-run setup.bat.
    exit /b 1
)
goto wait_docker

:fail
echo.
pause
exit /b 1
