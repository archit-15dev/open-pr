# Open-PR Tool Development Guide

## Project Overview

Open-PR is a command-line tool that streamlines the GitHub PR review workflow by automatically checking out PR branches and opening modified files in Cursor editor.

## Key Features

- **Smart Branch Management**: Detects existing local branches and syncs safely without destructive rebases
- **Fork Support**: Handles both same-repository PRs and cross-fork PRs elegantly
- **GitHub Integration**: Uses GitHub API to fetch PR metadata and file lists
- **Editor Integration**: Opens all modified files in Cursor for immediate review
- **Safety First**: Stashes uncommitted work and provides clear status reporting

## Architecture

### Core Functions

- `extract_pr_info()`: Parses GitHub URLs or PR numbers
- `get_pr_details()` & `get_pr_files()`: GitHub API integration
- `checkout_pr_branch()`: **CORE LOGIC** - Safe branch checkout and sync
- `open_files_in_cursor()`: Editor integration

### Authentication Flow

1. Try `$GITHUB_TOKEN` environment variable
2. Fallback to `gh auth token` from GitHub CLI
3. Error gracefully with setup instructions

## Development Guidelines

### Branch Handling Philosophy

**NEVER automatically rebase** - this was the core issue causing sync problems where users saw "9 commits to pull, 1063 to push" scenarios.

Instead:
- Use `git pull` for syncing with remote branches
- Preserve original commit hashes
- Report branch status relative to base branch
- Suggest merge/rebase commands but don't execute them

### Safety Mechanisms

```bash
# Always check for uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet; then
    git stash push -m "open-pr: Auto-stash before checkout at $(date)"
fi

# Validate branch existence before operations
if git show-ref --verify --quiet "refs/heads/$branch"; then
    # Branch exists - sync safely
else
    # Branch doesn't exist - create with tracking
fi
```

### Fork PR Handling

- Add fork remotes dynamically: `fork-{pr_number}`
- Use descriptive local branch names: `pr-{number}-{branch_name}`
- Persistent fork remotes for future use
- Clean sync without history rewriting

## Testing

### Manual Test Scenarios

1. **Same-repo PR, new branch**: Should create and track properly
2. **Same-repo PR, existing branch**: Should checkout and sync without conflicts
3. **Fork PR, first time**: Should add remote and create local branch
4. **Fork PR, existing**: Should sync with fork remote cleanly

### Edge Cases

- Deleted/renamed files (filter from Cursor opening)
- Network connectivity issues (graceful GitHub API failures)
- Missing dependencies (gh, jq, cursor CLI)
- Repository permission issues

## Dependencies

- `gh` - GitHub CLI for authentication
- `jq` - JSON parsing for GitHub API responses
- `cursor` - Cursor editor command line tools
- Standard git tools

## Installation

The tool includes an `install.sh` script that copies the `open-pr` script to `~/.local/bin/` and ensures it's executable.

## Usage Patterns

```bash
# Full GitHub URL
open-pr https://github.com/owner/repo/pull/12345

# Just PR number (uses current repo)
open-pr 12345

# Cross-fork PR (automatically detected)
open-pr https://github.com/contributor/repo/pull/678
```

## Future Enhancements

- Support for other editors (VS Code, vim, etc.)
- Configuration file for default behavior
- Batch processing of multiple PRs
- Integration with PR review tools

## Debugging

Enable verbose git output for troubleshooting:
```bash
export GIT_TRACE=1
export GIT_CURL_VERBOSE=1
```

Check GitHub API rate limits:
```bash
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/rate_limit
```

## Common Issues

### Sync Problems
- **Symptom**: "X commits to pull, Y to push"
- **Cause**: Previous version used automatic rebase
- **Solution**: Current version uses `git pull` for safe sync

### Authentication Errors
- **Symptom**: "GitHub API error: Bad credentials"
- **Solution**: Run `gh auth login` and verify token scope

### Missing Files
- **Symptom**: Files not opening in Cursor
- **Solution**: Check if files were deleted/renamed in PR