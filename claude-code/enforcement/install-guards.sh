#!/usr/bin/env bash
# install-guards.sh — drop the Base Constitution enforcement bundle into a project.
# Run by /interview on scaffold (code context), or by hand:  install-guards.sh [target-dir]
# Idempotent: safe to re-run. Installs:
#   §0.1  gitleaks pre-commit hook + CI workflow (secrets never touch git)
#   §0.4  scripts/guards/backup.sh (backup before mutation)
# (§0.2/0.3 destructive/live-command gating is enforced globally by ~/.claude/hooks/danger-guard.sh.)

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TPL="$HERE/templates"
TARGET="${1:-$PWD}"
TARGET="$(cd "$TARGET" && pwd)"

echo "🔒 Installing constitution guards into: $TARGET"

if [ ! -d "$TARGET/.git" ]; then
  echo "⚠ Not a git repo — skipping git hook + CI. Installing backup.sh only."
  GIT=0
else
  GIT=1
fi

# --- gitleaks availability (advisory; hook degrades gracefully if missing) ---
if command -v gitleaks >/dev/null 2>&1; then
  echo "  ✓ gitleaks $(gitleaks version 2>/dev/null) present"
else
  echo "  ⚠ gitleaks NOT installed — install for local scanning:  brew install gitleaks"
fi

if [ "$GIT" -eq 1 ]; then
  # --- pre-commit hook (respect an existing custom one) ---
  HOOK="$TARGET/.git/hooks/pre-commit"
  if [ -f "$HOOK" ] && ! grep -q 'interview-enforcement-precommit' "$HOOK" 2>/dev/null; then
    echo "  ⚠ Existing pre-commit hook found — not overwriting. Add this line yourself:"
    echo "      gitleaks protect --staged --redact --no-banner || exit 1"
  else
    install -m 0755 "$TPL/pre-commit" "$HOOK"
    echo "  ✓ pre-commit secret-scan hook installed"
  fi

  # --- .gitignore: ensure .env* is ignored BEFORE first commit ---
  GI="$TARGET/.gitignore"
  if ! grep -qE '^\.env' "$GI" 2>/dev/null; then
    printf '\n# secrets (Constitution §0.1)\n.env\n.env.*\n!.env.example\n' >> "$GI"
    echo "  ✓ .env* added to .gitignore"
  fi

  # --- CI workflow ---
  mkdir -p "$TARGET/.github/workflows"
  WF="$TARGET/.github/workflows/gitleaks.yml"
  if [ ! -f "$WF" ]; then
    cp "$TPL/gitleaks.yml" "$WF"
    echo "  ✓ gitleaks CI workflow installed (.github/workflows/gitleaks.yml)"
  else
    echo "  • gitleaks CI workflow already present"
  fi
fi

# --- backup.sh (always) ---
mkdir -p "$TARGET/scripts/guards"
install -m 0755 "$TPL/backup.sh" "$TARGET/scripts/guards/backup.sh"
echo "  ✓ backup-before-mutation script: scripts/guards/backup.sh"

echo "🔒 Done. Wire backup.sh into your migrate command so migrations can't run without a snapshot:"
echo '   "migrate": "./scripts/guards/backup.sh && <your migration command>"'
