#!/bin/bash
set -e

echo "📦 Installing open-pr..."

# Create local bin directory if it doesn't exist
mkdir -p ~/.local/bin

# Download the script
echo "⬇️  Downloading open-pr script..."
curl -fsSL https://raw.githubusercontent.com/archit-15dev/open-pr/main/open-pr -o ~/.local/bin/open-pr

# Make it executable
chmod +x ~/.local/bin/open-pr

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "⚠️  Adding ~/.local/bin to PATH..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    echo "🔄 Please run: source ~/.zshrc"
fi

# Check prerequisites
echo "🔍 Checking prerequisites..."

if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) not found. Install with: brew install gh"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "❌ jq not found. Install with: brew install jq"
    exit 1
fi

if ! command -v cursor &> /dev/null && ! command -v code &> /dev/null; then
    echo "⚠️  Neither 'cursor' nor 'code' command found."
    echo "   Install Cursor or VS Code CLI tools from the editor's Command Palette:"
    echo "   Cmd+Shift+P -> 'Shell Command: Install command in PATH'"
fi

echo "✅ open-pr installed successfully!"
echo "🚀 Usage: open-pr https://github.com/owner/repo/pull/123"