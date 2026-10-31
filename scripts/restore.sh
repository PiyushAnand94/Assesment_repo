#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
POSTGRES_DB="${POSTGRES_DB:-hotel_bookings}"
POSTGRES_USER="${POSTGRES_USER:-hotel_app}"

if [[ $# -lt 1 || $# -gt 2 ]]; then
    printf 'Usage: %s <backup-file> [new-database-name]\n' "$0" >&2
    exit 2
fi

backup_file="$1"
if [[ ! -f "$backup_file" ]]; then
    printf 'Backup file not found: %s\n' "$backup_file" >&2
    exit 1
fi
backup_file="$(cd -- "$(dirname -- "$backup_file")" && pwd)/$(basename -- "$backup_file")"

restore_db="${2:-hotel_bookings_restore}"
if [[ "$restore_db" == "$POSTGRES_DB" ]]; then
    printf 'Refusing to restore over the configured source database: %s\n' "$POSTGRES_DB" >&2
    exit 1
fi

cd "$PROJECT_DIR"
docker compose exec -T db createdb --username="$POSTGRES_USER" -- "$restore_db"
docker compose exec -T db pg_restore \
    --username="$POSTGRES_USER" \
    --dbname="$restore_db" \
    --no-owner \
    --no-privileges < "$backup_file"

printf 'Restored %s into new database %s\n' "$backup_file" "$restore_db"
