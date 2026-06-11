#!/bin/bash

# Check for Homebrew and install it on Linux if not found

BREW_PATH="/home/linuxbrew/.linuxbrew/bin/brew"

# ── Guard: Linux only ────────────────────────────────────────────────────────
if [[ "$(uname -s)" != "Linux" ]]; then
  echo "❌ This script is intended for Linux only."
  exit 1
fi

# ── Check if already installed ───────────────────────────────────────────────
if command -v brew &>/dev/null; then
  echo "✅ Homebrew is already installed: $(brew --version | head -1)"
  exit 0
fi

# ── Install dependencies ─────────────────────────────────────────────────────
echo "📦 Installing required dependencies..."

if command -v apt-get &>/dev/null; then
  sudo apt-get update -y
  sudo apt-get install -y build-essential procps curl file git
elif command -v dnf &>/dev/null; then
  sudo dnf groupinstall -y "Development Tools"
  sudo dnf install -y procps-ng curl file git
elif command -v yum &>/dev/null; then
  sudo yum groupinstall -y "Development Tools"
  sudo yum install -y procps-ng curl file git
else
  echo "⚠️  No supported package manager found (apt/dnf/yum)."
  echo "   Please manually install: build-essential curl file git"
fi

# ── Run the official Homebrew installer ──────────────────────────────────────
echo "🍺 Installing Homebrew..."
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# ── Verify installation ───────────────────────────────────────────────────────
if [[ ! -x "$BREW_PATH" ]]; then
  echo "❌ Installation may have failed. Please check the output above."
  exit 1
fi

eval "$("$BREW_PATH" shellenv)"
echo "✅ Homebrew installed successfully: $(brew --version | head -1)"

# ── Persist PATH in ~/.bashrc ─────────────────────────────────────────────────
if ! grep -q "brew shellenv" "$HOME/.bashrc"; then
  echo "" >>"$HOME/.bashrc"
  echo "# Homebrew" >>"$HOME/.bashrc"
  echo "eval \"\$($BREW_PATH shellenv)\"" >>"$HOME/.bashrc"
  echo "📝 Added Homebrew to PATH in ~/.bashrc"
  echo "   Run 'source ~/.bashrc' or open a new terminal to use brew."
fi

# ── Persist PATH in ~/.bashrc ─────────────────────────────────────────────────
if ! grep -q "brew shellenv" "$HOME/.zshrc"; then
  echo "" >>"$HOME/.zshrc"
  echo "# Homebrew" >>"$HOME/.zshrc"
  echo "eval \"\$($BREW_PATH shellenv)\"" >>"$HOME/.zshrc"
  echo "📝 Added Homebrew to PATH in ~/.zshrc"
  echo "   Run 'source ~/.zshrc' or open a new terminal to use brew."
fi
