# Ticketboat Custom AI Coding Workflow

Shared Cursor workflow hub for Ticketboat projects. Use this repo as the central `.cursor/` source for **rules**, **agents**, **skills**, **commands**, and **hooks** in a multi-root workspace (e.g. `admin-frontend`, `admin-api-python`, `admin-api-csharp`). Cursor applies `alwaysApply` rules globally; glob-based rules match files across workspace roots.

## Development cycle

**Plan → Code → Review/Test → Plan** (see `.cursor/rules/compounding-dev-cycle.mdc`). Modes: **ASK** (discovery), **PLAN** (author plan), **AGENT** (implement or review). No implementation until the plan is complete; reviewers produce rework lists; Critical rework feeds back into Plan then Code.

## Commands

| Command | Purpose |
|--------|---------|`
| **feature-plan** | Create a feature plan in Plan mode only. Output: `docs/plans/<feature>.md`. |
| **project-manager** | Run the full cycle: Code (backend-architect, frontend-architect) → Review (backend-reviewer, frontend-reviewer). Pass the plan path as arguments. |
| **api-new** | Add a new API endpoint (FastAPI or ASP.NET Core per context). |
| **api-test** | Add or run API tests (pytest for Python). |
| **code-cleanup** | Lint/format (ruff, black, mypy for Python; ESLint, Prettier for TS). |
| **code-optimize** | Performance and structure (async, caching, bundle). |
| **commit-best** | Conventional commits; Bitbucket-aware. |
| **new-task** | Start a new task from a plan or ticket. |

## Agents

| Agent | Role | Language / scope |
|-------|------|-------------------|
| **backend-architect** | Design and implement backend APIs and data access. | **Auto-selects** Python (FastAPI) or C# (ASP.NET Core) from the plan (Backend tasks vs C# Backend tasks) or from project/files in scope. |
| **backend-reviewer** | Review backend code; produce rework list. | **Auto-selects** Python or C# from the files under review (`.py` vs `.cs`). |
| **frontend-architect** | Implement UI (React, Ant Design, Vite, Jotai, TanStack Query). | Frontend only. |
| **frontend-reviewer** | Review frontend; a11y, performance, standards. | Frontend only. |
| **tech-stack-researcher** | Evaluate tools and options against Ticketboat stack. | Research only. |
| **technical-writer** | Docs, README, API references (multi-project). | Documentation. |

One backend command covers both Python and C#; no separate backend agents per language.

## Rules (summary)

- **Always applied:** `compounding-dev-cycle.mdc`, `core-standards.mdc`.
- **Glob-based:** `python-backend.mdc` (`**/*.py`), `api-routes-python.mdc` (`**/api/**/*.py`), `csharp-backend.mdc` (`**/*.cs`), `api-routes-csharp.mdc` (`**/Controllers/**/*.cs`), `react-frontend.mdc` (`**/*.tsx`), `typescript.mdc` (`**/*.ts`).

## Skills

Orchestration: `feature-planning`, `project-manager`, `agent-selection`.  
Backend: `backend-architect`, `backend-reviewer` (both reference api-design-patterns, postgresql, security-audit, code-review; Python also api-testing).  
Frontend: `frontend-architect`, `frontend-reviewer` (accessibility-checklist, performance-profiling, code-review).  
Shared: `api-design-patterns`, `api-testing`, `postgresql`, `security-audit`, `code-review`, `refactoring-checklist`, `requirements-discovery`, `docs-structure`, `performance-profiling`, `accessibility-checklist`.

## Hooks

- **session-init** — Reminder of compounding cycle and mode switching.
- **format** — After file edit: `black` for `.py`, Prettier for `.ts`/`.tsx`/`.json`/`.md` (when available).
- **audit** — Dependency and security checks (when configured).

## Quick start

1. Include this repo in your Cursor multi-root workspace with `admin-frontend`, `admin-api-python`, and/or `admin-api-csharp`.
2. **Plan:** Run **feature-plan** with a feature name/slug → produces `docs/plans/<feature>.md`.
3. **Execute:** Run **project-manager** with the plan path → backend-architect (auto-selects Python/C#), frontend-architect, then backend-reviewer and frontend-reviewer.
4. Resolve Critical rework via Plan (rework AC) → Code → Review until production ready.

## Stacks

- **Python:** FastAPI, Pydantic v2, asyncpg, SQLAlchemy 2, pytest. Rules: `python-backend.mdc`, `api-routes-python.mdc`.
- **C#:** .NET 8+, ASP.NET Core, EF Core/Dapper, xUnit/NUnit. Rules: `csharp-backend.mdc`, `api-routes-csharp.mdc`.
- **Frontend:** React 18, Vite, TypeScript, Ant Design 5, Jotai, TanStack React Query. Rules: `react-frontend.mdc`, `typescript.mdc`.

Deploy: ECS (Terraform), Bitbucket Pipelines. Auth: Firebase, MSAL (Azure AD).
