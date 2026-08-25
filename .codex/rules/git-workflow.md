---
description: Never commit or push to the default branch; always use a new PR branch
alwaysApply: true
---

# Git workflow (protected default)

**Hard rule:** Never commit, push, merge, or force-push to the **default branch** (`main`, `master`, or `origin/HEAD`). Never create a PR with `gh pr create` from `/commit-push`; the developer opens the PR on GitHub.

## When the user asks to commit and/or push

Follow `.codex/skills/git-commit-push/SKILL.md` (or run **commit-push**). Do not improvise a push to default.

1. Resolve default branch (`git symbolic-ref refs/remotes/origin/HEAD`; else `main` then `master`). Treat that name **and** `main`/`master` as **protected**.
2. **Always** create a **new** branch whose base is `origin/<default>`. Do not commit on protected branches.
3. Commit on that new branch only (message via HEREDOC; no `--no-verify` unless the user asked).
4. Push **only** that new branch: `git push -u origin HEAD`. Abort if `HEAD` is protected.
5. Output copy-paste **PR title** and **PR summary** (markdown bullets). Tell the developer to open the PR on GitHub. Do **not** run `gh pr create`.

## Forbidden (no exceptions unless the user names a non-protected branch and an explicit dangerous flag)

- `git push` / `git push origin` / `git push -u origin main|master|<default>` to a protected branch
- Commit while `HEAD` is a protected branch
- `--force` / `--force-with-lease` to protected branches
- `git commit --amend` of a commit already pushed to remote
- Updating git config; `--no-verify` / `--no-gpg-sign`; `git -i` / interactive rebase
- Committing secrets (`.env`, `credentials.json`, keys, tokens)

If the user asks to commit or push **on default**: refuse, create a new branch from default, then continue.
