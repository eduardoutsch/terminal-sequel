<#
.SYNOPSIS
    Runs the same SQL query or .sql file against PostgreSQL, MySQL, and SQLite.
.EXAMPLE
    .\run-all.ps1 -Query "SELECT 1 / 2;"
.EXAMPLE
    .\run-all.ps1 -File .\examples\peculiarities.sql
#>
param(
    [Parameter(ParameterSetName = "Query", Mandatory = $true)]
    [string]$Query,

    [Parameter(ParameterSetName = "File", Mandatory = $true)]
    [string]$File
)

$ErrorActionPreference = "Continue"

if ($PSCmdlet.ParameterSetName -eq "File") {
    $resolved = Resolve-Path $File -ErrorAction Stop
    $sql = Get-Content -Path $resolved -Raw
}
else {
    $sql = $Query
}

Push-Location $PSScriptRoot

function Invoke-Engine {
    param(
        [string]$Label,
        [string]$Color,
        [scriptblock]$Command
    )

    Write-Host ""
    Write-Host "==================== $Label ====================" -ForegroundColor $Color
    $sql | & $Command 2>&1 | ForEach-Object { Write-Host $_ }
}

try {
    Invoke-Engine -Label "PostgreSQL" -Color "Cyan" -Command {
        docker compose exec -T postgres psql -U sql -d demo
    }

    Invoke-Engine -Label "MySQL" -Color "Yellow" -Command {
        docker compose exec -T -e MYSQL_PWD=sql mysql mysql -h 127.0.0.1 -u root -t demo
    }

    Invoke-Engine -Label "SQLite" -Color "Green" -Command {
        docker compose exec -T sqlite sqlite3 -header -box /data/demo.db
    }
}
finally {
    Pop-Location
}
