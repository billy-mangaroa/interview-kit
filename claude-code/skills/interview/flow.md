# Flow: Weight Tiers · Spec Orchestration · Outputs

How the interview's answers become artifacts, and how far the autopilot drives.

---

## Weight tiers (declared in step 0)

| Tier | What it is | Facets | Clarify | Readback gate | Autopilot stops at | Constitution |
|------|-----------|--------|---------|---------------|--------------------|--------------|
| **QUICK** | hack / throwaway / experiment | ★ 5 core | no | no | **implement** (full) | base only |
| **STANDARD** | a real project | ★+◆ ~9 | yes | **yes** | **tasks.md** → stop for go before code | base + project |
| **FLAGSHIP** | revenue / public / client | all 14 + adversarial | yes | **yes** | **spec + plan** → sign-off | base + project, **mandatory** |

Autonomy scales **inversely** with stakes: the heavier the project, the earlier you stop and check.

---

## Code context → GitHub Spec Kit

Install Spec Kit once per repo (https://github.com/github/spec-kit):
```bash
uvx --from git+https://github.com/github/spec-kit specify init . --integration claude
# or install the CLI: uv tool install specify-cli ; specify init . --integration claude
```
This scaffolds `.specify/` and the `/speckit.*` commands. Then run the flow, feeding interview
answers as input to each command (mapping in `facets.md`):
- `/speckit.constitution` → `constitution.md` (base + project don't-dos)
- `/speckit.specify` → `spec.md`
- `/speckit.clarify` → resolve underspecified areas (Standard+)
- `/speckit.plan` → `plan.md` + `data-model.md` + `research.md`
- `/speckit.tasks` → `tasks.md`
- `/speckit.analyze` → consistency check (Flagship)
- `/speckit.implement` → execute (after the tier's stop)

**Install the guards** right after init, before any code:
```bash
/path/to/interview-kit/claude-code/enforcement/install-guards.sh .
```

**Stop at the tier's line.** Don't run `/speckit.implement` on Standard until the user says go;
don't run `/speckit.tasks` onward on Flagship until spec+plan are signed off.

> Spec Kit is optional. If it's unavailable or the context isn't code, use the non-code path below.

---

## Non-code context → templates (no Spec Kit, no git required)

For content pipelines, business processes — anything Spec Kit's CLI can't init:
1. Pick a home: `<project>/spec/`.
2. Create the four artifacts (`constitution.md`, `spec.md`, `plan.md`, `tasks.md`) from this kit's
   templates / the structure above.
3. Translate the vocabulary: "user stories" → workflow steps / process stages; "acceptance
   criteria" → the done-signal for that domain (facet 14). Keep the structure, swap the language.
4. Same weight-tier stops apply — "implement" means "execute the workflow / produce the thing."

---

## The outputs (after artifacts exist)
1. **Spec artifacts** — on disk.
2. **(optional) Knowledge-base ingest** — push the transcript + spec to your notes/knowledge base so
   the project is queryable later.
3. **(optional) Memory note** — a short project note so the context carries across future sessions.
4. **Constitution** — the per-project `constitution.md` governs all future work on the project.

---

## Quality bar
- The brief is the deliverable. If the readback didn't land, keep drilling.
- Surface every assumption pulled from prior context; flag anything possibly stale.
- Never let the autopilot cross a stop line for its tier without an explicit go.
