<#
.SYNOPSIS
    Stops the PostgreSQL, MySQL, and SQLite containers.
.PARAMETER Reset
    Also removes persisted database volumes.
#>
param(
    [switch]$Reset
)

$ErrorActionPreference = "Stop"
Push-Location $PSScriptRoot

try {
    if ($Reset) {
        docker compose down -v
    }
    else {
        docker compose down
    }
}
finally {
    Pop-Location
}
