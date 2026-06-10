# Install Guide

Two tracks. Pick one (or both). The **Chat track** needs nothing but copy-paste. The **Claude Code
track** gives you auto-triggering and real enforcement.

---

## 💬 Chat track (any assistant — 60 seconds)

Works with Claude, ChatGPT, Gemini, or anything that takes a prompt.

1. Open [`chat/interview-prompt.md`](chat/interview-prompt.md).
2. Copy everything inside the code box.
3. Paste it into a **new conversation** and send.
4. Answer the questions it asks. At the end it outputs `constitution.md`, `spec.md`, `plan.md`,
   and `tasks.md` as text — copy them out.

**Make it permanent (optional):** paste the prompt into your assistant's custom-instructions / a
Claude Project / a Custom GPT, so every new chat starts in interview mode.

That's the whole install. The safety constitution is embedded in the prompt and applied throughout —
though in chat it's *advisory* (the assistant follows it; nothing mechanically blocks a bad action).
For mechanical enforcement, use the Claude Code track.

---

## 🤖 Claude Code track

### 1. Install the skill
```bash
git clone https://github.com/<your-org>/interview-kit.git
cp -r interview-kit/claude-code/skills/interview ~/.claude/skills/
```
Now `/interview` works in any project. Try it: open a project and type `/interview`.

### 2. (Recommended) Install GitHub Spec Kit
The skill wraps it for code projects. [Spec Kit](https://github.com/github/spec-kit):
```bash
uv tool install specify-cli          # or use: uvx --from git+https://github.com/github/spec-kit specify ...
```
The interview still works without it (it writes the same artifacts from templates) — Spec Kit just
gives you the real `/speckit.*` commands.

### 3. (Recommended) Wire the enforcement hooks
This is what makes the constitution bite. Edit `~/.claude/settings.json`:

```jsonc
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "/ABSOLUTE/PATH/TO/interview-kit/claude-code/enforcement/danger-guard.sh" }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          { "type": "command", "command": "/ABSOLUTE/PATH/TO/interview-kit/claude-code/hooks/interview-trigger.sh" }
        ]
      }
    ]
  }
}
```
- **`danger-guard.sh`** (PreToolUse/Bash) → forces a confirmation before `rm -rf`, `git push --force`,
  `DROP TABLE`, `--prod` deploys, live keys, etc. — even in dangerous/skip-permissions mode.
- **`interview-trigger.sh`** (SessionStart) → auto-starts the interview in net-new/empty repos.
  *Optional* — skip it if you don't want the auto-prompt; `/interview` still works manually.

Make them executable:
```bash
chmod +x interview-kit/claude-code/enforcement/danger-guard.sh \
         interview-kit/claude-code/hooks/interview-trigger.sh
```

> **Customise `danger-guard.sh`:** add your own irreplaceable paths (a photo/music library, a data
> dir) and any project-specific destructive commands. Patterns are near the bottom of the file.

### 4. Install the secret/backup guards into a project
Run once per repo (the interview does this for you on scaffold):
```bash
interview-kit/claude-code/enforcement/install-guards.sh /path/to/repo
```
Installs a **gitleaks pre-commit hook**, a **gitleaks CI workflow**, `.env*` in `.gitignore`, and a
**`backup.sh`** (DB snapshot before mutation). Requires [`gitleaks`](https://github.com/gitleaks/gitleaks)
(`brew install gitleaks`).

Wire the backup into your migrate command so a migration can't run without a snapshot:
```jsonc
// package.json
"scripts": { "migrate": "./scripts/guards/backup.sh && <your migration command>" }
```

### 5. (Optional) Branch protection
Block force-pushes and branch deletions across your GitHub repos:
```bash
interview-kit/claude-code/enforcement/protect-branches.sh            # dry run — shows the plan
interview-kit/claude-code/enforcement/protect-branches.sh --apply    # enforce
interview-kit/claude-code/enforcement/protect-branches.sh --apply --strict   # also lock out admins
```
Needs [`gh`](https://cli.github.com) authenticated. Note: GitHub Free supports branch protection on
**public** repos only; private repos need GitHub Pro.

### 6. Ratify your constitution
Open [`claude-code/skills/interview/constitution.md`](claude-code/skills/interview/constitution.md),
replace the `<PLACEHOLDER>` items (your escalation channel, jurisdiction, protected paths), and set
the ratify date at the bottom. That's your standing law — every project inherits it.

---

## Requirements summary
| Tool | For | Install |
|------|-----|---------|
| Claude Code | the skill + hooks | [claude.com/claude-code](https://claude.com/claude-code) |
| gitleaks | secret scanning (§0.1) | `brew install gitleaks` |
| gh | branch protection (§1.1) | [cli.github.com](https://cli.github.com) |
| specify-cli | Spec Kit (optional) | `uv tool install specify-cli` |
| pg_dump | DB backups (§0.4) | `brew install libpq` |

Nothing but a browser is needed for the **Chat track**.
