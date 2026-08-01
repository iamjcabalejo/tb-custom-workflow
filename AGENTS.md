## graphify

Ticketboat multi-root workspace: each product repo may have its own `graphify-out/` with god nodes, communities, and cross-file edges.

When the user types `/graphify` or `$graphify`, use the installed graphify skill (`.agents/skills/graphify/` or `.codex/skills/graphify/`) before anything else.

Rules:
- For codebase questions against a product root, first run `graphify query "<question>"` when `<root>/graphify-out/graph.json` exists. Use `graphify path "<A>" "<B>"` and `graphify explain "<concept>"` for relationships and focused concepts. Prefer `--graph <root>/graphify-out/graph.json` when cwd is not that root.
- Before `feature-plan`, `project-manager`, or other explore-heavy commands, follow `.codex/skills/graphify-navigation/SKILL.md` (graph-first gate).
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip if the task is about stale/incorrect graph output, or the user explicitly says not to use it.
- If `<root>/graphify-out/wiki/index.md` exists, use it for broad navigation instead of raw source browsing.
- Read `<root>/graphify-out/GRAPH_REPORT.md` only for broad architecture review when query/path/explain do not surface enough context.
- After modifying application code, run `graphify update .` in that product root (AST-only, no API cost).
- Workflow-hub paths under `.cursor/` / `.codex/` do not require a graph.
