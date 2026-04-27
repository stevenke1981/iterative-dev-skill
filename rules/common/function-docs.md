---
description: 函式文件規則 — 為每個 function 自動產生 markdown 說明檔、維護 _index.md、雙向更新 knowledge_graph.md
paths: ["**/*"]
---

# FUNCTION_DOCS_RULE — 函式文件規則（v1.0）

## 觸發條件

**自動觸發**（任一成立）：
- 用戶說「為函式產生文件」「說明這個函式」「為每個 function 建立說明」「function doc」
- 新功能實作完成後（Step 4 後自動追加）
- 用戶貼上含有 function/method 定義的程式碼

**不觸發**：
- 僅討論架構設計、不涉及具體 function 實作

---

## 資料夾規範

```
docs/
└── functions/
    ├── _index.md              ← 函式索引（自動維護，不手動編輯）
    └── <FunctionName>.md      ← 每個函式的獨立說明檔
```

### 命名規則

| 語言 | function 名稱 | 檔案名稱 |
|------|-------------|---------|
| Python | `snake_case` | `snake_case.md` |
| JavaScript / TypeScript | `camelCase` | `camelCase.md` |
| Go / Rust | `snake_case` | `snake_case.md` |
| 類別方法 | `ClassName.methodName` | `ClassName.methodName.md` |

---

## 產生規則

### 1. 新建函式文件
- 使用 `templates/function-doc.md` 作為模板
- 取代所有 `{{Placeholder}}`
- 儲存至 `docs/functions/<FunctionName>.md`

### 2. 更新已存在的函式文件
- **差異更新原則**：絕不整份重寫
- 只更新「有變化」的區塊（Signature / Parameters / Returns）
- 在 `## Changelog` 新增一行記錄

### 3. 維護 `_index.md`
每次新增或修改 function doc 後，同步更新 `_index.md` 的 Index 表格：

```markdown
| FunctionName | ModuleName | src/module.py | 功能摘要 | [📄](FunctionName.md) |
```

---

## 知識圖譜雙向連結規則

每次建立或更新函式文件後，必須在 `knowledge_graph.md` 同步：

### 新增節點
```markdown
| N{id} | function | {FunctionName} | {FilePath} | {Description} |
```

### 新增關係（雙向）
```markdown
| {FunctionName} | has_doc | docs/functions/{FunctionName}.md | 說明文件 |
| {ParentModule} | has_function | {FunctionName} | 所屬模組 |
| {FunctionName} | belongs_to | {ParentModule} | 所屬模組（反向） |
```

**呼叫關係（若可分析）：**
```markdown
| {CallerFunction} | calls | {FunctionName} | 呼叫關係 |
| {FunctionName} | called_by | {CallerFunction} | 反向呼叫 |
```

---

## 輸出格式規範

產生函式文件後，輸出確認：

```
【Function Doc Generated】
- docs/functions/{FunctionName}.md → 新建 / 更新（v{x}）
- docs/functions/_index.md → 更新（新增 1 筆）
- knowledge_graph.md → 新增節點 N{id}，新增 {n} 條關係
```

---

## 變更歷史

| 版本 | 日期 | 內容 |
|------|------|------|
| v1.0 | 2026-04-27 | 初始建立 |
