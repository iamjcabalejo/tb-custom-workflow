---
description: Create a new branch from default, commit, push that branch only, emit copy-paste GitHub PR title and summary
---

Commit and push **only** on a **new branch** based on the repo **default** branch. **Never** commit or push to `main` / `master` / default. **Do not** run `gh pr create`.

**Follow** `.codex/skills/git-commit-push/SKILL.md` and `.codex/rules/git-workflow.md` with no shortcuts.

## Arguments

$ARGUMENTS

Use arguments as an optional branch name (`feat/short-slug`) and/or commit-message hint. If omitted, infer both from the diff.

## Required sequence

1. **Always** create a **new** branch. Base = `origin/<default>` (`git symbolic-ref refs/remotes/origin/HEAD`; else `main` then `master`).
2. Commit on that branch with a proper HEREDOC message (why, conventional `type(scope): subject`).
3. Push **that** branch: `git push -u origin HEAD`. Abort if HEAD is protected.
4. Tell the developer to open the PR **manually on GitHub**. Print copy-paste **PR Title** and **PR Summary** (markdown bullets).

If already on default: do not commit there; switch `-c` first. If the user asks to push to default: refuse and keep the new-branch path.
