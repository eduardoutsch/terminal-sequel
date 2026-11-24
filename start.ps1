<#
.SYNOPSIS
    Starts PostgreSQL, MySQL, and SQLite containers and opens 3 Windows Terminal tabs.
.PARAMETER Reset
    Wipes existing database volumes and re-initializes from ./init/*.sql.
.PARAMETER Panes
    Opens 3 side-by-side split panes instead of 3 full-screen tabs.
#>
param(
    [switch]$Reset,
    [switch]$Panes
)

$ErrorActionPreference = "Stop"
Push-Location $PSScriptRoot

try {
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        Write-Error "Docker was not found in PATH. Install and start Docker Desktop first."
        exit 1
    }

    docker info *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Docker daemon is not running. Start Docker Desktop and try again."
        exit 1
    }

    if ($Reset) {
        Write-Host "Resetting database volumes..." -ForegroundColor Yellow
        docker compose down -v
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }

    Write-Host "Starting PostgreSQL, MySQL, and SQLite containers..." -ForegroundColor Cyan
    docker compose up -d --wait
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to start containers."
        exit $LASTEXITCODE
    }

    $pgCmd     = @("docker", "compose", "exec", "postgres", "psql", "-U", "sql", "-d", "demo")
    $mysqlCmd  = @("docker", "compose", "exec", "-e", "MYSQL_PWD=sql", "mysql", "mysql", "-h", "127.0.0.1", "-u", "root", "demo")
    $sqliteCmd = @("docker", "compose", "exec", "sqlite", "sqlite3", "/data/demo.db")

    if (Get-Command wt.exe -ErrorAction SilentlyContinue) {
        if ($Panes) {
            $wtArgs = @(
                "-w", "sequel-demo",
                "new-tab", "--title", "SQL Engines", "--tabColor", "#336791", "-d", $PSScriptRoot
            ) + $pgCmd + @(
                ";",
                "split-pane", "-H", "-d", $PSScriptRoot
            ) + $mysqlCmd + @(
                ";",
                "split-pane", "-V", "-d", $PSScriptRoot
            ) + $sqliteCmd
        }
        else {
            $wtArgs = @(
                "-w", "sequel-demo",
                "new-tab", "--title", "PostgreSQL", "--tabColor", "#336791", "-d", $PSScriptRoot
            ) + $pgCmd + @(
                ";",
                "new-tab", "--title", "MySQL", "--tabColor", "#F29111", "-d", $PSScriptRoot
            ) + $mysqlCmd + @(
                ";",
                "new-tab", "--title", "SQLite", "--tabColor", "#0F80CC", "-d", $PSScriptRoot
            ) + $sqliteCmd + @(
                ";",
                "focus-tab", "-t", "0"
            )
        }

        Write-Host "Opening Windows Terminal (switch tabs with Ctrl+Tab or Ctrl+Alt+1/2/3)..." -ForegroundColor Green
        & wt.exe @wtArgs
    }
    else {
        Write-Host "Windows Terminal not found; opening 3 separate console windows..." -ForegroundColor Yellow
        Start-Process cmd -WorkingDirectory $PSScriptRoot -ArgumentList "/k", ($pgCmd -join " ")
        Start-Process cmd -WorkingDirectory $PSScriptRoot -ArgumentList "/k", ($mysqlCmd -join " ")
        Start-Process cmd -WorkingDirectory $PSScriptRoot -ArgumentList "/k", ($sqliteCmd -join " ")
    }
}
finally {
    Pop-Location
}
