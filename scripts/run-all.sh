#!/usr/bin/env bash
set -uo pipefail

cd "$(dirname "$0")/.."

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 \"SELECT 1 / 2;\" | $0 path/to/file.sql"
  exit 1
fi

if [[ -f "$1" ]]; then
  SQL="$(cat "$1")"
else
  SQL="$1"
fi

echo ""
echo "==================== PostgreSQL ===================="
printf "%s\n" "$SQL" | docker compose exec -T postgres psql -U sql -d demo || true

echo ""
echo "==================== MySQL ===================="
printf "%s\n" "$SQL" | docker compose exec -T -e MYSQL_PWD=sql mysql mysql -h 127.0.0.1 -u root -t demo || true

echo ""
echo "==================== SQLite ===================="
printf "%s\n" "$SQL" | docker compose exec -T sqlite sqlite3 -header -box /data/demo.db || true
