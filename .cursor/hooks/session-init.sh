#!/bin/bash
# sessionStart: short reminder (full policy lives in alwaysApply rules).
CONTEXT='Ticketboat: refine→hand off (token-policy); Plan→Code→Review (compounding); graphify phase budget PLAN/Code/Review; feature-plan or apply-ticket PLAN then /project-manager in a new chat for Code; never commit/push default—/commit-push new branch only. See README.'

printf '{"continue":true,"additional_context":"%s"}\n' "$(printf '%s' "$CONTEXT" | sed 's/\\/\\\\/g; s/"/\\"/g')"
exit 0
