# Example output

A trimmed example of what the interview produces for a STANDARD-weight project
("a waitlist page that qualifies buyers for a course launch"). Your real output is longer and
project-specific — this just shows the shape.

---

## constitution.md (excerpt — project layer on top of the base)
```
## Project Non-Negotiables (Tier 0, project)
- 0.P1 No third-party analytics/trackers on the waitlist page. — Why: the audience is
  privacy-sensitive; a tracker would undercut the brand promise.
- 0.P2 Emails are written only to the ESP via server-side API, never logged. — Why: PII.
(inherits the full Base Constitution)
```

## spec.md (excerpt)
```
# Waitlist — Course Launch

## Intent
Qualify buyers (not just collect emails) so launch-day converts. Win = 200 quality signups,
>40% open the launch email.

## User Stories
### US1 — Join the waitlist (P1)
Given a visitor on the landing page, When they submit email + "biggest challenge" + referral source,
Then they're stored in the ESP tagged `waitlist`, and see a confirmation.
Acceptance: a test submission appears in the ESP within 5s with all three fields.

### US2 — Double-submit safety (P1)
Given an existing email, When it's submitted again, Then no duplicate is created (idempotent upsert).

## Out of scope
Payments, accounts, referral rewards (future). 

## Success criteria
200 signups; >40% launch-email open; 0 PII in logs.
```

## tasks.md (excerpt)
```
## P1 — Join the waitlist
- [ ] Form component: email + challenge + referral (client validation)
- [ ] Server route → ESP API (upsert by email, tag `waitlist`)  [idempotent — §1.4]
- [ ] Confirmation state + error states
- [ ] gitleaks guard + .env for ESP key  [§0.1]
## P2 — Polish
- [ ] OG image, semantic markup, a11y pass  [§2.3]
```

---

The constitution rides along the whole build: the agent stops before anything irreversible, won't
commit the ESP key (the pre-commit hook blocks it), and verifies the test submission lands before
calling US1 "done."
