# Enforcement Bundle — the constitution's "teeth"

A principle the agent only *remembers* fails under load. These make the Tier 0 gates mechanical.
**"No hook = decoration."**

## Two layers

### Global (machine-wide, in your Claude Code settings)
- **`danger-guard.sh`** — a `PreToolUse(Bash)` hook. Inspects every command before it runs; on a
  destructive / live-production / protected-path match it forces a confirmation **even in
  skip-permissions mode**. Enforces §0.2, §0.3, §1.9. Wire it in `settings.json` (see `../../INSTALL.md`).
- **`../hooks/interview-trigger.sh`** — optional `SessionStart` hook that auto-starts the interview
  in net-new/empty repos.

### Per-project (run on each repo)
`./install-guards.sh /path/to/repo` installs:
- **gitleaks pre-commit hook** (`templates/pre-commit`) — blocks a commit containing a secret. §0.1
- **`.env*` in `.gitignore`** — before the first commit. §0.1
- **gitleaks CI workflow** (`templates/gitleaks.yml`) — server-side scan; can't be `--no-verify`'d. §0.1
- **`scripts/guards/backup.sh`** (`templates/backup.sh`) — DB snapshot before mutation; wire it into
  your migrate command so a migration can't run without a fresh backup. §0.4

Idempotent; won't clobber an existing custom pre-commit hook.

### Branch protection (GitHub)
`./protect-branches.sh` enables branch protection (force-push + deletion blocked, PR-to-merge) across
your repos. Dry-run by default; `--apply` to enforce, `--strict` to lock out admins too.
Note: GitHub Free allows branch protection on **public** repos only; private repos need GitHub Pro.

## Requirements
- [`gitleaks`](https://github.com/gitleaks/gitleaks) — `brew install gitleaks` (secret scanning)
- [`gh`](https://cli.github.com) — for `protect-branches.sh`
- `pg_dump` — for `backup.sh` on Postgres (`brew install libpq`)

## Customise
- Add your own irreversible commands and protected paths in `danger-guard.sh` (keep patterns tight
  to avoid prompt-noise).
- gitleaks false positives → add the fingerprint to the repo's `.gitleaksignore`.
- `danger-guard.sh` decides `ask`, not `deny`, on purpose — you stay in control; it just guarantees a
  human beat before anything unrecoverable.
