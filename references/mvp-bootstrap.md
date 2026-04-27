# MVP Bootstrap Workflow

> **Purpose**: When `plan.md` does not exist and the user requests app development,
> automatically scaffold a Minimum Viable Prototype so iterative development can begin immediately.

---

## When to Trigger

Trigger this workflow when **ALL** of the following are true:
1. `plan.md` is **missing** (not yet created in project root)
2. User request involves building / creating an app, feature, or module
3. User has NOT said "start from scratch" or "greenfield mode"

**Do NOT trigger** if `plan.md` already exists — use iterative update instead.

---

## Step-by-Step Workflow

### Step 1 — Gather Requirements (1 minute)

Ask or infer from context:
- What is the app name?
- What is the primary language / framework?
- What are the 3–5 core features for MVP?
- Any existing constraints (auth, DB, API, platform)?

If context is insufficient, ask the user one focused question before proceeding.

### Step 2 — Create `plan.md` (MVP skeleton)

Create `plan.md` in the project root with this structure:

```markdown
# Plan — {{AppName}} MVP

## Problem Statement
{{OneSentenceDescription}}

## MVP Scope (v1.0)
### In Scope
- [ ] Feature A
- [ ] Feature B
- [ ] Feature C

### Out of Scope (v2+)
- Feature D (post-MVP)

## Architecture Overview
- Language: {{Language}}
- Framework: {{Framework}}
- Data store: {{DataStore}}

## Milestones
| Milestone | Description | Status |
|-----------|-------------|--------|
| M1 | Project scaffold + core models | pending |
| M2 | Core feature implementation | pending |
| M3 | Testing + polish | pending |

## Changelog
| Version | Date | Content |
|---------|------|---------|
| v1.0 | {{Date}} | Initial MVP plan |
```

### Step 3 — Create `spec.md` (technical spec skeleton)

Create `spec.md` in the project root:

```markdown
# Technical Spec — {{AppName}}

## Data Structures
<!-- Define core models / types -->

## API / Interface
<!-- Define function signatures, endpoints, or CLI commands -->

## Logic Flow
<!-- Text description or Mermaid diagram -->

## Changelog
| Version | Date | Content |
|---------|------|---------|
| v1.0 | {{Date}} | Initial spec skeleton |
```

### Step 4 — Create `docs/functions/_index.md` (function registry)

Create the function documentation index:

```markdown
# Function Index — {{AppName}}

> Auto-maintained by iterative-dev skill.  
> Each entry links to its dedicated `docs/functions/<FunctionName>.md`.

## Index

| Function | Module | File | Description | Doc |
|----------|--------|------|-------------|-----|
| *(none yet)* | — | — | — | — |

## Changelog
| Version | Date | Content |
|---------|------|---------|
| v1.0 | {{Date}} | Index initialized by MVP Bootstrap |
```

### Step 5 — Create `knowledge_graph.md` (if missing)

Create initial `knowledge_graph.md`:

```markdown
# Knowledge Graph — {{AppName}}

> Auto-maintained by iterative-dev skill.  
> Nodes = modules/functions. Relations = directional dependencies.

## Nodes

| ID | Type | Name | File | Description |
|----|------|------|------|-------------|
| N01 | module | {{AppName}} | — | Root application module |

## Relations

| From | Relation | To | Note |
|------|----------|----|------|
| *(none yet)* | — | — | — |

## Changelog
| Version | Date | Content |
|---------|------|---------|
| v1.0 | {{Date}} | Initial graph — MVP Bootstrap |
```

### Step 6 — Output Summary

After creating all files, output:

```
【MVP Bootstrap Complete】
Files created:
- plan.md           → MVP plan skeleton
- spec.md           → Technical spec skeleton
- docs/functions/_index.md → Function registry (empty)
- knowledge_graph.md → Knowledge graph (initialized)

Next step: Start implementing features. Each new function → run Function Doc Generator.
```

---

## Gotchas

- **Never overwrite** an existing `plan.md` — always check first.
- Only create skeleton content — do **not** fill in implementation details at this stage.
- `docs/functions/` directory must be created even if empty.
- After MVP Bootstrap, the next response should already be in iterative mode (plan.md now exists).

---

## References

- [Function Doc Workflow](./function-doc-workflow.md)
- [Function Doc Template](../templates/function-doc.md)
