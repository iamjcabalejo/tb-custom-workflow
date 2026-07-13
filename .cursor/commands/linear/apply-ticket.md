---
description: Fetch a Linear issue (read-only), plan from the ticket, then run Plan → Code → Review/Test via backend/frontend agents. Does not mutate Linear.
---

You are the **linear/apply-ticket** orchestrator. Fetch **one Linear issue**, turn it into a repo plan, then execute the **compounding development cycle** per **`.cursor/rules/compounding-dev-cycle.mdc`**, **`.cursor/rules/token-policy.mdc`**, **`.cursor/skills/project-manager/SKILL.md`**, and **`.cursor/skills/agent-selection/SKILL.md`**.

**Scope:** Read ticket → plan → implement → review. **Forbidden:** any write to Linear (no `save_issue`, `save_comment`, status/label/assignee changes, or other mutation tools). **Allowed:** repo plan files, application code, tests, rework plans under `docs/plans/`.

## Ticket ID (mandatory)

**Arguments:** `$ARGUMENTS`

- A **single** Linear issue identifier (team key + number, e.g. `TB-42`, or UUID if pasted).
- If **empty** or not plausible: do **not** call MCP with a guess. Ask once: *"Provide the Linear ticket id (e.g. TB-123)."*

## Linear MCP — read only (mandatory)

Use the **Linear** MCP; do not invent ticket content from memory.

1. **Before the first MCP call:** read tool descriptor(s) under the workspace MCP folder (e.g. `mcps/plugin-linear-linear/tools/<tool>.json`).
2. **Allowed calls only:** `get_issue`, `list_comments`, and other **read** tools required to load context. Set `includeRelations`: **true** on `get_issue`. Set `includeCustomerNeeds`: **true** when supported.
3. **Forbidden MCP calls:** `save_issue`, `save_comment`, `update_*`, or any tool that creates or mutates issues, comments, labels, status, assignees, or attachments.
4. If **`get_issue`** fails: stop, report the error, ask once for a valid id/key.

### Required fetch (in order)

1. **`get_issue`** — `id` from arguments.
2. **`list_comments`** — `issueId`: same identifier; paginate if needed so substantive comments are not missed.

## Token policy (mandatory)

Apply **`.cursor/rules/token-policy.mdc`** Session entry flow before planning or delegating:

1. **Ingest** title, description, relations, comments.
2. **Refine** into: one **objective**; **in / out of scope**; **constraints** and **forbidden**; numbered **acceptance criteria** (AC-1, AC-2, …); **assumptions** only when the ticket is thin but unblocking.
3. For **complex or ambiguous** tickets, add a short **internal XML blueprint** in the plan doc (per token-policy). Skip XML for trivial one-line tickets.
4. **Hand off** to subagents with **prompt-shaped** briefs—scope, AC, task blocks—not raw ticket dumps.

**Chat:** concise, no filler. Match effort to ticket size.

## Phase 0: ASK (only when blocked)

**Mode:** ASK.

If **blocking** information is missing (no success criteria, conflicting comments, unknown repro for a bug, unclear system boundary):

- Do **not** mutate Linear. Output **3–6 numbered questions** or **suggested options**.
- You may output a **draft plan outline** with an **Open questions** section.
- **Stop** before Code until the user answers or explicitly says to proceed with labeled **Assumptions**.

If only **mildly** thin, add a short **Assumptions** subsection in the plan and continue.

## Phase 1: PLAN — author repo plan

**Mode:** PLAN. No application code yet.

1. Derive **feature slug**: lowercase, hyphenated, prefixed with ticket key when helpful (e.g. `tb-42-user-profile-export`). Plan path: **`docs/plans/<feature-slug>.md`**.
2. Write the plan using **all required sections** from **`.cursor/commands/misc/feature-plan.md`** and **`.cursor/skills/feature-planning/SKILL.md`**:
   - Scope / Metadata, Feature Overview, Acceptance criteria, Technical design
   - **Backend tasks** and/or **C# Backend tasks** and/or **Frontend tasks** — include only what the ticket requires
   - Integration & testing, File changes, Dependencies / env
