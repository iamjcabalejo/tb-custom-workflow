---
name: graphify-navigation
description: Query Ticketboat product-repo knowledge graphs before Grep/Read exploration. Use when feature-plan, project-manager, api-new, new-task, or any agent needs codebase orientation and graphify-out/ may exist in a workspace root.
---

# Graphify navigation (Ticketboat)

Graph-first orientation for product repos. Cuts token cost by avoiding full-tree re-reads. Complements the official `/graphify` skill at `.agents/skills/graphify/` (build/update only).

## When to run

| Condition | Action |
|-----------|--------|
| Task touches product code / architecture / file mapping | Run graph gate below before Grep/Glob/Read exploration |
| Editing only `.cursor/` / `.codex/` / this workflow hub | Skip graph gate |
| User says not to use graphify, or graph is known stale/wrong | Skip graph; use narrow Grep/Read |

## Graph gate (strict order)

1. **Resolve roots** — Identify workspace root(s) in scope (`admin-api-python`, `admin-frontend`, `admin-api-csharp`, …).
2. **Probe** — For each root, check `<root>/graphify-out/graph.json`.
3. **If present** — From that root (or with `--graph <root>/graphify-out/graph.json`):
   - Architecture / “where is X?” → `graphify query "<question>"`
   - A↔B relationship → `graphify path "<A>" "<B>"`
   - One symbol/concept → `graphify explain "<concept>"`
4. **If missing** — Tell the user to build once, then continue with the narrowest search:
   ```bash
   cd <root> && graphify extract . --code-only
   # or in chat: /graphify .
   ```
   Do not recursively Read the tree to orient.
5. **Then edit** — Read/Grep only the files the graph (or a targeted search) pointed to.

## Subagent handoff

Every explore/implement/review subagent that touches product code must receive:

> Follow `.cursor/rules/graphify.mdc`: query `graphify` before Grep/Read exploration. Target root: `<root>`.

## After Code phase edits

In each modified product root: `graphify update .` (AST-only). Skip if `graphify` is not on PATH; note it in implementation notes.

## Checklist

- [ ] Target root(s) identified
- [ ] Graph queried (or missing-graph message + narrow search)
- [ ] No broad tree walk before graph/query
- [ ] Subagent prompts include graphify rule
- [ ] `graphify update .` after substantive code edits (when CLI available)

## Build / full skill

Rebuilds, `--update`, wiki, hooks: use `.agents/skills/graphify/SKILL.md` or `/graphify`. Upstream: https://github.com/Graphify-Labs/graphify
