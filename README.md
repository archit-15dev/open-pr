# open-pr

Instantly open GitHub PRs in your editor with all modified files ready for review.

## What it does

- Parses GitHub PR URLs
- Checks out the PR branch locally
- Opens all modified files in Cursor/VS Code
- Handles both regular and fork PRs automatically

## Installation

```bash
curl -sSL https://raw.githubusercontent.com/archits26/open-pr/main/install.sh | bash
```

Or manually:
```bash
curl -o ~/.local/bin/open-pr https://raw.githubusercontent.com/archits26/open-pr/main/open-pr
chmod +x ~/.local/bin/open-pr
```

## Usage

```bash
# Open any GitHub PR
open-pr https://github.com/owner/repo/pull/123

# Or just the PR number (uses current repo)
open-pr 123
```

## Requirements

- `gh` CLI (GitHub CLI): `brew install gh`
- `jq`: `brew install jq`
- `cursor` or `code` command (Cursor/VS Code CLI)

## Example

```bash
$ open-pr https://github.com/facebook/react/pull/12345
✅ Successfully checked out PR branch
✅ Opened 8 files in Cursor
🚀 PR 12345 is ready for review!
```

Perfect for code reviews and continuing work on PRs!