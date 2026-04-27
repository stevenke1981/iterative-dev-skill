# Function Doc Workflow

> **Purpose**: Step-by-step guide for scanning functions in an app and generating
> per-function markdown documentation with bidirectional knowledge graph links.

---

## When to Use

- After implementing a new function or module
- When user requests "generate function docs" / "document all functions"
- As part of MVP Bootstrap (after scaffold is created)
- When onboarding a new codebase

---

## Step-by-Step Workflow

### Step 1 — Identify Target Scope

Determine what to scan:
- **Single file**: `src/utils.py` → document all functions in that file
- **Directory**: `src/` → document all functions recursively
- **Single function**: user pastes code → document that one function
- **Entire project**: scan all source files (exclude `node_modules`, `__pycache__`, `.git`)

Common patterns to detect functions:
| Language | Pattern |
|----------|---------|
| Python | `def function_name(` |
| JavaScript/TypeScript | `function name(`, `const name = (`, `async function` |
| Go | `func name(` |
| Rust | `fn name(` |
| Java/Kotlin | `public/private/protected ... methodName(` |

### Step 2 — Check Existing Docs

Before generating, check `docs/functions/` for existing docs:
- If `<FunctionName>.md` exists → **update** (diff only, not rewrite)
- If not exists → **create** from `templates/function-doc.md`

```
docs/functions/
├── _index.md      ← check this first for full inventory
└── *.md           ← existing function docs
```

### Step 3 — Generate / Update Each Function Doc

For each function found:

1. Copy `templates/function-doc.md`
2. Fill in ALL `{{Placeholder}}` values:
   - `{{FunctionName}}` — exact function name
   - `{{FilePath}}` — relative path from project root
   - `{{ModuleName}}` — parent module/class name
   - `{{Version}}` — current version (from ITERATIVE_DEV_CORE.md or default `v1.0`)
   - `{{Language}}` — programming language
   - `{{FunctionSignature}}` — complete signature with types
   - `{{Description}}` — what this function does (1–3 sentences)
   - Parameters table — one row per parameter
   - Returns table — return type and description
   - Examples — at least one basic usage example
   - Knowledge Graph section — fill in known callers/callees (leave unknown as `—`)
3. Save to `docs/functions/<FunctionName>.md`

### Step 4 — Update `_index.md`

After generating each doc, append a row to the index table in `docs/functions/_index.md`:

```markdown
| `FunctionName` | `ModuleName` | `src/path/to/file.py` | One-line description | [📄](FunctionName.md) |
```

If `_index.md` does not exist, create it first using the MVP Bootstrap template.

Apply **diff only** — add rows, never rewrite the whole table.

### Step 5 — Update `knowledge_graph.md`

For each new function doc created:

1. Add a **node**:
```markdown
| N{next_id} | function | {FunctionName} | {FilePath} | {Description} |
```

2. Add **relations** (minimum required):
```markdown
| {FunctionName} | has_doc | docs/functions/{FunctionName}.md | 函式說明文件 |
| {ParentModule} | has_function | {FunctionName} | 所屬模組 |
| {FunctionName} | belongs_to | {ParentModule} | 反向所屬 |
```

3. Add **call relations** (if analyzable from code):
```markdown
| {CallerFunction} | calls | {FunctionName} | 呼叫關係 |
| {FunctionName} | called_by | {CallerFunction} | 反向呼叫 |
```

Apply **diff only** — append rows to existing tables.

### Step 6 — Output Confirmation

After completing all docs, output the summary:

```
【Function Docs Generated】
Scope: {target scope}
Generated:
  - docs/functions/{Fn1}.md → 新建
  - docs/functions/{Fn2}.md → 更新 (v1.1)
  - docs/functions/_index.md → 更新 (+{n} 筆)
Knowledge Graph:
  - 新增節點: {n} 個
  - 新增關係: {m} 條
```

---

## Batch Processing Order

When documenting multiple functions, process in this order:
1. **Utility / helper functions** (no dependencies on other project functions)
2. **Data model functions** (constructors, validators)
3. **Business logic functions** (depend on utilities/models)
4. **Entry points / handlers** (depend on everything else)

This ensures that when you document callers, the callees already have docs to link to.

---

## Gotchas

- **Never rewrite** an existing function doc — only diff-update changed sections.
- **`_index.md` is auto-maintained** — do not manually edit rows that the skill manages.
- **Anonymous / lambda functions** — skip unless they are assigned to a named variable.
- **Overloaded methods** — create a single doc covering all overloads; list each in the Parameters section with a `Variant` column.
- **Private / internal functions** (prefixed `_` in Python, lowercase in Go) — document them too; add `🔒 Internal` tag in the index.
- When `knowledge_graph.md` grows large, use `grep` to find the last node ID before adding new ones (avoid duplicate IDs).

---

## References

- [Function Doc Template](../templates/function-doc.md)
- [MVP Bootstrap Workflow](./mvp-bootstrap.md)
- [Function Docs Rules](../rules/common/function-docs.md)
