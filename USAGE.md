# Usage Guide

## The core loop

```
detect context + weight → pre-load what's known → interview (14 facets) →
readback ("is this it?") → scaffold spec → install guards → autopilot to the tier's stop
```

You don't drive it question-by-question — you start it, and it interviews *you*.

- **Claude Code:** type `/interview` (or just start a brand-new project — it offers to begin).
- **Chat:** paste [`chat/interview-prompt.md`](chat/interview-prompt.md) and answer.

The first thing it asks: **what are you building, and how heavy is it?**

| Weight | Pick it when… | What happens |
|--------|---------------|--------------|
| **QUICK** | it's a throwaway / experiment | 5 core questions, then it just builds |
| **STANDARD** | it's a real project you'll keep | ~9 questions + a clarify pass, reads the brief back to you, builds the task list, stops for your go |
| **FLAGSHIP** | money / public / a client is involved | all 14 questions, challenges your answers, stops at spec+plan for sign-off |

---

## Use cases

**1. Starting a new app/feature.** Run `/interview` in the empty repo. You come out with a spec, a
task list, and the guards installed — and you've been forced to answer "what does done look like,
measured how?" before writing a line.

**2. Rescuing a vague idea.** You have a fuzzy "I want to build X." The interview turns the fog into
scope, non-goals, risks, and a first slice. The *readback* is where you realise what you actually meant.

**3. Briefing another AI (or a contractor).** Run the chat prompt, get the four documents, and hand
them over: "build this, follow the constitution." No more lossy back-and-forth.

**4. A non-code process.** A content pipeline, an onboarding flow, an ops runbook. Same interview;
"user stories" become workflow steps, "acceptance criteria" become the done-signal. You get a spec
for a *process*.

**5. Hardening how your AI works.** Even without an interview, adopt the **constitution** +
**enforcement** on their own: secret-scanning, destructive-command confirmation, backup-before-migrate,
branch protection. That alone prevents the most common solo-dev disasters.

---

## The 14 facets (what it drills)

1. Intent & Outcome · 2. Context & Background · 3. Scope & Boundaries · 4. Users & People ·
5. Workflow & Process · 6. Data & Assets · 7. Systems & Integrations · 8. Frameworks & Conventions ·
9. Constraints & Limitations · 10. Don't-Dos & Non-Negotiables · 11. Efficiency & Leverage ·
12. Risks & Failure Modes · 13. Future Vision & Roadmap · 14. Success Metrics & Validation.

Full taxonomy with every probe: [`claude-code/skills/interview/facets.md`](claude-code/skills/interview/facets.md).

---

## Worked example (abridged)

> **You:** /interview
> **It:** One line — what are you building and who for? Code or non-code? QUICK / STANDARD / FLAGSHIP?
> **You:** A waitlist page for my course launch. Code. STANDARD.
> **It:** Got it. Intent first — what's the *outcome*? Is the win "collect emails," or "qualify buyers
> so launch-day converts"? Those build differently…
> *(…drills scope, users, data destination, the one integration, the don't-dos…)*
> **It:** Readback — Goal: a waitlist that qualifies, not just collects. In scope: email + one
> qualifying question, stored in your ESP. Out: payments, accounts. Success: 200 quality signups,
> >40% open the launch email. Don't-do: no third-party trackers. **Is this it?**
> **You:** Yes — but also add a referral field.
> **It:** Noted. Scaffolding spec.md, plan.md, tasks.md + installing guards. Here's the task list —
> say go and I'll build P1.

---

## How the constitution shows up

While building, the agent operates under the constitution
([`constitution.md`](claude-code/skills/interview/constitution.md)). You'll see it:
- **stop and ask** before anything irreversible or production-money,
- **refuse to bury a secret** in a commit (the gitleaks hook blocks it),
- **state a rollback** before a live change,
- and **explain the *why*** if you challenge a rule — every rule carries its reason so you can overrule
  it deliberately, not blindly.

That's the whole point: develop better *from the start*, with the guardrails on.
