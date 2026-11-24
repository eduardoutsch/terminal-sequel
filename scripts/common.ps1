# Shared configuration and Docker Compose helpers for terminal-sequel PowerShell scripts.

$script:RepoRoot = Split-Path -Parent $PSScriptRoot
$script:ComposeFile = Join-Path $script:RepoRoot "docker-compose.yml"

$script:EngineSpecs = @(
    @{
        Key      = "postgres"
        Label    = "PostgreSQL"
        TabColor = "#336791"
        Console  = "Cyan"
        InteractiveCmd = @("docker", "compose", "-f", $script:ComposeFile, "--project-directory", $script:RepoRoot, "exec", "postgres", "psql", "-U", "sql", "-d", "demo")
        BatchCmd       = { docker compose -f $script:ComposeFile --project-directory $script:RepoRoot exec -T postgres psql -U sql -d demo }
    },
    @{
        Key      = "mysql"
        Label    = "MySQL"
        TabColor = "#F29111"
        Console  = "Yellow"
        InteractiveCmd = @("docker", "compose", "-f", $script:ComposeFile, "--project-directory", $script:RepoRoot, "exec", "-e", "MYSQL_PWD=sql", "mysql", "mysql", "-h", "127.0.0.1", "-u", "root", "demo")
        BatchCmd       = { docker compose -f $script:ComposeFile --project-directory $script:RepoRoot exec -T -e MYSQL_PWD=sql mysql mysql -h 127.0.0.1 -u root -t demo }
    },
    @{
        Key      = "sqlite"
        Label    = "SQLite"
        TabColor = "#0F80CC"
        Console  = "Green"
        InteractiveCmd = @("docker", "compose", "-f", $script:ComposeFile, "--project-directory", $script:RepoRoot, "exec", "sqlite", "sqlite3", "/data/demo.db")
        BatchCmd       = { docker compose -f $script:ComposeFile --project-directory $script:RepoRoot exec -T sqlite sqlite3 -header -box /data/demo.db }
    }
)

function Invoke-SequelCompose {
    param([string[]]$ComposeArgs)
    & docker compose -f $script:ComposeFile --project-directory $script:RepoRoot @ComposeArgs
    if ($LASTEXITCODE -ne 0) {
        throw "docker compose $($ComposeArgs -join ' ') failed with exit code $LASTEXITCODE"
    }
}

function Assert-DockerReady {
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        throw "Docker was not found in PATH. Install and start Docker Desktop first."
    }
    docker info *> $null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker daemon is not running. Start Docker Desktop and try again."
    }
}
