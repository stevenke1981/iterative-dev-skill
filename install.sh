#!/usr/bin/env bash
# iterative-dev-skill installer for macOS / Linux
# Usage: bash install.sh [--project] [--global] [--copilot]
# Default: --global (installs to ~/.claude/)

set -e

REPO_URL="https://raw.githubusercontent.com/stevenke1981/iterative-dev-skill/main"
INSTALL_GLOBAL=true
INSTALL_PROJECT=false
INSTALL_COPILOT=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --project) INSTALL_PROJECT=true; INSTALL_GLOBAL=false ;;
    --global)  INSTALL_GLOBAL=true ;;
    --copilot) INSTALL_COPILOT=true ;;
    --all)     INSTALL_GLOBAL=true; INSTALL_PROJECT=true; INSTALL_COPILOT=true ;;
  esac
done

echo "╔══════════════════════════════════════════╗"
echo "║  iterative-dev-skill installer v2.0      ║"
echo "╚══════════════════════════════════════════╝"

# ── Global: Claude Code CLI ──────────────────────────────────────────────────
if [ "$INSTALL_GLOBAL" = true ]; then
  echo ""
  echo "▶ Installing to ~/.claude/ (Claude Code CLI)..."

  # Skill directory
  mkdir -p "$HOME/.claude/skills/iterative-dev"
  curl -fsSL "$REPO_URL/SKILL.md" -o "$HOME/.claude/skills/iterative-dev/SKILL.md"
  curl -fsSL "$REPO_URL/ITERATIVE_DEV_CORE.md" -o "$HOME/.claude/skills/iterative-dev/ITERATIVE_DEV_CORE.md"
  echo "  ✓ Skill files → ~/.claude/skills/iterative-dev/"

  # Rules directory
  mkdir -p "$HOME/.claude/rules/common"
  curl -fsSL "$REPO_URL/rules/common/iterative-dev.md" -o "$HOME/.claude/rules/common/iterative-dev.md"
  curl -fsSL "$REPO_URL/rules/common/version-tracking.md" -o "$HOME/.claude/rules/common/version-tracking.md"
  curl -fsSL "$REPO_URL/rules/common/memory-sync.md" -o "$HOME/.claude/rules/common/memory-sync.md"
  echo "  ✓ Rule files → ~/.claude/rules/common/"
fi

# ── Project: .claude/ in current directory ───────────────────────────────────
if [ "$INSTALL_PROJECT" = true ]; then
  echo ""
  echo "▶ Installing to .claude/ (project-level)..."

  mkdir -p ".claude/rules/common" ".claude/rules/project"

  curl -fsSL "$REPO_URL/rules/common/iterative-dev.md" -o ".claude/rules/common/iterative-dev.md"
  curl -fsSL "$REPO_URL/rules/common/version-tracking.md" -o ".claude/rules/common/version-tracking.md"
  curl -fsSL "$REPO_URL/rules/common/memory-sync.md" -o ".claude/rules/common/memory-sync.md"
  curl -fsSL "$REPO_URL/ITERATIVE_DEV_CORE.md" -o "ITERATIVE_DEV_CORE.md"
  echo "  ✓ Project rules → .claude/rules/common/"
  echo "  ✓ ITERATIVE_DEV_CORE.md → project root"

  # Append to CLAUDE.md if exists, or create it
  CLAUDE_MD=".claude/CLAUDE.md"
  MARKER="ITERATIVE_DEV_RULE v2.0"
  if [ -f "$CLAUDE_MD" ]; then
    if grep -q "$MARKER" "$CLAUDE_MD"; then
      echo "  ℹ $CLAUDE_MD already contains iterative-dev rules, skipping."
    else
      cat >> "$CLAUDE_MD" << 'APPEND'

<!-- ITERATIVE_DEV_RULE v2.0 START — auto-appended, do not delete -->
# Iterative Development Rules
> See .claude/rules/common/iterative-dev.md for full rules.
<!-- ITERATIVE_DEV_RULE v2.0 END -->
APPEND
      echo "  ✓ Appended iterative-dev rules to $CLAUDE_MD"
    fi
  else
    mkdir -p ".claude"
    cat > "$CLAUDE_MD" << 'CREATE'
# CLAUDE.md — Project Rules

<!-- ITERATIVE_DEV_RULE v2.0 START -->
# Iterative Development Rules
This project uses iterative development mode.
> Full rules: .claude/rules/common/iterative-dev.md
<!-- ITERATIVE_DEV_RULE v2.0 END -->
CREATE
    echo "  ✓ Created $CLAUDE_MD with iterative-dev rules"
  fi
fi

# ── VS Code Copilot ───────────────────────────────────────────────────────────
if [ "$INSTALL_COPILOT" = true ]; then
  echo ""
  echo "▶ Installing VS Code Copilot instructions..."

  mkdir -p ".github"
  curl -fsSL "$REPO_URL/copilot-instructions.md" -o ".github/copilot-instructions.md"
  echo "  ✓ Copilot instructions → .github/copilot-instructions.md"

  mkdir -p ".vscode"
  if [ ! -f ".vscode/settings.json" ]; then
    cat > ".vscode/settings.json" << 'VSCODE'
{
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "file": "${workspaceFolder}/.github/copilot-instructions.md"
    }
  ]
}
VSCODE
    echo "  ✓ Created .vscode/settings.json"
  else
    echo "  ℹ .vscode/settings.json already exists."
    echo "    Add manually: \"github.copilot.chat.codeGeneration.instructions\": [{\"file\": \"\${workspaceFolder}/.github/copilot-instructions.md\"}]"
  fi
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
if [ "$INSTALL_GLOBAL" = true ]; then
  echo "  Claude Code CLI: type /iterative-dev to activate"
fi
if [ "$INSTALL_COPILOT" = true ]; then
  echo "  VS Code Copilot: restart VS Code, then use Copilot Chat"
fi
echo ""
echo "Docs: https://github.com/stevenke1981/iterative-dev-skill"
