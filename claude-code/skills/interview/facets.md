# The 14-Facet Interview Taxonomy

The definitive discovery framework. Each facet has a **purpose**, **probes** (the questions — drill
past the first answer), and the **spec artifact** it feeds.

**Scoping by weight:**
- **QUICK** → facets ★ only (1, 3, 6, 10, 14) — ~5 core, fast.
- **STANDARD** → facets ★ and ◆ (1–11, 14) — ~9, plus a clarify pass.
- **FLAGSHIP** → all 14, with adversarial drilling (challenge every answer once: "What would make
  that fail?" / "Who'd disagree?" / "What are you assuming?").

---

## 1. ★ Intent & Outcome → `spec.md` (overview, why)
The real job-to-be-done. Why this exists. What changes when it works.
- In one sentence — what is this and who is it for?
- What's the *actual* outcome you want? (Drill past the feature to the result.)
- What does "great" look like — not "done", *great*?
- If this works perfectly, what becomes true that isn't true today? Why now?

## 2. ◆ Context & Background → `spec.md`, `research.md`
What already exists, prior art, the landscape.
- What exists already — earlier attempts, related projects, things to reuse?
- What have you tried that didn't work, and why?
- What's the surrounding system this plugs into? Any references you're drawing from or reacting against?

## 3. ★ Scope & Boundaries → `spec.md` (scope, out-of-scope)
The edges. MVP vs full.
- What's the smallest version that delivers real value (the MVP slice)?
- What's explicitly **out** of scope — now and maybe forever?
- Where does this end and something else begin?

## 4. ◆ Users & People → `spec.md` (user stories, stakeholders)
- Who uses this? What do they want, what do they fear?
- Who else is integrated — collaborators, clients, vendors?
- Who has **decision rights / approval**? Who could block or break this if not consulted?

## 5. ◆ Workflow & Process → `spec.md`, `plan.md`
- Walk me step-by-step through how this works today (even if manual/broken).
- Now the ideal flow — what should the steps be? Where are the handoffs, and where do they break?

## 6. ★ Data & Assets → `data-model.md`, `plan.md`
- What goes in? What comes out?
- Where's the source of truth? What format(s)? Where does it live and move?
- Any data that's sensitive, regulated, or must not leak?

## 7. ◆ Systems & Integrations → `plan.md`, `constitution.md`
- What's the existing stack — what must this use?
- Which APIs / platforms / services does it touch? Where do secrets/credentials live?
- Anything you want to **avoid** building on?

## 8. ◆ Frameworks & Conventions → `constitution.md`, `plan.md`
- Tech / methodology choices already made or preferred?
- Conventions to honor — repo guide files, branch rules, code style, brand voice?
- Any pattern you want enforced everywhere?

## 9. ◆ Constraints & Limitations → `spec.md`, `plan.md`
- Deadline? Hard date or soft?
- Budget — money, and your own time/capacity (often the real bottleneck)?
- Technical limits — platform, performance, free-tier ceilings? Legal/compliance constraints?

## 10. ★ Don't-Dos & Non-Negotiables → `constitution.md` (project layer)
Hard rules. Anti-patterns. Things that must NEVER happen.
- What must this **never** do?
- What's an anti-pattern here — the thing that, if you did it, the user would be upset?
- Any past mistake on a project like this you want guaranteed not to repeat?
(Always inherits the base `constitution.md`.)

## 11. ◆ Efficiency & Leverage → `plan.md`, `tasks.md`
- What's the bottleneck — the thing that, if solved, unlocks the rest?
- What should be automated vs done by hand? What can be reused instead of built fresh?

## 12. Risks & Failure Modes → `spec.md`, analyze (Flagship)
- What's most likely to go wrong? How would you know — what's the signal?
- What's the fallback / rollback? What's the worst-case blast radius?

## 13. Future Vision & Roadmap → `spec.md`, `plan.md` (Flagship)
- Where's this in 6 months? A year? What are the phases after the first cut?
- What's the 10x version you're not building yet but want the door left open for?

## 14. ★ Success Metrics & Validation → `spec.md` (acceptance criteria)
- How will you *know* it worked? What's the number or the observable?
- What's the acceptance test — the concrete thing you should be able to demonstrate?
- What would make you say "no, not yet"?

---

## Mapping summary (facets → artifacts)
- **`constitution.md`** ← 8, 10 (+ base constitution)
- **`spec.md`** ← 1, 2, 3, 4, 5, 9, 12, 13, 14
- **`plan.md` / `data-model.md` / `research.md`** ← 2, 5, 6, 7, 8, 9, 11
- **`tasks.md`** ← 5, 11 (priority/sequence)
- **Readback** synthesizes 1, 3, 4, 9, 10, 14 (goal · scope · people · constraints · don't-dos · success).
