#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ "${1:-}" == "--reset" ]]; then
  docker compose down -v
fi

docker compose up -d --wait

if command -v tmux >/dev/null 2>&1; then
  SESSION="sequel-demo"
  tmux kill-session -t "$SESSION" 2>/dev/null || true
  tmux new-session -d -s "$SESSION" -n "PostgreSQL" "docker compose exec postgres psql -U sql -d demo"
  tmux new-window -t "$SESSION" -n "MySQL" "docker compose exec -e MYSQL_PWD=sql mysql mysql -h 127.0.0.1 -u root demo"
  tmux new-window -t "$SESSION" -n "SQLite" "docker compose exec sqlite sqlite3 /data/demo.db"
  tmux select-window -t "$SESSION:0"
  exec tmux attach-session -t "$SESSION"
else
  echo "Containers are up. Install tmux for tabbed switching, or attach manually:"
  echo "  docker compose exec postgres psql -U sql -d demo"
  echo "  docker compose exec -e MYSQL_PWD=sql mysql mysql -h 127.0.0.1 -u root demo"
  echo "  docker compose exec sqlite sqlite3 /data/demo.db"
fi