3. In plan **metadata**, record: `Linear: <KEY>` (e.g. `TB-42`), original title, and link if returned by `get_issue`.
4. **Agent scope (delegate only what applies):**
   - API, DB, server logic → **backend-architect** / **backend-reviewer** (auto-select Python or C# from plan)
   - UI, React, a11y → **frontend-architect** / **frontend-reviewer**
   - Docs-only or research-only tickets → **technical-writer** or **tech-stack-researcher** if appropriate; skip backend/frontend agents when not in scope
5. **Gate:** Plan is complete when another agent can implement without guessing. If gate fails, stay in PLAN or ASK—do not spawn Code agents.

## Phase 2: CODE — implement to plan

**Mode:** AGENT for all Code subagents.

Spawn **only** agents needed per the plan. Pass: full plan (or relevant sections), acceptance criteria, file changes, API contract, env/deps. Each agent follows compounding-dev-cycle **Code** phase.

### A1. `backend-architect` (when plan has Backend or C# Backend tasks)

**Instruct:** "Implement all backend tasks from this plan per compounding-dev-cycle Code phase. Auto-select Python (FastAPI, Pydantic, SQLAlchemy/asyncpg; python-backend.mdc, api-routes-python.mdc) or C# (ASP.NET Core; csharp-backend.mdc, api-routes-csharp.mdc) from the plan. Produce: code + tests + implementation notes (Done, Deferred, Assumptions, Env/config). Map work to AC-n. Do not expand scope."

### A2. `frontend-architect` (when plan has Frontend tasks)

**Instruct:** "Implement all frontend tasks from this plan per compounding-dev-cycle Code phase. React, Ant Design, Jotai, TanStack Query. Produce: code + tests where relevant + implementation notes. Map work to AC-n. Do not expand scope."

**Order:** backend-architect → frontend-architect when both apply (API contract first).

After Code: aggregate implementation notes and test status for Review.

## Phase 3: REVIEW / TEST

**Mode:** Ask mode (read-only) for reviewers.

Spawn reviewers **only** for domains that were implemented.

### B1. `backend-reviewer` (if backend changed)

**Instruct:** "Review backend implementation against this plan per compounding-dev-cycle Review/Test. Auto-select Python or C# per file. Produce: (1) review summary, (2) rework list with severity—Critical, Suggestion, Nice to have, (3) test status. Be specific: file/line + required change. Do not apply fixes."

### B2. `frontend-reviewer` (if frontend changed)

**Instruct:** "Review frontend implementation against this plan per compounding-dev-cycle Review/Test. Produce: (1) review summary, (2) rework list with severity, (3) test status. Be specific. Do not apply fixes."

**Gates:** AC covered by tests; no project-rule violations; no unresolved high-severity security or data-integrity issues.

## Phase 4: DECIDE — loop or production ready

- **Critical rework or gate failure:** **PLAN (rework)** — write `docs/plans/<feature-slug>-rework-N.md`, spawn Code agents for fixes, repeat Phase 3. Loop until no Critical issues.
- **No Critical issues:** declare **production ready**. Summarize: ticket key, plan path, what was built, review sign-off. Optional: offer to address Suggestion/Nice to have items.

## Handoff discipline

- State **mode** (ASK / PLAN / AGENT / Ask) on every delegation.
- Do not paste full Linear descriptions into subagent prompts—use the refined plan and AC.
- Do not suggest manual handoff without naming the next command or agent and mode.

## Cross-command relationship

- **linear/create-ticket** — file new work in Linear.
- **linear/refine-spec** — improve the Linear description (mutates Linear); run **before** apply-ticket when the ticket is vague.
- **linear/apply-ticket** (this) — **read** ticket, plan in repo, **implement and review**; Linear unchanged.
- **feature-plan** / **project-manager** — same cycle when the input is already a plan path, not a ticket id.
