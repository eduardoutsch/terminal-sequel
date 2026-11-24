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
    echo [ERROR] Docker was not found in PATH.
    echo Please install Docker Desktop: https://www.docker.com/products/docker-desktop/
    echo Or via winget: winget install -e --id Docker.DockerDesktop
    echo.
    pause
    exit /b 1
)

where wt.exe >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Windows Terminal ^(wt.exe^) was not found in PATH.
    echo Please install Windows Terminal from the Microsoft Store
    echo or via winget: winget install -e --id Microsoft.WindowsTerminal
    echo.
    pause
    exit /b 1
)

docker info >nul 2>&1
if not errorlevel 1 goto docker_ready

if not exist "%ProgramFiles%\Docker\Docker\Docker Desktop.exe" (
    echo [ERROR] Docker daemon is not running.
    echo Please start Docker Desktop and re-run setup.bat.
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
if %_tries% geq 30 (
    echo [ERROR] Timed out waiting for Docker Desktop to start.
    echo Please start Docker Desktop manually and re-run setup.bat.
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
