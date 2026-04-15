---
description: 迭代開發模式核心規則 — 差異更新、版本追蹤、知識圖譜同步、核心文件強制讀取、錯誤自動啟用
paths: ["**/*"]
---

# ITERATIVE_DEV_RULE — 迭代開發模式核心規則（v2.0）

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

## 強制讀取核心文件（v2.0 新增）

啟用迭代開發模式時，AI 工具必須依序嘗試讀取下列文件：

| 文件 | 用途 | 不存在時 |
|------|------|---------|
| `ITERATIVE_DEV_CORE.md` | 迭代狀態總覽、版本號、功能清單 | 提示可初始化 |
| `plan.md` | 功能規劃與里程碑 | 記錄「不存在」，繼續執行 |
| `spec.md` | 技術規格 | 同上 |
| `blueprint.md` | 系統架構藍圖 | 同上 |
| `knowledge_graph.md` | 知識圖譜 | 記錄「不存在」，Step 4 自動建立 |
| `readme.md` / `README.md` | 專案說明 | 同上 |

## 規則檔案自動管理（v2.0 新增）

**若 `agents.md` 或 `CLAUDE.md` 不存在：**
- 自動建立 `.claude/CLAUDE.md`（含迭代開發規則路由）
- 自動建立 `.claude/rules/` 模組化目錄結構

**若已存在但未含迭代開發規則：**
- 採用「附加」方式（不覆蓋原有內容）
- 在文件末尾加入：
  ```markdown
  <!-- ITERATIVE_DEV_RULE v2.0 START — 自動附加，請勿手動刪除 -->
  > 本專案啟用迭代開發規則，詳見 .claude/rules/common/iterative-dev.md
  <!-- ITERATIVE_DEV_RULE v2.0 END -->
  ```

**`.claude/rules/` 模組化結構：**
```
.claude/
├── CLAUDE.md                         ← 主規則入口（路由到各模組）
└── rules/
    ├── common/
    │   ├── iterative-dev.md          ← 迭代開發鐵律（本文件）
    │   ├── version-tracking.md       ← 版本追蹤規範
    │   └── memory-sync.md            ← 自動記憶更新規則
    └── project/
        └── iterative-dev-local.md   ← 專案本地覆蓋（最高優先級）
```

## 錯誤自動啟用（v2.0 新增）

**當用戶貼上以下任何內容時，AI 工具必須自動啟用迭代開發技能，無需用戶手動提醒：**

- 錯誤訊息（Error:、Exception:、錯誤：、失敗：）
- Stack trace / Traceback
- 執行後的失敗輸出（exit code 非 0）
- 測試失敗報告（FAILED、FAIL、AssertionError）
- 建置錯誤（Build failed、Compilation error）

啟用後的處理路徑：
1. 讀取核心文件（Step 1）
2. 定位錯誤根因（差異分析優先）
3. 輸出精準 patch（Step 3）
4. 更新 knowledge_graph.md（Step 4）
5. 記錄錯誤解法至自動記憶（Step 6）

## 自動記憶更新機制（v2.0 新增）

每次迭代完成後，自動寫入記憶系統（`~/.claude/projects/` 記憶檔）：

- `project` 記憶：版本號、本次迭代摘要、影響檔案清單
- `feedback` 記憶（錯誤場景）：錯誤類型 → 解法 → 防範策略，供未來對話使用

## 觸發條件

**自動觸發**（任一條件成立）：
- 關鍵詞：迭代、新增功能、修改功能、繼續開發、更新現有、差異更新、延續上次
- 用戶貼上既有 `.md` 文件內容或版本號
- 專案中存在本規則檔案或 `ITERATIVE_DEV_CORE.md`
- **用戶貼上錯誤訊息**（任何 error/exception/stack trace/失敗訊息）← v2.0 新增

**停用條件**：
- 用戶明確說「切換成全新開發模式」或「從零開始重寫」

## 變更歷史

| 版本 | 日期 | 內容 |
|------|------|------|
| v2.0 | 2026-04-15 | 強制讀取核心文件、規則檔自動管理、錯誤自動啟用、.claude/rules/ 模組化、自動記憶更新 |
| v1.1 | 2026-04-14 | 精簡重複內容，與 SKILL.md 一致 |
| v1.0 | 2026-04-14 | 初始建立 |
