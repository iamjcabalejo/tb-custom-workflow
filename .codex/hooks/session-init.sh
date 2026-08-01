#!/bin/bash
# sessionStart: inject session policy (stdin JSON). stdout: JSON for Codex/Cursor.
# Aligns with: token-policy.md, compounding-dev-cycle.md, core-standards.md, graphify.md
# — refine → hand off, then compounding; graphify phase budget. See README.

CONTEXT='Ticketboat workflow: Policies in .codex/rules/ - (1) token-policy.md: refine user input, hand off to commands/skills/agents, use internal XML blueprints only for complex/ambiguous/high-stakes work. (2) compounding-dev-cycle.md: ASK->PLAN->AGENT, Plan->Code->Review; plan document is the contract; prefer plan path handoff / new chat for Code on large tickets. (3) core-standards.md: type safety, errors, security boundaries. (4) graphify.md phase budget: PLAN required query; Code plan-first; Review diff-first; graphify update after edits; CLI for query—not full /graphify skill. See graphify-navigation skill. Product flow: feature-plan or apply-ticket PLAN -> project-manager Code/Review; repeat until no Critical rework. Rationale (XML): README (Why XML beats a single prose prompt).'

printf '{"continue":true,"additional_context":"%s"}\n' "$(printf '%s' "$CONTEXT" | sed 's/\\/\\\\/g; s/"/\\"/g')"
exit 0
