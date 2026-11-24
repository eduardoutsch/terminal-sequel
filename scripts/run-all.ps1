<#
.SYNOPSIS
    Runs the same SQL query or .sql file against PostgreSQL, MySQL, and SQLite.
.EXAMPLE
    .\scripts\run-all.ps1 -Query "SELECT 1 / 2;"
.EXAMPLE
    .\scripts\run-all.ps1 -File .\examples\peculiarities.sql
#>
param(
    [Parameter(ParameterSetName = "Query", Mandatory = $true)]
    [string]$Query,

    [Parameter(ParameterSetName = "File", Mandatory = $true)]
    [string]$File
)

$ErrorActionPreference = "Continue"
. (Join-Path $PSScriptRoot "common.ps1")

$sql = if ($PSCmdlet.ParameterSetName -eq "File") {
    Get-Content -Path (Resolve-Path $File -ErrorAction Stop) -Raw
}
else {
    $Query
}

foreach ($engine in $script:EngineSpecs) {
    Write-Host ""
    Write-Host "==================== $($engine.Label) ====================" -ForegroundColor $engine.Console
    $sql | & $engine.BatchCmd 2>&1 | ForEach-Object { Write-Host $_ }
}
