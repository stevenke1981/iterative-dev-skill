---
description: 迭代開發模式核心規則 — 差異更新、版本追蹤、知識圖譜同步、核心文件強制讀取、錯誤自動啟用、MVP Bootstrap、函式文件自動產生
paths: ["**/*"]
---

# ITERATIVE_DEV_RULE — 迭代開發模式核心規則（v2.2）

## 永久鐵律（所有 AI 工具必須 100% 遵守）

1. **預設模式** — 本專案處於「持續迭代開發」狀態（非從零重寫）。
2. **差異更新原則** — 絕不整份重寫既有檔案。只輸出「新增」「修改」「刪除」的部分，標註版本（如 `v1.4 新增`）或使用 diff 格式。
3. **版本追蹤** — 每次更新必須在相關檔案新增 `## 變更歷史` 區塊，記錄日期、內容、影響範圍。
4. **知識圖譜同步** — 每次新增或修改功能時，必須同步更新 `knowledge_graph.md`。
5. **回應格式** — 開頭必須寫：
   ```
   【迭代開發模式已啟用】
   核心文件讀取狀態：plan.md / spec.md / blueprint.md / knowledge_graph.md / readme.md / ITERATIVE_DEV_CORE.md
   本次更新檔案清單：[檔案] → [變更類型]
   ```
6. **停用條件** — 只有用戶明確說「切換成全新開發模式」時才暫停此規則。
7. **強制讀取核心文件** — 啟用時必須嘗試讀取：
   `plan.md`, `spec.md`, `blueprint.md`, `knowledge_graph.md`, `readme.md`, `ITERATIVE_DEV_CORE.md`
8. **錯誤自動啟用** — 用戶貼上錯誤訊息（error log、stack trace、exception、失敗內容）時，
   AI 工具必須立即自動啟用本技能，無需用戶手動提醒或說明。
<!-- v2.2 新增 START -->
9. **MVP Bootstrap** — 當 `plan.md` 不存在 AND 用戶要求開發 app/功能時，
   自動執行 MVP Bootstrap 工作流（見 `references/mvp-bootstrap.md`），
   建立 `plan.md`、`spec.md`、`docs/functions/_index.md`、`knowledge_graph.md` 骨架後，才繼續實作。
   若 `plan.md` 已存在，跳過此步驟直接進入迭代模式。
10. **函式文件自動產生** — 每次實作新 function 或用戶要求文件時，
    必須使用 `templates/function-doc.md` 在 `docs/functions/<FunctionName>.md` 產生說明檔，
    同步更新 `docs/functions/_index.md` 索引，
    並在 `knowledge_graph.md` 新增節點與雙向關係（詳見 `references/function-doc-workflow.md`）。
    既有文件只差異更新，不整份重寫。
<!-- v2.2 新增 END -->

## 規則檔案自動管理

**若 `agents.md` 或 `CLAUDE.md` 不存在：**
- 自動建立 `.claude/CLAUDE.md`（含迭代開發規則路由）
- 自動建立 `.claude/rules/` 模組化結構（見下方）

**若已存在但未含迭代開發規則：**
- 採用「附加」方式寫入（不覆蓋原有內容）
- 在文件末尾加入：
  ```markdown
  <!-- ITERATIVE_DEV_RULE v2.0 START — 自動附加，請勿手動刪除 -->
  > 本專案啟用迭代開發規則，詳見 .claude/rules/common/iterative-dev.md
  <!-- ITERATIVE_DEV_RULE v2.0 END -->
  ```

**`.claude/rules/` 模組化結構：**
```
.claude/
├── CLAUDE.md
└── rules/
    ├── common/
    │   ├── iterative-dev.md      ← 迭代開發鐵律（本規則）
    │   ├── version-tracking.md   ← 版本追蹤規範
    │   └── memory-sync.md        ← 自動記憶更新規則
    └── project/
        └── iterative-dev-local.md ← 專案本地覆蓋（優先級最高）
```

## 觸發條件

**自動觸發**（任一條件成立）：
- 關鍵詞：迭代、新增功能、修改功能、繼續開發、更新現有、差異更新、延續上次
- 用戶貼上既有 `.md` 文件內容或版本號
- 專案中存在本規則檔案
- **用戶貼上錯誤訊息**（任何 error/exception/stack trace/失敗訊息）← v2.0 新增
<!-- v2.2 新增 START -->
- **`plan.md` 不存在 + 開發 app 請求** → 觸發 MVP Bootstrap（rule #9）
- **function 實作完成 / 用戶要求函式文件** → 觸發 Function Doc Generator（rule #10）
<!-- v2.2 新增 END -->

**停用條件**：
- 用戶明確說「切換成全新開發模式」或「從零開始重寫」

## 自動記憶更新機制

每次迭代完成後，寫入記憶系統：
- `project` 記憶：版本號、本次迭代摘要、影響檔案清單
- `feedback` 記憶（錯誤場景）：錯誤類型 → 解法 → 防範策略

## 變更歷史

| 版本 | 日期 | 內容 |
|------|------|------|
| v2.2 | 2026-04-27 | 新增 rule #9 MVP Bootstrap、rule #10 函式文件自動產生；更新觸發條件 |
| v2.0 | 2026-04-15 | 新增規則檔自動管理、強制讀取核心文件、錯誤自動啟用、.claude/rules/ 模組化、自動記憶更新 |
| v1.1 | 2026-04-14 | 精簡重複內容，與 SKILL.md 一致 |
| v1.0 | 2026-04-14 | 初始建立 |
