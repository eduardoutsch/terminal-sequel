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
. (Join-Path $PSScriptRoot "common.ps1")

Assert-DockerReady

if ($Reset) {
    Write-Host "Resetting database volumes..." -ForegroundColor Yellow
    Invoke-SequelCompose @("down", "-v")
}

Write-Host "Starting PostgreSQL, MySQL, and SQLite containers..." -ForegroundColor Cyan
Invoke-SequelCompose @("up", "-d", "--wait")

if (Get-Command wt.exe -ErrorAction SilentlyContinue) {
    $pg, $mysql, $sqlite = $script:EngineSpecs

    if ($Panes) {
        $wtArgs = @(
            "-w", "sequel-demo",
            "new-tab", "--title", "SQL Engines", "--tabColor", $pg.TabColor, "-d", $script:RepoRoot
        ) + $pg.InteractiveCmd + @(
            ";", "split-pane", "-H", "-d", $script:RepoRoot
        ) + $mysql.InteractiveCmd + @(
            ";", "split-pane", "-V", "-d", $script:RepoRoot
        ) + $sqlite.InteractiveCmd
    }
    else {
        $wtArgs = @("-w", "sequel-demo")
        foreach ($engine in $script:EngineSpecs) {
            if ($wtArgs.Count -gt 2) { $wtArgs += ";" }
            $wtArgs += @("new-tab", "--title", $engine.Label, "--tabColor", $engine.TabColor, "-d", $script:RepoRoot) + $engine.InteractiveCmd
        }
        $wtArgs += @(";", "focus-tab", "-t", "0")
    }

    Write-Host "Opening Windows Terminal (switch tabs with Ctrl+Tab or Ctrl+Alt+1/2/3)..." -ForegroundColor Green
    & wt.exe @wtArgs
}
else {
    Write-Host "Windows Terminal not found; opening 3 separate console windows..." -ForegroundColor Yellow
    foreach ($engine in $script:EngineSpecs) {
        Start-Process cmd -WorkingDirectory $script:RepoRoot -ArgumentList "/k", ($engine.InteractiveCmd -join " ")
    }
}
