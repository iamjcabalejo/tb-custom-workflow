---
description: Graphify knowledge graph — query before exploring product repos (Ticketboat multi-root)
alwaysApply: true
---

# Graphify (Ticketboat)

Each product repo in the multi-root workspace (`admin-frontend`, `admin-api-python`, `admin-api-csharp`, …) may have its own `graphify-out/graph.json`. Prefer that graph over re-reading or grepping the tree.

**MANDATORY: Before using Read, Grep, Glob, or Bash to explore application code, run graphify first.**

1. Resolve the target workspace root(s) for the task.
2. If `<root>/graphify-out/graph.json` exists, query from that root (or pass `--graph`):
   - `graphify query "<question>"` — scoped subgraph for architecture / “how does X work?”
   - `graphify path "<A>" "<B>"` — dependency path between two symbols
   - `graphify explain "<concept>"` — neighbors of one concept
3. When cwd is not `<root>`, use: `graphify query "<question>" --graph <root>/graphify-out/graph.json`

This applies to you and every subagent you spawn. Include this rule in every subagent prompt that explores code. Do not skip graphify because files are “already known” or because you are executing a plan — the graph surfaces cross-file and INFERRED edges that Grep/Read miss.

**Only** use Read/Grep/Glob for exploration when:
1. Graphify already oriented you and you need specific lines to edit or debug, or
2. `<root>/graphify-out/graph.json` does not exist yet — then tell the user to build once (`cd <root> && graphify extract . --code-only` or `/graphify .`), and use the narrowest Grep/Glob possible. Do not recursively read the tree to orient.

Also:
- If `<root>/graphify-out/wiki/index.md` exists, navigate it instead of raw files for broad orientation.
- Read `<root>/graphify-out/GRAPH_REPORT.md` only for broad architecture review when query/path/explain are insufficient.
- After modifying application code in a product root, run `graphify update .` in that root (AST-only, no API cost).
- Workflow-hub files under `.cursor/` / `.codex/` are not product code; do not require a graph for editing those.

**Commands:** Before `feature-plan`, `project-manager`, `api-new`, `new-task`, or any Plan/Code exploration of product repos, follow `.codex/skills/graphify-navigation/SKILL.md` (graph-first gate).
