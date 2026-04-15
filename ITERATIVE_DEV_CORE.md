# ITERATIVE_DEV_CORE — 迭代開發核心參考文件（v2.0）

> 本文件為迭代開發技能的「核心錨點文件」。
> 所有 AI 工具啟用迭代開發模式時，必須首先讀取本文件。

## 本文件用途

- 作為專案迭代狀態的「真相來源」（Single Source of Truth）
- 紀錄當前版本號、已完成功能、進行中功能、已知問題
- 供 AI 工具在每次迭代前確認現狀，避免重複工作或衝突

## 當前迭代狀態

```yaml
project_name: [專案名稱]
current_version: v1.0
iteration_mode: active
last_updated: 2026-04-15
core_files:
  - plan.md
  - spec.md
  - blueprint.md
  - knowledge_graph.md
  - readme.md
  - ITERATIVE_DEV_CORE.md
```

## 已完成功能（Do Not Rewrite）

> 列出已完成且穩定的功能，AI 工具不得整份重寫這些部分。

| 功能 | 版本 | 狀態 | 備註 |
|------|------|------|------|
| 初始化本文件 | v1.0 | 完成 | |

## 進行中功能

| 功能 | 版本 | 狀態 | 負責人 |
|------|------|------|--------|
| — | — | — | — |

## 已知問題與待修

| 問題 | 優先級 | 狀態 | 關聯版本 |
|------|--------|------|----------|
| — | — | — | — |

## 核心規則路由

本文件適用以下規則（依優先級排序）：

1. `.claude/rules/project/iterative-dev-local.md` ← 最高優先（專案本地覆蓋）
2. `.claude/rules/common/iterative-dev.md` ← 通用迭代開發規則
3. `D:\ITERATIVE_DEV_SKILL\ITERATIVE_DEV_RULE.md` ← 技能層規則
4. `D:\ITERATIVE_DEV_SKILL\SKILL.md` ← 技能執行邏輯

## 變更歷史

| 版本 | 日期 | 內容 |
|------|------|------|
| v1.0 | 2026-04-15 | 初始建立 |
