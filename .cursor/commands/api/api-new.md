---
description: Create a new FastAPI endpoint with Pydantic validation, error handling, and async support
---

Create a new FastAPI API endpoint following project rules and the compounding dev cycle (Plan → Code → Review/Test). See `.cursor/rules/compounding-dev-cycle.mdc`, `.cursor/rules/api-routes-python.mdc`, and `.cursor/rules/python-backend.mdc`.

## Requirements

API Endpoint: $ARGUMENTS

## Compounding dev cycle

This command delivers **Code** phase output. If the new API is part of a feature with a plan doc, implement to that plan (scope and acceptance criteria) and do not expand scope without updating the plan. If there is no plan, treat the user's request as minimal scope and produce a short **implementation notes** section (what was done, deferred, assumptions, env/config) so **backend-reviewer** can verify in Review/Test. Align with `api-routes-python.mdc` (validation, status codes, error shape, security) and `core-standards.mdc` for traceability and handoff.

## Agent Definitions

**Apply the agent-selection skill** (`.cursor/skills/agent-selection/SKILL.md`): before implementing, identify relevant agents, read their definitions from `.cursor/agents/`, and apply their perspective.

**Relevant agents for this command:** backend-architect (primary), backend-reviewer (checklist for handoff). Implement in line with `api-routes-python.mdc`; produce implementation notes for Review/Test. The generated route should be verifiable by backend-reviewer: include tests or test guidance (pytest); document what was done, deferred, and env/config.

## Implementation Guidelines

### 1. FastAPI router
- Use `APIRouter` with prefix and tags; mount in app
- Place in project's API module (e.g. `src/app/api/` or per-resource routers)

### 2. Validation
- Use Pydantic v2 request models for body, query, path
- Validate input at boundary; FastAPI returns 422 for validation errors
- Return clear validation error details (FastAPI default or custom exception handler)

### 3. Error handling
- Use `HTTPException` from FastAPI with `status.HTTP_*` from Starlette
- Consistent error response shape (e.g. `{"error": {"code": str, "message": str, "details": list}}`)
- Never expose stack traces or sensitive details to client; log server-side

### 4. Structure
- Async route handlers for I/O
- Use `Depends()` for DB session, current user, and shared services
- Keep route handlers thin; delegate to service layer

### 5. Security
- Auth/authorization via dependencies; return 401/403 early
- Parameterized queries only (SQLAlchemy/asyncpg); no raw SQL concatenation
- Rate limiting considered for auth/sensitive endpoints

### 6. Response
- Use Pydantic response_model for success responses
- Status codes: 200 (GET/PUT/PATCH), 201 (POST), 204 (DELETE), 400/401/403/404/409/500 as appropriate

## Code structure

Create:

1. **Router module** – e.g. `api/<resource>.py` with route definitions
2. **Pydantic models** – Request/response models (in model layer or next to router)
3. **Service layer** (if needed) – Business logic called from route
4. **Dependencies** – e.g. `get_db`, `get_current_user` used in `Depends()`

## Output (handoff for Review/Test)

Deliver:

1. **Router and supporting code** – FastAPI router, Pydantic models, error handling, and (if applicable) service layer.
2. **Tests or test guidance** – pytest tests (httpx.AsyncClient or TestClient) for success, validation, and error cases so backend-reviewer can verify coverage.
3. **Implementation notes** – Short list: what was implemented, what was deferred (e.g. auth, rate limiting), assumptions, and any env/config (e.g. `DATABASE_URL`, secrets).

Generate production-ready code that is handoff-ready for the compounding dev cycle and consistent with the Ticketboat Python backend (FastAPI, Pydantic v2, async).
