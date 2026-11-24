# terminal-sequel

Three-engine SQL playground (**PostgreSQL**, **MySQL**, and **SQLite**) in tabbed terminals, inspired by CMU 15-445 (*Intro to Database Systems* — Lecture #02 Modern SQL).

Run the exact same SQL across all three engines and observe their dialect, typing, and execution peculiarities side by side.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (running)
- [Windows Terminal](https://aka.ms/terminal) (`wt.exe`, included on Windows 11) — or `tmux` on Linux/macOS

## Quick Start

From the `terminal/` directory in PowerShell:

```powershell
.\start.ps1
```

This starts the `postgres`, `mysql`, and `sqlite` containers (waiting until all three are healthy) and opens a single Windows Terminal window with three color-coded tabs:

- **PostgreSQL** (`psql` connected to `demo`)
- **MySQL** (`mysql` connected to `demo`)
- **SQLite** (`sqlite3` connected to `/data/demo.db`)

### Switching Tabs Seamlessly

- `Ctrl+Tab` / `Ctrl+Shift+Tab`: cycle through PostgreSQL → MySQL → SQLite
- `Ctrl+Alt+1` / `Ctrl+Alt+2` / `Ctrl+Alt+3`: jump directly to a specific engine

> Prefer 3 split panes in one view instead of tabs? Run `.\start.ps1 -Panes`.

### Run the Same Query on All 3 Engines at Once

```powershell
.\run-all.ps1 -Query "SELECT 1 / 2;"
.\run-all.ps1 -Query "SELECT 'hello ' || 'world';"
.\run-all.ps1 -File .\examples\peculiarities.sql
```

### Reset / Stop

```powershell
.\start.ps1 -Reset   # Wipe volumes and re-seed from ./init/*.sql
.\stop.ps1           # Stop containers (keep data)
.\stop.ps1 -Reset    # Stop containers and remove volumes
```

## Pre-loaded Sample Schema

All three engines are initialized with the same `student`, `course`, and `enrolled` tables from [`init/`](./init):

- `student(sid, name, login, age, gpa)` — 5 rows (including a `NULL` `gpa`)
- `course(cid, name)` — 3 rows
- `enrolled(sid, cid, grade)` — 6 rows (including a `NULL` `grade`)

See [`examples/peculiarities.sql`](./examples/peculiarities.sql) for ready-to-run queries highlighting differences in integer division, `||` concatenation, double quotes, `GROUP BY`, `NULL` sorting, `LIKE` case-sensitivity, and SQLite's flexible typing.

## Linux / macOS (`tmux`)

```bash
./start.sh
./run-all.sh "SELECT 1 / 2;"
```
