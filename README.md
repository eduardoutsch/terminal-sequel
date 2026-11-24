# terminal-sequel

Three-engine SQL playground (**PostgreSQL**, **MySQL**, and **SQLite**) in tabbed terminals, inspired by CMU 15-445 (*Intro to Database Systems* — Lecture #02 Modern SQL).

Run the exact same SQL across all three engines and observe their dialect, typing, and execution peculiarities side by side.

## Structure

```text
terminal-sequel/
├── setup.bat             # One-click Windows launcher (auto-installs prerequisites)
├── docker-compose.yml    # PostgreSQL 17, MySQL 8.4, and SQLite 3 containers
├── scripts/
│   ├── common.ps1        # Shared Docker Compose & engine definitions
│   ├── start.ps1         # Opens 3-tab Windows Terminal (or cmd fallback)
│   ├── stop.ps1          # Stops containers (add -Reset to wipe volumes)
│   ├── run-all.ps1       # Runs a query or .sql file against all 3 engines
│   ├── start.sh          # Linux / macOS tmux launcher
│   └── run-all.sh        # Linux / macOS cross-engine runner
├── init/                 # Shared student, course, and enrolled seed SQL
└── examples/             # SQLite vs MySQL vs PostgreSQL peculiarity queries
```

## Quick Start (Windows)

Double-click **`setup.bat`** (or run it from Command Prompt / PowerShell):

```bat
setup.bat
```

`setup.bat` installs Docker Desktop and Windows Terminal via `winget` if missing, starts Docker Desktop, and runs [`scripts/start.ps1`](./scripts/start.ps1).

### Switching Tabs Seamlessly

- `Ctrl+Tab` / `Ctrl+Shift+Tab`: cycle through PostgreSQL → MySQL → SQLite
- `Ctrl+Alt+1` / `Ctrl+Alt+2` / `Ctrl+Alt+3`: jump directly to a specific engine

> Prefer 3 split panes in one view instead of tabs? Run `.\scripts\start.ps1 -Panes`.

### Run the Same Query on All 3 Engines at Once

```powershell
.\scripts\run-all.ps1 -Query "SELECT 1 / 2;"
.\scripts\run-all.ps1 -Query "SELECT 'hello ' || 'world';"
.\scripts\run-all.ps1 -File .\examples\peculiarities.sql
```

### Reset / Stop

```powershell
.\scripts\start.ps1 -Reset   # Wipe volumes and re-seed from ./init/*.sql
.\scripts\stop.ps1           # Stop containers (keep data)
.\scripts\stop.ps1 -Reset    # Stop containers and remove volumes
```

## Linux / macOS (`tmux`)

```bash
./scripts/start.sh
./scripts/run-all.sh "SELECT 1 / 2;"
```
