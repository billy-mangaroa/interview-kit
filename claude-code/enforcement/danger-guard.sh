#!/usr/bin/env bash
# danger-guard.sh — PreToolUse(Bash) enforcement for Constitution Tier 0 §0.2/0.3 + §1.9.
# Inspects the Bash command the agent is about to run. On a destructive / live-production / protected-path
# match it forces a confirmation prompt ("ask") even in skip-permissions mode — the agent cannot
# silently run it. Decision is "ask" (not "deny") so YOU stay in control; it just guarantees a human
# beat before anything unrecoverable. "No hook = decoration."
#
# INSTALL: wire as a PreToolUse hook (matcher: Bash) in your Claude Code settings.json:
#   "hooks": { "PreToolUse": [ { "matcher": "Bash",
#     "hooks": [ { "type": "command", "command": "/ABSOLUTE/PATH/TO/danger-guard.sh" } ] } ] }
#
# CUSTOMISE: add your own irreversible commands and protected paths in the marked sections below.

set -euo pipefail
payload="$(cat 2>/dev/null || true)"
cmd="$(printf '%s' "$payload" | /usr/bin/python3 -c 'import sys,json
try:
    d=json.load(sys.stdin); print((d.get("tool_input") or {}).get("command","") or "")
except Exception: print("")' 2>/dev/null || true)"
[ -z "$cmd" ] && exit 0
low="$(printf '%s' "$cmd" | tr "[:upper:]" "[:lower:]")"

reason=""
match() { case "$low" in $1) return 0;; *) return 1;; esac; }

# --- §0.2 DESTRUCTIVE / IRREVERSIBLE ---
if   match '*rm -rf*' || match '*rm -fr*' || match '*rm -r -f*';      then reason="recursive force delete (rm -rf)"
elif match '*git push*--force*' || match '*git push -f*' || match '*push --force-with-lease*'; then reason="force push (rewrites remote history)"
elif match '*git reset --hard*';                                       then reason="git reset --hard (discards uncommitted work)"
elif match '*git clean -*f*';                                          then reason="git clean -f (deletes untracked files)"
elif match '*git branch -d*' || match '*push*--delete*' || match '*push origin :*'; then reason="branch deletion"
elif match '*drop table*' || match '*drop database*' || match '*drop schema*'; then reason="SQL DROP (irreversible data loss)"
elif match '*truncate *';                                              then reason="SQL TRUNCATE (irreversible data loss)"
elif match '*delete from *';                                           then reason="SQL DELETE (verify WHERE / backup first)"
elif match '*db reset*' || match '*database reset*';                   then reason="database reset (wipes the database)"
elif match '*migrate reset*' || match '*db push --force*';             then reason="destructive migration"
elif match '*drizzle-kit push*';                                       then reason="schema push (can drop columns)"
elif match '*dd if=*' || match '*mkfs*';                               then reason="disk-level write (dd/mkfs)"
# --- §0.3 LIVE / PRODUCTION ---
elif match '*--prod*' || match '*--production*';                       then reason="production deploy"
elif match '*sk_live_*' || match '*rk_live_*' || match '*_live_*';     then reason="LIVE-mode credential in command"
# --- §1.9 PROTECTED PATHS (customise: add your own irreplaceable dirs) ---
# elif match '*/my-photo-library/*' || match '*important-media*';      then reason="touches a protected path"
fi

if [ -n "$reason" ]; then
  /usr/bin/python3 -c 'import json,sys
print(json.dumps({"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask",
  "permissionDecisionReason":"⛔ Constitution Tier 0 guard: "+sys.argv[1]+". Confirm you intend this, and that a backup/rollback exists (constitution §0.2/0.3/0.4)."}}))' "$reason"
fi
exit 0
