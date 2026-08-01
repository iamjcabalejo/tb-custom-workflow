## graphify

Ticketboat multi-root workspace: each product repo may have its own `graphify-out/` with god nodes, communities, and cross-file edges.

When the user types `/graphify` or `$graphify`, use the installed graphify skill (`.agents/skills/graphify/` or `.codex/skills/graphify/`) before anything else.

Rules:
- **Phase budget** (see `.codex/rules/graphify.md`): PLAN = required query before explore; Code = plan-first (File changes); Review = diff-first; after edits = `graphify update .`. Prefer `graphify query "…" --budget 1500`.
- For orientation against a product root, run CLI `query` / `path` / `explain` when `<root>/graphify-out/graph.json` exists. Prefer `--graph <root>/graphify-out/graph.json` when cwd is not that root. Load the full `/graphify` skill only for build/update/wiki/hooks—not routine queries.
- Before `feature-plan`, `project-manager`, `apply-ticket`, or other explore-heavy commands, follow `.codex/skills/graphify-navigation/SKILL.md`.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip if the task is about stale/incorrect graph output, or the user explicitly says not to use it.
- If `<root>/graphify-out/wiki/index.md` exists, use it for broad navigation instead of raw source browsing.
- Read `<root>/graphify-out/GRAPH_REPORT.md` only for broad architecture review when query/path/explain do not surface enough context.
- Workflow-hub paths under `.cursor/` / `.codex/` do not require a graph.
