#!/usr/bin/env bash
# protect-branches.sh — Base Constitution §1.1 (branch before you build), server-side.
# Enables GitHub branch protection on the default branch of your repos so force-pushes and
# branch deletions are blocked for EVERYONE (including the agent), and merges go through a PR.
#
# The council's point: a rule the agent only "remembers" fails; branch protection is enforced
# by GitHub, not by the agent's goodwill.
#
# DEFAULTS are solo-operator-friendly:
#   • force-push BLOCKED, deletion BLOCKED, conversation-resolution required  (everyone)
#   • a PR is required to merge, with 0 required approvals  (so solo-you can self-merge)
#   • enforce_admins = OFF  → you (admin) can still hotfix directly in an emergency
# Pass --strict to set enforce_admins = ON (then even the agent literally cannot push to main).
#
# Usage:
#   protect-branches.sh                      # DRY RUN over all your source repos (shows the plan)
#   protect-branches.sh --apply              # apply to all source repos
#   protect-branches.sh --apply repo1 repo2  # apply to specific repos (name or owner/name)
#   protect-branches.sh --apply --strict     # also lock out admins (agent-proof)
#   Flags: --owner X  --reviews N  --include-forks  --include-archived  --require-check NAME
set -euo pipefail

APPLY=0; STRICT=0; REVIEWS=0; INC_FORKS=0; INC_ARCH=0; OWNER=""; REQ_CHECK=""
REPOS=()
while [ $# -gt 0 ]; do
  case "$1" in
    --apply) APPLY=1;;
    --strict) STRICT=1;;
    --reviews) REVIEWS="$2"; shift;;
    --owner) OWNER="$2"; shift;;
    --require-check) REQ_CHECK="$2"; shift;;
    --include-forks) INC_FORKS=1;;
    --include-archived) INC_ARCH=1;;
    -h|--help) sed -n '2,24p' "$0"; exit 0;;
    -*) echo "unknown flag: $1"; exit 1;;
    *) REPOS+=("$1");;
  esac
  shift
done

command -v gh >/dev/null || { echo "⛔ gh CLI not found. brew install gh"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "⛔ gh not authenticated. Run: gh auth login"; exit 1; }
[ -z "$OWNER" ] && OWNER="$(gh api user --jq .login)"

ENFORCE_ADMINS=$([ "$STRICT" -eq 1 ] && echo true || echo false)

# required_status_checks: null unless a check name was named (avoid blocking merges on a check that never runs)
if [ -n "$REQ_CHECK" ]; then
  RSC="{\"strict\":true,\"contexts\":[\"$REQ_CHECK\"]}"
else
  RSC="null"
fi

payload() {  # $1 = nothing; emits the protection JSON
cat <<JSON
{
  "required_status_checks": $RSC,
  "enforce_admins": $ENFORCE_ADMINS,
  "required_pull_request_reviews": { "required_approving_review_count": $REVIEWS, "dismiss_stale_reviews": true },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_conversation_resolution": true,
  "required_linear_history": false
}
JSON
}

# Build the repo list (owner/name + default branch).
echo "🔎 Resolving repos for owner: $OWNER"
GHFLAGS=(--limit 300 --json nameWithOwner,defaultBranchRef,isFork,isArchived)
[ "$INC_FORKS" -eq 0 ] && GHFLAGS+=(--source)
[ "$INC_ARCH" -eq 0 ] && GHFLAGS+=(--no-archived)

if [ "${#REPOS[@]}" -gt 0 ]; then
  LIST_JSON="[]"
  for r in "${REPOS[@]}"; do
    case "$r" in */*) full="$r";; *) full="$OWNER/$r";; esac
    db="$(gh api "repos/$full" --jq .default_branch 2>/dev/null || echo "")"
    [ -z "$db" ] && { echo "  ⚠ $full — not found / no access, skipping"; continue; }
    LIST_JSON="$(printf '%s' "$LIST_JSON" | /usr/bin/python3 -c "import json,sys;a=json.load(sys.stdin);a.append({'nameWithOwner':'$full','branch':'$db'});print(json.dumps(a))")"
  done
else
  LIST_JSON="$(gh repo list "$OWNER" "${GHFLAGS[@]}" | /usr/bin/python3 -c 'import json,sys
a=json.load(sys.stdin);out=[]
for r in a:
    b=(r.get("defaultBranchRef") or {}).get("name")
    if b: out.append({"nameWithOwner":r["nameWithOwner"],"branch":b})
print(json.dumps(out))')"
fi

COUNT="$(printf '%s' "$LIST_JSON" | /usr/bin/python3 -c 'import json,sys;print(len(json.load(sys.stdin)))')"
echo "📋 $COUNT repo(s). Settings: enforce_admins=$ENFORCE_ADMINS  reviews=$REVIEWS  force_push=BLOCKED  deletion=BLOCKED  required_check=${REQ_CHECK:-none}"
[ "$APPLY" -eq 0 ] && echo "🟡 DRY RUN — no changes. Re-run with --apply to enforce." || echo "🔴 APPLYING protection..."
echo ""

OK=0; FAIL=0
while IFS=$'\t' read -r full branch; do
  [ -z "$full" ] && continue
  if [ "$APPLY" -eq 0 ]; then
    echo "  • would protect $full ($branch)"
    continue
  fi
  if payload | gh api --method PUT "repos/$full/branches/$branch/protection" \
        -H "Accept: application/vnd.github+json" --input - >/dev/null 2>/tmp/protect_err; then
    echo "  ✓ $full ($branch) protected"
    OK=$((OK+1))
  else
    echo "  ✗ $full ($branch) FAILED: $(tr -d '\n' < /tmp/protect_err | cut -c1-160)"
    FAIL=$((FAIL+1))
  fi
done < <(printf '%s' "$LIST_JSON" | /usr/bin/python3 -c 'import json,sys
for r in json.load(sys.stdin): print(r["nameWithOwner"]+"\t"+r["branch"])')

echo ""
[ "$APPLY" -eq 1 ] && echo "Done. Protected: $OK   Failed: $FAIL" || echo "Dry run complete. Add --apply to enforce."
