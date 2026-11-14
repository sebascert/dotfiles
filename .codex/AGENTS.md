# Filesystem Access Policy

## Inside Git Repositories

When operating inside a Git working tree:

- You may autonomously create, modify, and delete project files.
- You may modify tracked and untracked files.
- You must not modify Git staging, commits, branches, tags, or history.
- You must not execute Git commands that alter repository state.
- Keep all modifications within the active project.
- Never modify files outside the repository without explicit approval.

## Outside Git Repositories

When operating outside a Git working tree:

- Do not modify, rename, or delete existing files.
- Do not install dependencies or run commands that modify the environment.
- You may inspect files, analyze code, and suggest changes.
- You may create, modify, and delete files you created during the current session.
- If changes to existing files are needed, ask for explicit user permission
  before proceeding. Only make changes the user has approved.

## Safety

Never attempt to bypass filesystem restrictions.

Never change sandbox permissions to perform a prohibited operation.

# Global Codex Instructions

## Project Files

You have full permission to:

- Create files and directories.
- Modify existing files.
- Delete unnecessary project files.
- Rename and reorganize project files.
- Install project dependencies.
- Execute build commands and tests.
- Run formatters and linters.

Do not request approval for ordinary project-file modifications.

## Git Policy — Strictly Read-Only

Git is exclusively for inspection.

You MUST NOT execute any Git command that modifies:

- The Git index or staging area.
- Git commits or history.
- Local or remote branches.
- Git tags or references.
- Git configuration.
- Git metadata.
- Git worktrees.
- Git remotes.

### Allowed Git commands

- git status
- git diff
- git log
- git show
- git branch --list
- git branch -a
- git remote -v
- git ls-files
- git rev-parse
- git blame

### Forbidden Git commands

- git add
- git commit
- git reset
- git restore --staged
- git checkout
- git switch
- git merge
- git rebase
- git cherry-pick
- git revert
- git stash
- git push
- git pull
- git fetch
- git branch -d
- git branch -D
- git tag (creation or deletion)
- git update-index
- git update-ref
- git clean
- git apply
- git am
- git worktree add/remove
- git config (modifications)

Never bypass these restrictions through another tool.

## Workflow

1. Inspect the project.
2. Make the requested changes directly to working-tree files.
3. Run relevant tests.
4. Inspect changes using git diff and git status.
5. Report modified files and test results.
6. Leave all staging, committing, and pushing to the user.

Never stage or commit changes, even when explicitly requested
during a task. Explain that Git modifications are reserved
for the user.
