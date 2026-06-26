---
name: interview
description: "London-ad-agency-depth discovery interview that scaffolds a full spec and runs a spec-driven build flow. Use this to set up ANY new context — a software project, a content pipeline, a business process. MANDATORY TRIGGERS: '/interview', 'interview me', 'set up a new project', 'start a new project/workflow/context', 'spec this out', 'let's scope X', 'kick off X'. PROACTIVE (soft) TRIGGERS — suggest running it, then opt-in: the user is starting something net-new, scaffolding a repo, or says 'I want to build X' with no spec yet. AUTO (hard): an optional SessionStart hook fires this automatically in net-new/empty repos. Do NOT trigger for trivial one-off edits, questions, or work inside an already-specced project."
---

# /interview — Deep Discovery → Spec → Safe Build

You ask one question, you build the wrong thing. Most projects fail at the brief, not the build.
This skill IS the brief — a deep, agency-grade discovery interview that drills every facet of
intent until the goal is bedrock-clear, then turns that clarity into a real spec and runs a
spec-driven build flow as far as the project's weight allows — governed by a safety constitution.

**Supporting files (read them when running):**
- `facets.md` — the 14-facet question taxonomy + per-tier scoping + artifact mapping
- `flow.md` — weight tiers, autopilot stops, spec orchestration, outputs
- `constitution.md` — the base constitution (non-negotiables, each with its `— Why:`), inherited by every project
- `../../enforcement/` — the constitution's "teeth" (gitleaks, danger-guard, backup, branch protection)

This wraps **GitHub's Spec Kit** (https://github.com/github/spec-kit) for code projects; for
non-code contexts it writes the same artifacts from templates. Spec Kit is optional — the interview
and constitution stand alone.

---

## The run, end to end

### 0. Detect context + weight
- Is this a **code** context (a repo, talk of deploys/APIs/payments) or **non-code** (a content
  pipeline, a business process)? This picks the build path (see `flow.md`).
- Ask the framing question: *"How heavy is this — QUICK (hack/throwaway), STANDARD (real project),
  or FLAGSHIP (revenue / public / client-facing)?"* Weight sets depth + autonomy + readback.

### 1. Pre-load what you already know (then confirm, don't re-ask)
Before asking anything, pull existing context (repo files, prior notes, any memory/knowledge base).
Pre-answer every facet you can, surface your assumptions explicitly, and ask the user to confirm or
correct — flag anything that may be stale. An agency that already knows the client doesn't re-ask
the basics; it confirms and goes deeper.

### 2. Interview — hybrid delivery, adaptive drill within the tier
Work the **14 facets in `facets.md`**, scoped to the weight tier. Delivery:

**Ask with the host's native question UI.** For every fork or decision, ask using the structured
question tool of whatever assistant you're running in — and fall back to tight numbered prose when
there isn't one:
- **Claude Code** → the native **`AskUserQuestion`** tool (1–4 multiple-choice questions, single- or
  multi-select, with an "Other" free-text escape hatch).
- **Codex** → Codex's native user-input / approval prompt; if no structured question tool is
  exposed, ask 1–4 concise numbered questions in plain text.
- **Pi** → the built-in **`ask_user`** tool (the `ask-user` extension — pi's `AskUserQuestion`
  equivalent: 1–4 clickable questions, `multiSelect`, `allowOther`).
- **Any other assistant / plain chat** → 1–4 numbered plain-text questions per turn.

Use **conversational prose** (not the picker) when drilling intent/vision/nuance — the structured
tool is for decisions, not the soulful stuff. **Drill rule:**
when an answer is thin on a high-stakes facet, follow up until it has bedrock. Don't accept "to
make it good" — push to *what does good look like, measured how, for whom, by when*. Pace it: move
facet by facet, don't dump all 14 at once.

### 3. Readback gate (Standard + Flagship)
Before scaffolding anything, restate the brief: goal, scope (in AND out), users/people, constraints,
don't-dos, success criteria, and the planned build. Ask *"Is this it?"* Proceed only on confirmation.
A mismatch means more drilling. (QUICK skips this.)

### 4. Scaffold the spec (see `flow.md`)
- `constitution.md` = the base constitution + project-specific don't-dos drilled in the interview.
- `spec.md` (user stories, requirements, acceptance criteria), clarify pass for Standard+.
- `plan.md` (+ data-model / research) for Standard+.
- `tasks.md` for Standard+.
Code context → drive Spec Kit's `/speckit.*` commands. Non-code → write the same files from templates.

### 5. Install the guards, then autopilot to the tier's stop
Run `enforcement/install-guards.sh .` to wire the constitution's teeth into the repo. Then:
- **QUICK** → full autopilot through implement, no readback.
- **STANDARD** → auto through `tasks.md`, then STOP for a go before writing code.
- **FLAGSHIP** → stop at `spec + plan` for sign-off; constitution mandatory.

### 6. Outputs
1. **Spec artifacts** on disk. 2. **(optional) Knowledge-base ingest** of the transcript + spec.
3. **(optional) Memory note** so the context carries forward. 4. **Constitution** governing the project.

---

## Principles
- **The brief is the product of this skill** — not the code. Spend the depth here.
- **Confirm, don't interrogate** — lean on what you already know; spend the saved time drilling deeper.
- **Weight earns autonomy** — heavier stakes → stop and check more; lighter → just build.
- **Every assumption visible** — surface them so stale context gets caught before it poisons the spec.
- **Go one question deeper than feels comfortable.** That's where the real brief lives.
