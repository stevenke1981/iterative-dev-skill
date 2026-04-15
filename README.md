# iterative-dev-skill

> **迭代開發模式技能 v2.0** — 適用於 Claude Code CLI 與 VS Code Copilot  
> 強制差異更新 · 版本追蹤 · 知識圖譜同步 · 錯誤自動啟用

---

## 什麼是迭代開發技能？

當你的專案處於「持續迭代、中途新增/修改功能」狀態時，這個技能讓 AI 工具：

- **永遠不整份重寫** 既有檔案（只輸出 diff）
- **強制讀取** `plan.md`, `spec.md`, `blueprint.md` 等核心文件
- **自動追蹤版本** 並維護 `knowledge_graph.md`
- **貼上錯誤訊息就自動啟用**，無需手動提醒

---

## 安裝方式

### 方式一：一鍵安裝腳本（推薦）

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/stevenke1981/iterative-dev-skill/main/install.sh | bash
```

**Windows PowerShell:**
```powershell
irm https://raw.githubusercontent.com/stevenke1981/iterative-dev-skill/main/install.ps1 | iex
```

---

### 方式二：Claude Code CLI 手動安裝

#### 步驟 1 — 安裝技能檔

```bash
# 建立技能目錄
mkdir -p ~/.claude/skills/iterative-dev

# 複製技能主檔
cp SKILL.md ~/.claude/skills/iterative-dev/SKILL.md
cp ITERATIVE_DEV_CORE.md ~/.claude/skills/iterative-dev/ITERATIVE_DEV_CORE.md
```

#### 步驟 2 — 安裝規則檔

```bash
# 建立規則目錄
mkdir -p ~/.claude/rules/common

# 複製規則檔
cp rules/common/iterative-dev.md ~/.claude/rules/common/iterative-dev.md
cp rules/common/version-tracking.md ~/.claude/rules/common/version-tracking.md
cp rules/common/memory-sync.md ~/.claude/rules/common/memory-sync.md
```

#### 步驟 3 — 加入 CLAUDE.md 路由（可選）

在你的專案根目錄建立或附加 `.claude/CLAUDE.md`：

```bash
mkdir -p .claude
cat >> .claude/CLAUDE.md << 'EOF'

<!-- ITERATIVE_DEV_RULE v2.0 START -->
# Iterative Development Rules
> Rules location: ~/.claude/rules/common/iterative-dev.md
> Skill location: ~/.claude/skills/iterative-dev/SKILL.md
<!-- ITERATIVE_DEV_RULE v2.0 END -->
EOF
```

#### 步驟 4 — 驗證安裝

在 Claude Code CLI 中輸入：
```
/iterative-dev
```

應看到：
```
【迭代開發模式已啟用 - v2.0】
核心文件讀取狀態：...
```

---

### 方式三：VS Code Copilot 安裝

#### 選項 A — 專案層級（推薦，只影響當前專案）

在專案根目錄建立 `.github/copilot-instructions.md`：

```bash
mkdir -p .github
cp copilot-instructions.md .github/copilot-instructions.md
```

或手動建立 `.github/copilot-instructions.md`，貼入以下內容：

```markdown
# Copilot 迭代開發規則

## 鐵律
1. 本專案處於「持續迭代開發」狀態，禁止整份重寫既有檔案。
2. 只輸出「新增」「修改」「刪除」的 diff 部分，標註版本號。
3. 每次修改前，嘗試讀取：plan.md / spec.md / blueprint.md / knowledge_graph.md / readme.md
4. 每次修改後，在相關檔案新增 `## 變更歷史` 區塊。
5. 貼上錯誤訊息時，自動定位根因並輸出 patch，不重寫整個檔案。

## 回應開頭格式
每次回應開頭必須輸出：
【迭代開發模式已啟用】
核心文件讀取狀態：[已讀取/不存在]
本次更新：[檔案] → [變更類型]

