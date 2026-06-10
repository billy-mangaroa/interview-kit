# Interview Kit

**Interview yourself before you build.**

Most projects don't fail in the build. They fail in the brief — the moment you started coding
something you hadn't fully thought through. Interview Kit fixes that. It runs a deep,
London-ad-agency-depth discovery interview that drills every facet of what you're about to build,
turns your answers into a complete spec (constitution · spec · plan · tasks), and then — if you want
— governs the build with a safety constitution that stops your AI agent from doing anything
catastrophic.

It works two ways:

- 🤖 **Claude Code track** — a full skill: auto-starts on new projects, runs the interview, scaffolds
  the spec (wrapping [GitHub Spec Kit](https://github.com/github/spec-kit)), and installs real
  enforcement (secret-scanning, destructive-command guards, backup-before-migrate, branch protection).
- 💬 **Chat track** — a single copy-paste prompt for **any** assistant (Claude, ChatGPT, Gemini). No
  install. You answer the questions, you get the spec out as text.

Free. MIT-licensed. Use it on a weekend hack or a client flagship.

---

## Why it exists

> You ask one question, you build the wrong thing.

An interview that goes one question deeper than feels comfortable is where the real brief lives. A
senior agency lead doesn't take a brief at face value — they drill *"and what does that actually
mean?"* until there's nothing left to abstract. Interview Kit makes your AI do that, then writes the
spec, then keeps the build safe.

## What you get

1. **A real interview** — 14 facets (intent, scope, users, data, systems, constraints, don't-dos,
   risks, future, success metrics…), scaled to the project's weight, with an explicit *readback* gate
   so nothing gets built until you confirm "yes, that's it."
2. **A complete spec** — `constitution.md`, `spec.md`, `plan.md`, `tasks.md`. Paste them into a repo,
   hand them to a coding agent, or keep them as your source of truth.
3. **A safety constitution** — a tiered control system (Inviolable → Defaults → Preferences) that
   makes irreversible harm hard. Every rule carries its **— Why:**, so you can question it mid-build.
4. **(Claude Code) Enforcement that actually bites** — hooks and CI so "never commit a secret" and
   "never `DROP TABLE` without a backup" aren't hopes, they're gates.

## 60-second start

**Chat:** open [`chat/interview-prompt.md`](chat/interview-prompt.md), copy the prompt, paste it into
your assistant, and answer. Done.

**Claude Code:**
```bash
git clone https://github.com/billy-mangaroa/interview-kit.git
cp -r interview-kit/claude-code/skills/interview ~/.claude/skills/
# then in any project:  /interview
```
Full setup (auto-trigger, hooks, branch protection) → [`INSTALL.md`](INSTALL.md).

## The three weights

| Weight | For | Depth | Autopilot stops at |
|--------|-----|-------|--------------------|
| **QUICK** | a hack / throwaway | 5 core facets | builds all the way |
| **STANDARD** | a real project | 9 facets + readback | the task list — you say go |
| **FLAGSHIP** | revenue / public / client | all 14 + adversarial | spec + plan — you sign off |

Autonomy scales *inversely* with stakes: the more it matters, the more it stops and checks.

## Docs
- [`INSTALL.md`](INSTALL.md) — full install, both tracks
- [`USAGE.md`](USAGE.md) — how to run an interview, use cases, worked example
- [`claude-code/skills/interview/`](claude-code/skills/interview/) — the skill + the 14-facet taxonomy + the constitution
- [`claude-code/enforcement/`](claude-code/enforcement/) — the guards
- [`chat/interview-prompt.md`](chat/interview-prompt.md) — the paste-in prompt

## Credits
Wraps [GitHub Spec Kit](https://github.com/github/spec-kit) for spec-driven development. The
constitution was hardened against real failure modes (committed secrets, destructive migrations,
runaway costs, prompt injection, the offline-operator problem).

Built by [Build With Billy](https://buildwithbilly.ai). Share it freely.

## License
MIT — see [`LICENSE`](LICENSE).
