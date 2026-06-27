#!/usr/bin/env bash
# One-shot: deploy buildwithbilly.ai/interview to production.
# Run on a machine with `vercel` + `gh`/git auth (Billy's Mac). Safe to re-run.
# Blocked until Vercel's free-plan 100-deploys/24h cap resets (~2026-06-12).
#
# What it deploys: branch `add-interview-page` of billy-mangaroa/business (PR #4) — adds
# buildwithbilly/landing-page/public/interview.html + a next.config rewrite /interview -> /interview.html.
# Vercel prod deploys are atomic: a failed build leaves the live site untouched.
set -euo pipefail

WORK="$(mktemp -d)"
echo "▸ cloning business → $WORK"
git clone -q https://github.com/billy-mangaroa/business.git "$WORK/business"
cd "$WORK/business"
git checkout -q add-interview-page    # the PR #4 branch with the change

echo "▸ linking to Vercel project 'buildwithbilly'"
vercel link --yes --project buildwithbilly >/dev/null

echo "▸ deploying to production (atomic — live stays up if this fails)"
vercel --prod

echo "▸ verifying https://buildwithbilly.ai/interview"
sleep 5
code="$(curl -s -o /dev/null -w '%{http_code}' https://buildwithbilly.ai/interview)"
if [ "$code" = "200" ] && curl -s https://buildwithbilly.ai/interview | grep -q "Interview yourself before you build"; then
  echo "✅ LIVE: https://buildwithbilly.ai/interview ($code)"
else
  echo "⚠ got HTTP $code — check the deploy. (If 'too many deployments', the daily cap hasn't reset yet.)"
fi
rm -rf "$WORK"