## 停用條件
只有用戶說「從零開始重寫」才暫停此規則。
```

#### 選項 B — 全域 Copilot 指令（影響所有專案）

1. 開啟 VS Code 設定（`Ctrl+,` / `Cmd+,`）
2. 搜尋 `github.copilot.chat.codeGeneration.instructions`
3. 點擊「在 settings.json 中編輯」
4. 加入：

```json
{
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "file": "${workspaceFolder}/.github/copilot-instructions.md"
    }
  ]
}
```

或直接內嵌規則（無需外部檔案）：

```json
{
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "text": "This project uses iterative development. Never rewrite entire files. Only output diff sections with version labels. Always try to read plan.md, spec.md, blueprint.md before making changes. When user pastes error messages, automatically locate root cause and output minimal patch."
    }
  ]
}
```

#### 選項 C — VS Code Workspace 設定

建立或編輯 `.vscode/settings.json`：

```json
{
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "file": "${workspaceFolder}/.github/copilot-instructions.md"
    }
  ],
  "github.copilot.chat.reviewSelection.instructions": [
    {
      "text": "Review code with iterative development principles: check version tracking, knowledge graph updates, and diff-only output compliance."
    }
  ]
}
```

---

## 檔案結構說明

```
iterative-dev-skill/
├── README.md                         ← 本安裝說明
├── SKILL.md                          ← Claude Code 技能主檔
├── ITERATIVE_DEV_RULE.md             ← 規則宣告檔（含 frontmatter）
├── ITERATIVE_DEV_CORE.md             ← 迭代狀態錨點文件（複製到專案根目錄）
├── copilot-instructions.md           ← VS Code Copilot 指令（直接複製使用）
├── install.sh                        ← macOS/Linux 一鍵安裝
├── install.ps1                       ← Windows PowerShell 一鍵安裝
├── rules/
│   └── common/
│       ├── iterative-dev.md          ← 迭代開發鐵律
│       ├── version-tracking.md       ← 版本追蹤規範
│       └── memory-sync.md            ← 自動記憶同步規則
└── .vscode/
    └── settings.json.example         ← VS Code 設定範例
```

---

## 核心功能

### 1. 差異更新鐵律
```diff
## plan.md — v1.3 差異更新

+ - [ ] 新功能 A（v1.3 新增）
  - [x] 既有功能（不變）
- 舊描述（v1.2 已廢棄）
```

### 2. 強制讀取核心文件
每次啟用時自動讀取（存在則讀、不存在則記錄）：
`ITERATIVE_DEV_CORE.md` → `plan.md` → `spec.md` → `blueprint.md` → `knowledge_graph.md` → `readme.md`

### 3. 錯誤自動啟用
貼上任何錯誤訊息 → 自動啟用迭代開發模式 → 定位根因 → 輸出最小 patch

### 4. 知識圖譜同步
每次新增功能時，自動更新 `knowledge_graph.md` 節點與關係。

### 5. 自動記憶更新
迭代完成後自動寫入記憶系統（Claude Code），供未來對話使用。

---

## 觸發關鍵詞

| 關鍵詞 | 說明 |
|--------|------|
| 迭代、繼續開發、延續上次 | 一般迭代觸發 |
| 新增功能、修改功能 | 功能迭代觸發 |
| 差異更新、不要從零開始 | 明確差異觸發 |
| 任何錯誤訊息 / stack trace | 錯誤自動觸發 |
| 貼上 .md 文件 / 版本號 | 文件迭代觸發 |

---

## 版本歷史

| 版本 | 日期 | 內容 |
|------|------|------|
| v2.0 | 2026-04-15 | 規則檔自動管理、強制讀取核心文件、錯誤自動啟用、模組化規則、自動記憶更新 |
| v1.1 | 2026-04-14 | 合併 Hook 邏輯、優化輸出格式 |
| v1.0 | 2026-04-14 | 初始建立 |

---

## License

MIT License — 自由使用、修改、分享。
