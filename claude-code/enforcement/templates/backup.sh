#!/usr/bin/env bash
# Base Constitution §0.4 — BACKUP BEFORE MUTATION.
# Snapshot a Postgres/Supabase database to your backup dir BEFORE running any migration,
# destructive SQL, or schema change. For a solo/small team with live data and no second pair of
# eyes, one bad migration is unrecoverable — this is the precondition, not an option.
# Set BACKUP_DIR to your archive location (an external drive, a backups folder, etc.).
#
# Usage:
#   DATABASE_URL=postgres://...  PROJECT=myapp  ./scripts/guards/backup.sh
#   ./scripts/guards/backup.sh "postgres://..."        # URL as arg
#
# Make your migration command depend on it, e.g. in package.json:
#   "migrate": "./scripts/guards/backup.sh && supabase db push"
# so the migration literally cannot run without a fresh snapshot.

set -euo pipefail

DEST="${BACKUP_DIR:-$HOME/db-backups}"
mkdir -p "$DEST"

DB_URL="${DATABASE_URL:-${1:-}}"
if [ -z "$DB_URL" ]; then
  echo "⛔ No DATABASE_URL. Set the env var or pass the connection string as arg 1."
  exit 1
fi

if ! command -v pg_dump >/dev/null 2>&1; then
  echo "⛔ pg_dump not found. Install it:  brew install libpq && brew link --force libpq"
  echo "   (or use the Supabase CLI: supabase db dump -f backup.sql)"
  exit 1
fi

STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="$DEST/${PROJECT:-db}-${STAMP}.sql.gz"

echo "📦 Backing up → $OUT"
pg_dump "$DB_URL" | gzip > "$OUT"
SIZE="$(du -h "$OUT" | cut -f1)"
echo "✓ Snapshot saved ($SIZE): $OUT"
echo ""
echo "Rollback if the migration goes wrong:"
echo "  gunzip -c '$OUT' | psql \"\$DATABASE_URL\""
