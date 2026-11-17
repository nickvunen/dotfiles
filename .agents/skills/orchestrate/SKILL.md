---
name: orchestrate
description: Orchestrator Mode. Understand the request first (one batch of clarifying questions only when answers change the outcome), then own the task end to end — plan, implement, test, review, PR, merge, release preparation — with maximum autonomy and a hard approval boundary at production. Use when the user says "orchestrator mode" or "orchestrate", or invokes /orchestrate or $orchestrate.
---

# Orchestrator Mode

Two phases: **understand**, then **deliver autonomously**. The only planned
interruptions are the discovery batch and a production approval.

## 0. Load the project's rules

Read the project's `AGENTS.md` / `CLAUDE.md` and its **Orchestrator mode**
section if it has one: that names what counts as production, the verification
commands and the branch/commit conventions. Without one, find out before
shipping anything: check what a push to the default branch triggers (GitHub
deployments, `vercel.json`/Netlify/Fly configs, workflows `on: push`), which
databases are hosted, and which store tracks exist. **Unknown means
production.**

## 1. Discovery (before any plan)

- Inspect the request, code, docs and history. Never ask what the repo answers.
- List ambiguities, missing acceptance criteria, dependencies and conflicts
  with existing behaviour or project rules.
- Ask only questions whose answer would change the result — behaviour, UX,
  scope, significant technical choices. **One grouped batch**, each with a
  recommended option and the trade-off in one line. Add improvements, edge
  cases or better approaches the user may have missed.
- Requirements already clear: skip questions, say so in one line.
- Never invent requirements where real ambiguity remains; never read silence
  as an answer.

## 2. Acceptance criteria and plan

After answers: state acceptance criteria (testable bullets) and a plan of a
few lines. Do not wait for approval of the plan — it is the record, not a gate.

## 3. Deliver autonomously

- Work on a branch in an isolated worktree when other sessions may share the
  checkout; follow the project's branch and commit naming.
- Make routine decisions yourself, per project conventions. Do not ask for
  confirmations after discovery.
- Loop until done: implement, run the project's checks (tests, lint, types,
  format, build — the full required set, not a sample), investigate failures,
  fix, re-run. Retry flakes once with a reason; never weaken or skip a test to
  go green.
- Review significant changes independently before integrating: a fresh-context
  pass over the diff (Claude: `/code-review` or a reviewer subagent; Codex:
  `/review`), then fix what holds up and re-verify.
- Commit, push the branch, open a PR, wait for the required checks.
- Merge only when every mandatory condition passes **and** the merge target is
  not production (see §6). Update the project's status docs if it keeps them.
- Prepare releases: version, notes, builds, nonproduction deploys and testing
  tracks are autonomous.
- Never bypass checks or protections: no `--no-verify`, no force-push or
  admin-merge to a protected or default branch, no disabled checks.
- Genuinely blocked (missing credential, decision only the user can make,
  external outage): finish everything not blocked, then ask everything in one
  message.

## 4. Large tasks: several PRs

- Split into small PRs that each do one reviewable thing, carry their own
  acceptance criteria and pass every check alone. A trivial change rides
  along with the slice it belongs to rather than getting its own PR.
- In the plan: the slices, their dependencies and the merge order. Dependent
  slices are stacked PRs; independent ones run in parallel worktrees or
  subagents.
- Where `main` is production, target an integration branch (`<feature>`):
  merge each slice there autonomously once green and reviewed, rebase the
  stack after each merge, and resolve conflicts and integration failures
  yourself when the intent of both sides is clear. One release approval for
  the final `<feature>` → `main` PR. Where `main` is not production, merge
  slices to it directly in order.
- Do not stop after the first PR: keep going until every slice is merged and
  the overall acceptance criteria pass on the integrated result.

## 5. Spend tokens like money

- One capable agent by default. Spawn a subagent only for real parallel work
  or to keep a large read out of context; give it a self-contained brief and
  ask for a short result. Use a cheaper model (Claude: `haiku`/`sonnet`) for
  search, mechanical edits and first-pass review.
- Prefer scripts, existing npm/make targets and CI over agent reasoning.
- Read the parts of files you need; do not re-derive settled facts.
- Plans, handoffs and reports: short.

## 6. Production approval (hard boundary)

Needs explicit approval **for that specific release**, every time:

- deploying to production, including any merge or push that auto-deploys it;
- publishing to App Store / Google Play production or review tracks;
- hosted production database migrations, config pushes or writes;
- destructive or irreversible operations on hosted systems, data or accounts.

Ask once, in this shape:

```
Release approval: <version / commit> → <target environment>
Changes: <3–6 bullets>
Verified: <checks run + results, review outcome>
Risks: <known risks or "none known">
Rollback: <how to undo or recover>
Approve this release? (yes / no)
```

Only an explicit yes for that release counts; it does not carry to the next
one. After a yes: execute the release, verify it (deployment status, smoke
check, store/console state), report the outcome. A failed verification is
reported with the rollback, not silently retried into production.

## 7. Final report

Short: what shipped (links: PR, deploy, build), checks and review results,
anything skipped and why, open blockers, and any pending approval.
