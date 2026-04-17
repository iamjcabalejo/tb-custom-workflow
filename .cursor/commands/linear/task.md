---
description: Plan mode — load a Linear issue by ID via MCP and produce an implementation plan (no code).
---

**Scope:** Turn a **Linear ticket** into a **detailed plan** for this repo. **Plan mode only:** no implementation, no edits to application code, no running builds or tests. Align with `.cursor/rules/compounding-dev-cycle.mdc` (plan complete when another agent can implement without guessing).

## Linear MCP (mandatory)

Use the **Linear** MCP server tools — do not guess ticket content from memory.

1. **Before the first MCP call:** Read the tool descriptor(s) under your workspace MCP tools folder (e.g. `mcps/plugin-linear-linear/tools/<tool>.json`) so arguments match the schema.
2. **Linear string rules:** When passing strings to MCP tools, send real newlines in markdown — not literal `\n` escape sequences.

### Required calls (in order)

1. **`get_issue`** — `id`: the Linear issue identifier from arguments (e.g. `TB-42`, `LIN-123`). Set `includeRelations`: **true**. Set `includeCustomerNeeds`: **true** if the tool supports it and product context helps planning.
2. **`list_comments`** — `issueId`: same identifier as above (use pagination if there are many comments).

### Optional (only if needed for the plan)

- **`get_team`** — if team/workflow context is unclear from the issue payload.
- **`list_issue_statuses`** — `team`: team name or ID from the issue, if state/workflow must be referenced in the plan.
- **`list_issues`** — `query`: short search string **only** if the user’s ID fails or is ambiguous; then confirm with the user before planning.

If **`get_issue`** fails or returns nothing: stop planning, report the error, and ask for a valid **issue ID or key** (required).

## Ticket ID (mandatory)

**Arguments:** `$ARGUMENTS`

- Interpret `$ARGUMENTS` as a **single Linear issue ID or identifier** (team key + number, or UUID-style id if the user pasted it).
- If arguments are **empty**, or not a plausible issue reference, **do not** call MCP with a guessed id. Ask once: *“Provide the Linear ticket ID (e.g. TB-123).”*

## Plan output (mandatory)

After fetching the issue (and comments), produce a plan that includes:

1. **Ticket summary** — Title, identifier, URL if present in MCP payload, team, state, priority, assignee (as returned).
2. **Problem / goal** — Plain language, from description + comments.
3. **Acceptance criteria** — Numbered (AC-1, AC-2, …), testable (Given/When/Then or checklist). Derive from description, comments, and relations; flag gaps.
4. **Technical approach** — Files/areas likely touched, APIs, data, risks; reference project rules (`core-standards.mdc`, stack rules) where relevant.
5. **Task breakdown** — Phased checklist (Setup → Backend → Frontend → Tests) suitable for **feature-plan** or **project-manager** handoff.
6. **Open questions** — Only if something blocks planning; keep minimal.

**Handoff:** Tell the user to save or run **feature-plan** / **project-manager** with this plan if they want the full compounding cycle.

Do not implement tickets or modify production code in this command.
