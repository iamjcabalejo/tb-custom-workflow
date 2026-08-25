---
name: git-commit-push
description: Create a new branch from the repo default branch, commit with a proper message, push that branch only, and emit copy-paste GitHub PR title and summary. Use when the user runs commit-push, or asks to commit, push, ship changes, or open a PR branch. Never commit or push to main/master/default.
---

# Git commit-push (PR branch only)

Operate in **one git root** (the product repo with the changes). If several roots are dirty, stop and ask which root, or run this skill once per root. Do **not** run `gh pr create`. Do **not** commit or push **protected** branches.

**Protected:** the remote default (`git symbolic-ref refs/remotes/origin/HEAD` → `refs/remotes/origin/<name>`) **and** `main` **and** `master`.

## Guard (before every commit and every push)

```bash
branch=$(git rev-parse --abbrev-ref HEAD)
default=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
# If symbolic-ref fails: default=main if it exists, else master
```

If `$branch` is `main`, `master`, or `$default`: **stop**. Create a new branch first. Never `git push origin HEAD:main` (or master/default).

## Workflow

Copy and track:

- [ ] Inspect (parallel)
- [ ] Abort if nothing to commit (and no unpushed commits on a new branch)
- [ ] Fetch default; create **new** branch from `origin/<default>`
- [ ] Move changes onto that branch
- [ ] Guard: HEAD is not protected
- [ ] Stage (no secrets); commit via HEREDOC
- [ ] Guard again; `git push -u origin HEAD`
- [ ] Print copy-paste PR title + summary

### 1. Inspect (parallel, no extra git exploration)

In the target repo, run together:

- `git status`
- `git diff` and `git diff --staged`
- `git log -8 --oneline` (match message style)
- `git rev-parse --abbrev-ref HEAD` and default-branch resolution above
- `git branch --show-current`

### 2. Empty / secrets

If there are **no** unstaged, staged, or untracked files **and** no local commits to ship on a new branch: stop. No empty commit.

Do **not** stage `.env`, `credentials.json`, private keys, or files that look like secrets. If the user asked to include them: warn and skip those files.

### 3. Always create a new branch from default

Fetch: `git fetch origin <default>`.

**Branch name:** use `$ARGUMENTS` if it is a valid non-protected name (`feat|fix|chore|docs|refactor|test/<kebab-slug>`). Else infer prefix from the diff and a short slug (≤50 chars, lowercase, hyphens). Never name a branch `main` or `master`.

**Bring work onto a branch based on `origin/<default>`:**

| Current state | Action |
|---------------|--------|
| On protected, dirty working tree | `git switch -c <new>` (keeps dirty files; base is still default) |
| On protected, clean, nothing to commit | Stop |
| On protected, local commits **ahead of** `origin/<default>` | `git switch -c <new>` so those commits leave protected `HEAD`; **do not** `git push` protected |
| On non-protected with **uncommitted** changes | `git stash push -u -m commit-push`; `git switch -c <new> origin/<default>`; `git stash pop`; resolve conflicts before commit |
| On non-protected with **unique commits** not on default | `git switch -c <new> origin/<default>` then `git cherry-pick <sha>…` those commits (or replay the range). Do not merge default into protected |

Do **not** reuse the current branch name. Always `-c` a **new** name for this run.

### 4. Commit

Stage intended files (`git add` paths; not `git add -i`).

Message: 1–2 sentences, **why** not file lists. Prefer conventional: `type(scope): subject` plus a blank line and body when needed.

```bash
git commit -m "$(cat <<'EOF'
type(scope): short subject

Why this change exists. What behavior it enables or fixes.

EOF
)"
```

If the hook **rejects** the commit: fix, then a **new** commit (do not `--amend` unless this conversation created HEAD, it is unpushed, and the user asked or the hook only mutated files). Never `--no-verify` unless the user asked.

### 5. Push

Guard: HEAD must not be protected. Then:

```bash
git push -u origin HEAD
```

Request network permissions if the push is blocked. No `--force` / `--force-with-lease`. No push if commit did not happen (unless shipping already-created unique commits on the new branch).

### 6. PR copy-paste (required output)

After a successful push, print **exactly** this shape so the developer can paste into GitHub. Do not open the PR.

```markdown
Open a pull request on GitHub: compare `<new-branch>` → `<default>`.
Do not merge to `<default>` from this command.

## PR Title

<one line, imperative, ≤72 chars; same intent as the commit subject>

## PR Summary

- <what changed and why>
- <scope / user-visible impact>
- <tests or verification done, if any>
```

Title: summarize the whole branch (all commits), not a single file. Summary: 3–8 bullets, markdown, no secrets.

## Abort conditions

- Push or commit target would be protected → refuse, create new branch, retry from step 3.
- Hook failed → fix, new commit, then push.
- Stash pop conflicts → stop and report; do not push a broken tree.
- User asked to push **to default** → refuse; continue on a new branch instead.
