# Phase 3 Research: Subagent Integration

**Phase**: 3 - Subagent Integration
**Created**: 2026-01-20
**Research Level**: 2 (Standard Research)

---

## Research Question

How to implement Kiro subagents for high-context operations in GSD workflows?

---

## Findings

### 1. Subagent Purpose

**Problem**: Operations like `/map` and `/research-phase` consume massive context:
- Reading 20+ files
- Analyzing architecture
- Searching documentation
- All this "noise" pollutes main conversation

**Solution**: Subagents with `context: fork`
- Run in separate context window
- Have their own conversation history
- Only summary returns to main conversation
- Context is destroyed after completion

### 2. Subagent Types (from resarch/subagents.md)

**Built-in Subagents**:
- `Explore`: Fast, read-only codebase exploration (Haiku model)
- `Plan`: Research during plan mode (read-only)
- `general-purpose`: Full capabilities for complex tasks

**Custom Subagents** (what we'll create):
- Defined in `.kiro/agents/` directory
- Markdown files with YAML frontmatter
- Can specify tools, model, permissions
- Can include hooks scoped to subagent

### 3. Subagent Configuration

```yaml
---
name: subagent-name
description: When to use this subagent
tools: Read, Grep, Glob
disallowedTools: Write, Edit
model: sonnet | haiku | opus | inherit
permissionMode: default | plan | dontAsk
context: fork
---

# Subagent Name

System prompt for the subagent.
Instructions on what to do and how to report results.
```

### 4. Context Fork Pattern

**Without context:fork** (normal):
- Subagent shares main conversation
- All reads/searches visible in main context
- Context window fills quickly

**With context:fork**:
- Subagent gets fresh context
- Reads/searches happen in fork
- Only final result returns
- Fork is destroyed

**Example**:
```
Main: "Analyze this codebase"
  ↓
Fork: [reads 50 files, analyzes patterns]
  ↓
Main: Receives summary (200 tokens instead of 50,000)
```

### 5. GSD Operations for Subagents

Based on ROADMAP and research:

**Priority 1 (Must-have)**:
1. **map-explorer**: For `/map` command (codebase analysis)
2. **research-agent**: For `/research-phase` command
3. **verify-agent**: For `/verify` command (parallel verification)

**Why these operations**:
- `/map`: Reads entire codebase, analyzes architecture
- `/research-phase`: Reads docs, searches web, analyzes libraries
- `/verify`: Runs multiple verifications in parallel

### 6. Subagent Tool Restrictions

**map-explorer**:
- Tools: Read, Grep, Glob, Bash (read-only commands)
- Disallowed: Write, Edit
- Model: Haiku (fast, cheap for exploration)
- Permission: plan (read-only mode)

**research-agent**:
- Tools: Read, Grep, WebSearch, WebFetch
- Disallowed: Write, Edit
- Model: Sonnet (needs reasoning for research)
- Permission: default

**verify-agent**:
- Tools: Read, Bash (for running tests/linters)
- Disallowed: Write, Edit
- Model: Haiku (fast verification)
- Permission: dontAsk (auto-deny prompts)

### 7. Integration with GSD Workflows

**Update workflows to use subagents**:

`/map` workflow:
```markdown
## 2. Analyze Codebase

Use map-explorer subagent:
- Reads all source files
- Identifies tech stack
- Analyzes architecture patterns
- Detects technical debt
- Returns summary to ARCHITECTURE.md
```

`/research-phase` workflow:
```markdown
## 2. Conduct Research

Use research-agent subagent:
- Searches documentation
- Analyzes libraries
- Compares alternatives
- Returns findings to RESEARCH.md
```

`/verify` workflow:
```markdown
## 2. Run Verifications

Use verify-agent subagent (parallel):
- Agent 1: Run unit tests
- Agent 2: Check code coverage
- Agent 3: Run linters
- Consolidate results
```

### 8. Subagent Lifecycle

1. **Invocation**: Claude delegates task to subagent
2. **Fork**: New context created (if context:fork)
3. **Execution**: Subagent works independently
4. **Completion**: Summary returned to main
5. **Cleanup**: Fork destroyed

### 9. Resuming Subagents

Subagents can be resumed:
```
User: "Use map-explorer to analyze auth module"
[Subagent completes, returns agent ID]

User: "Continue that analysis for payment module"
[Claude resumes same subagent with full history]
```

Transcripts stored in: `~/.claude/projects/{project}/{session}/subagents/agent-{id}.jsonl`

---

## Recommendations

### Phase 3 Implementation Strategy

**Wave 1: Foundation**
- Create `.kiro/agents/` directory structure
- Create subagent template
- Document subagent usage

**Wave 2: Core Subagents**
- Implement map-explorer subagent
- Implement research-agent subagent
- Implement verify-agent subagent

**Wave 3: Integration**
- Update GSD workflows to use subagents
- Test with real operations
- Document when to use subagents vs main conversation

### Subagent Organization

```
.kiro/agents/
├── README.md
├── map-explorer.md
├── research-agent.md
└── verify-agent.md
```

### Testing Strategy

1. Test map-explorer with real codebase
2. Verify context savings (main conversation stays clean)
3. Test research-agent with web searches
4. Test verify-agent with parallel execution
5. Measure context window usage before/after

---

## Open Questions

1. Should subagents be project-level or user-level?
   - **Recommendation**: Project-level (`.kiro/agents/`)
   - Reason: Team shares same subagent configurations

2. What model for each subagent?
   - **map-explorer**: Haiku (fast, cheap exploration)
   - **research-agent**: Sonnet (needs reasoning)
   - **verify-agent**: Haiku (fast verification)

3. How to handle subagent failures?
   - **Recommendation**: Subagent reports error to main
   - Main conversation can retry or adjust approach

---

## References

- `resarch/subagents.md` - Complete Kiro subagents documentation
- `resarch/ideas.md` - Integration concepts
- Kiro docs: https://code.claude.com/docs/sub-agents

---

## Next Steps

Proceed to planning with this research as foundation.
