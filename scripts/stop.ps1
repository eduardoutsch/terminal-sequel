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
. (Join-Path $PSScriptRoot "common.ps1")

if ($Reset) {
    Invoke-SequelCompose @("down", "-v")
}
else {
    Invoke-SequelCompose @("down")
}
