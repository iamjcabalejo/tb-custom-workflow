#!/bin/bash
# sessionStart: inject session policy (stdin JSON). stdout: JSON for Cursor.
# Aligns with: token-policy.mdc, compounding-dev-cycle.mdc, core-standards.mdc
# — refine → hand off, then compounding; stack rules are additive. See README.

CONTEXT='Ticketboat workflow: Policies in .cursor/rules/ - (1) token-policy.mdc: refine user input, hand off to commands/skills/agents, use internal XML blueprints only for complex/ambiguous/high-stakes work; graph-first for product repos. (2) compounding-dev-cycle.mdc: ASK->PLAN->AGENT, Plan->Code->Review; plan document is the contract. (3) core-standards.mdc: applies with (1)(2); type safety, errors, security boundaries. (4) graphify.mdc: before Grep/Read exploration of product code, run graphify query/path/explain when graphify-out/graph.json exists in the target root; see graphify-navigation skill. Product flow: feature-plan -> project-manager; repeat until no Critical rework. Rationale (XML): README (Why XML beats a single prose prompt).'

printf '{"continue":true,"additional_context":"%s"}\n' "$(printf '%s' "$CONTEXT" | sed 's/\\/\\\\/g; s/"/\\"/g')"
exit 0
