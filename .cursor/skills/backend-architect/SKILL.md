---
name: backend-architect-skillset
description: Skillset for backend design and implementation (Python or C#). Auto-select language from plan or project; apply the matching rules and skills.
---

# Backend Skillset (Ticketboat)

Single entry point for **backend** work in **Python (FastAPI)** or **C# (ASP.NET Core)**. When invoked, **determine language** from (1) the feature plan—**Backend tasks** → Python, **C# Backend tasks** → C#—or (2) project/files in scope (admin-api-python or `.py` → Python; admin-api-csharp or `.cs` → C#). Then apply the rules and skills below for that language.

## Language-specific rules

| Language | Project rules | When |
|----------|----------------|------|
| **Python** | `core-standards.mdc`, `python-backend.mdc`, `api-routes-python.mdc` | Plan has "Backend tasks" or files are in admin-api-python / `.py` |
| **C#** | `core-standards.mdc`, `csharp-backend.mdc`, `api-routes-csharp.mdc` | Plan has "C# Backend tasks" or files are in admin-api-csharp / `.cs` |

If the plan has both Backend tasks and C# Backend tasks, implement both; apply Python rules to Python work and C# rules to C# work.

## Skills in this set

| Skill | Path | When to use |
|-------|------|-------------|
| `api-design-patterns` | `.cursor/skills/api-design-patterns/SKILL.md` | Designing or changing APIs—REST conventions; use with api-routes-python (Python) or api-routes-csharp (C#) |
| `api-testing` | `.cursor/skills/api-testing/SKILL.md` | Python API tests—pytest, success, validation, auth, error cases |
| `postgresql` | `.cursor/skills/postgresql/SKILL.md` | Schema design, queries, indexing (asyncpg/SQLAlchemy or EF Core/Dapper) |
| `refactoring-checklist` | `.cursor/skills/refactoring-checklist/SKILL.md` | Refactoring backend code—safe steps, behavior preservation |
| `code-review` | `.cursor/skills/code-review/SKILL.md` | Reviewing backend code or PRs—correctness, security, maintainability |
| `security-audit` | `.cursor/skills/security-audit/SKILL.md` | OWASP-aligned checks—auth/authz, injection, sensitive data, logging |

## How to use

1. Read this file first.
2. **Determine language(s)** from the plan or from the files/project in scope (see table above).
3. For the current task, determine which skills apply and read those skill files.
4. Apply **Python** patterns (FastAPI, Pydantic, Depends(), pytest) or **C#** patterns (ASP.NET Core, EF Core/Dapper, DI, xUnit/NUnit) according to the selected language.

## Alignment

- **Python:** Follow `core-standards.mdc`, `python-backend.mdc`, `api-routes-python.mdc`. Handoff: implementation notes, tests (pytest), linkage to AC.
- **C#:** Follow `core-standards.mdc`, `csharp-backend.mdc`, `api-routes-csharp.mdc`. Handoff: implementation notes, tests (xUnit/NUnit), linkage to AC.
