#!/usr/bin/env bash
# interview-trigger.sh — tiered auto-trigger for the /interview skill.
# Runs on SessionStart. Detects a net-new / empty project context and injects
# additionalContext instructing Claude to fire the /interview skill (hard trigger).
# Conservative by design: stays silent in $HOME, in already-specced projects, and
# in established repos. Soft suggestion for existing projects is handled by the
# skill's own trigger description, not this hook.

set -euo pipefail

# Read the SessionStart payload (JSON on stdin) to get cwd; fall back to PWD.
payload="$(cat 2>/dev/null || true)"
cwd="$(printf '%s' "$payload" | /usr/bin/python3 -c 'import sys,json
try:
    print(json.load(sys.stdin).get("cwd",""))
except Exception:
    print("")' 2>/dev/null || true)"
[ -z "$cwd" ] && cwd="$PWD"

# --- Guards: never fire in these ---
case "$cwd" in
  "$HOME"|"/"|"$HOME/.claude"*) exit 0 ;;
esac
[ -d "$cwd" ] || exit 0

# Already specced? Then the interview's job is done here — stay silent.
[ -d "$cwd/.specify" ] && exit 0
[ -f "$cwd/spec/spec.md" ] && exit 0
[ -f "$cwd/constitution.md" ] && exit 0

# --- Net-new detection ---
net_new=0

# (a) git repo with zero commits
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  commits="$(git -C "$cwd" rev-list --count --all 2>/dev/null || echo 0)"
  [ "${commits:-0}" -eq 0 ] && net_new=1
fi

# (b) essentially-empty directory (<=3 non-hidden entries)
visible_count="$(ls -1 "$cwd" 2>/dev/null | grep -vc '^\.' || true)"
visible_count="$(printf '%s' "$visible_count" | tr -dc '0-9')"
[ "${visible_count:-0}" -le 3 ] && net_new=1

[ "$net_new" -eq 0 ] && exit 0

# --- Fire: inject context telling Claude to run the interview ---
msg="NET-NEW PROJECT CONTEXT DETECTED at ${cwd}. Invoke the \`interview\` skill now (the deep discovery + spec engine) before doing substantive work here. Greet the user, confirm this is a new project, ask the QUICK/STANDARD/FLAGSHIP weight, and begin the interview. If the user says it is not a new project or declines, drop it and proceed normally."

/usr/bin/python3 -c 'import json,sys
print(json.dumps({"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":sys.argv[1]}}))' "$msg"
exit 0
