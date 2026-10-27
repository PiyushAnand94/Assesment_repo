#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
BACKUP_DIR="$PROJECT_DIR/backups"
POSTGRES_DB="${POSTGRES_DB:-hotel_bookings}"
POSTGRES_USER="${POSTGRES_USER:-hotel_app}"
timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
backup_file="$BACKUP_DIR/${POSTGRES_DB}_${timestamp}.dump"
temporary_file="${backup_file}.tmp.$$"

mkdir -p "$BACKUP_DIR"
if [[ -e "$backup_file" ]]; then
    printf 'Backup already exists: %s\n' "$backup_file" >&2
    exit 1
fi

trap 'rm -f -- "$temporary_file"' EXIT

cd "$PROJECT_DIR"
docker compose exec -T db pg_dump \
    --username="$POSTGRES_USER" \
    --dbname="$POSTGRES_DB" \
    --format=custom > "$temporary_file"
mv -- "$temporary_file" "$backup_file"
trap - EXIT

printf 'Backup created: %s\n' "$backup_file"
