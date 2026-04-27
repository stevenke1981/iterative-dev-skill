# iterative-dev-skill installer for Windows PowerShell
# Usage: .\install.ps1 [-Global] [-Project] [-Copilot] [-All]
# Default: -Global (installs to $env:USERPROFILE\.claude\)

param(
  [switch]$Global  = $false,
  [switch]$Project = $false,
  [switch]$Copilot = $false,
  [switch]$All     = $false
)

# Default to Global if nothing specified
if (-not $Global -and -not $Project -and -not $Copilot -and -not $All) {
  $Global = $true
}
if ($All) { $Global = $true; $Project = $true; $Copilot = $true }

$RepoUrl = "https://raw.githubusercontent.com/stevenke1981/iterative-dev-skill/master"
$ClaudeHome = "$env:USERPROFILE\.claude"

function Download-File {
  param([string]$Url, [string]$Dest)
  $dir = Split-Path $Dest -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
  Invoke-WebRequest -Uri $Url -OutFile $Dest -UseBasicParsing
}

Write-Host ""
Write-Host "╔══════════════════════════════════════════╗"
Write-Host "║  iterative-dev-skill installer v2.2      ║"
Write-Host "╚══════════════════════════════════════════╝"

# ── Global: Claude Code CLI ──────────────────────────────────────────────────
if ($Global) {
  Write-Host ""
  Write-Host "▶ Installing to $ClaudeHome (Claude Code CLI)..."

  $skillDir = "$ClaudeHome\skills\iterative-dev"
  $rulesDir = "$ClaudeHome\rules\common"

  Download-File "$RepoUrl/SKILL.md"                        "$skillDir\SKILL.md"
  Download-File "$RepoUrl/ITERATIVE_DEV_CORE.md"           "$skillDir\ITERATIVE_DEV_CORE.md"
  Write-Host "  OK Skill files -> $skillDir"

  Download-File "$RepoUrl/rules/common/iterative-dev.md"      "$rulesDir\iterative-dev.md"
  Download-File "$RepoUrl/rules/common/version-tracking.md"   "$rulesDir\version-tracking.md"
  Download-File "$RepoUrl/rules/common/memory-sync.md"        "$rulesDir\memory-sync.md"
  # v2.2 新增
  Download-File "$RepoUrl/rules/common/function-docs.md"      "$rulesDir\function-docs.md"
  Write-Host "  OK Rule files  -> $rulesDir"

  # v2.2 新增：references 和 templates
  $refsDir      = "$skillDir\references"
  $templatesDir = "$skillDir\templates"
  Download-File "$RepoUrl/references/mvp-bootstrap.md"           "$refsDir\mvp-bootstrap.md"
  Download-File "$RepoUrl/references/function-doc-workflow.md"   "$refsDir\function-doc-workflow.md"
  Download-File "$RepoUrl/templates/function-doc.md"             "$templatesDir\function-doc.md"
  Write-Host "  OK References  -> $refsDir"
  Write-Host "  OK Templates   -> $templatesDir"
}

# ── Project: .claude\ in current directory ───────────────────────────────────
if ($Project) {
  Write-Host ""
  Write-Host "▶ Installing to .claude\ (project-level)..."

  $dirs = @(".claude\rules\common", ".claude\rules\project")
  foreach ($d in $dirs) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
  }

  Download-File "$RepoUrl/rules/common/iterative-dev.md"    ".claude\rules\common\iterative-dev.md"
  Download-File "$RepoUrl/rules/common/version-tracking.md" ".claude\rules\common\version-tracking.md"
  Download-File "$RepoUrl/rules/common/memory-sync.md"      ".claude\rules\common\memory-sync.md"
  # v2.2 新增
  Download-File "$RepoUrl/rules/common/function-docs.md"    ".claude\rules\common\function-docs.md"
  Download-File "$RepoUrl/ITERATIVE_DEV_CORE.md"            "ITERATIVE_DEV_CORE.md"
  Write-Host "  OK Project rules -> .claude\rules\common\"
  Write-Host "  OK ITERATIVE_DEV_CORE.md -> project root"

  # v2.2 新增：references 和 templates（project level）
  Download-File "$RepoUrl/references/mvp-bootstrap.md"         ".claude\references\mvp-bootstrap.md"
  Download-File "$RepoUrl/references/function-doc-workflow.md" ".claude\references\function-doc-workflow.md"
  Download-File "$RepoUrl/templates/function-doc.md"           ".claude\templates\function-doc.md"
  Write-Host "  OK References -> .claude\references\"
  Write-Host "  OK Templates  -> .claude\templates\"

  $claudeMd = ".claude\CLAUDE.md"
  $marker   = "ITERATIVE_DEV_RULE v2.0"

  if (Test-Path $claudeMd) {
    $content = Get-Content $claudeMd -Raw
    if ($content -match [regex]::Escape($marker)) {
      Write-Host "  INFO $claudeMd already has iterative-dev rules, skipping."
    } else {
      $append = @"

<!-- ITERATIVE_DEV_RULE v2.0 START — auto-appended, do not delete -->
# Iterative Development Rules
> See .claude/rules/common/iterative-dev.md for full rules.
<!-- ITERATIVE_DEV_RULE v2.0 END -->
"@
      Add-Content -Path $claudeMd -Value $append
      Write-Host "  OK Appended iterative-dev rules to $claudeMd"
    }
  } else {
    $create = @"
# CLAUDE.md — Project Rules

<!-- ITERATIVE_DEV_RULE v2.0 START -->
# Iterative Development Rules
This project uses iterative development mode.
> Full rules: .claude/rules/common/iterative-dev.md
<!-- ITERATIVE_DEV_RULE v2.0 END -->
"@
    if (-not (Test-Path ".claude")) { New-Item -ItemType Directory -Path ".claude" -Force | Out-Null }
    Set-Content -Path $claudeMd -Value $create
    Write-Host "  OK Created $claudeMd with iterative-dev rules"
  }
}

# ── VS Code Copilot ───────────────────────────────────────────────────────────
if ($Copilot) {
  Write-Host ""
  Write-Host "▶ Installing VS Code Copilot instructions..."

  if (-not (Test-Path ".github")) { New-Item -ItemType Directory -Path ".github" -Force | Out-Null }
  Download-File "$RepoUrl/copilot-instructions.md" ".github\copilot-instructions.md"
  Write-Host "  OK Copilot instructions -> .github\copilot-instructions.md"

  if (-not (Test-Path ".vscode")) { New-Item -ItemType Directory -Path ".vscode" -Force | Out-Null }
  $vsSettings = ".vscode\settings.json"
  if (-not (Test-Path $vsSettings)) {
    $vscode = @'
{
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "file": "${workspaceFolder}/.github/copilot-instructions.md"
    }
  ]
}
'@
    Set-Content -Path $vsSettings -Value $vscode
    Write-Host "  OK Created .vscode\settings.json"
  } else {
    Write-Host "  INFO .vscode\settings.json already exists."
    Write-Host "       Add manually: github.copilot.chat.codeGeneration.instructions"
  }
}

Write-Host ""
Write-Host "Installation complete!"
Write-Host ""
Write-Host "Next steps:"
if ($Global)  { Write-Host "  Claude Code CLI: type /iterative-dev to activate" }
if ($Copilot) { Write-Host "  VS Code Copilot: restart VS Code, then use Copilot Chat" }
Write-Host ""
Write-Host "Docs: https://github.com/stevenke1981/iterative-dev-skill"
