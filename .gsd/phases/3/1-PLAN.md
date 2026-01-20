---
phase: 3
plan: 1
wave: 1
---

# Plan 3.1: Subagent Infrastructure Setup

## Objective

Create foundational directory structure and documentation for Kiro subagents.

## Context

- ROADMAP.md (Phase 3 objectives)
- .gsd/phases/3/RESEARCH.md (Subagent implementation strategy)
- resarch/subagents.md (Kiro subagents documentation)

## Tasks

<task type="auto">
  <name>Create subagents directory structure</name>
  <files>
    .kiro/agents/README.md
    .kiro/agents/.gitkeep
  </files>
  <action>
    Create `.kiro/agents/` directory structure:
    
    1. Create `.kiro/agents/` directory
    2. Create comprehensive README.md
    3. Add .gitkeep for git tracking
    
    **README.md content**:
    - Overview of GSD subagents
    - When to use subagents vs main conversation
    - Context fork pattern explanation
    - Available subagents list
    - Integration with GSD workflows
    - Link to Kiro subagents documentation
    
    WHY separate from skills: Different purpose (context management vs guidance)
  </action>
  <verify>dir .kiro\agents</verify>
  <done>Directory exists with README.md</done>
</task>

<task type="auto">
  <name>Create subagent template</name>
  <files>.kiro/agents/AGENT_TEMPLATE.md</files>
  <action>
    Create template for new subagents:
    
    ```markdown
    ---
    name: agent-name
    description: When to delegate to this subagent
    tools: Read, Grep, Glob
    disallowedTools: Write, Edit
    model: haiku | sonnet | opus | inherit
    permissionMode: default | plan | dontAsk
    context: fork
    ---
    
    # Subagent Name
    
    You are a specialized subagent for [purpose].
    
    ## Your Task
    
    [What this subagent does]
    
    ## Process
    
    1. Step 1
    2. Step 2
    3. Step 3
    
    ## Output Format
    
    Return a summary with:
    - Key findings
    - Recommendations
    - Next steps
    
    Keep summary concise - main conversation has limited context.
    ```
    
    WHY template: Ensures consistency across subagents
  </action>
  <verify>type .kiro\agents\AGENT_TEMPLATE.md</verify>
  <done>Template exists with complete structure</done>
</task>

<task type="auto">
  <name>Document context fork pattern</name>
  <files>.kiro/agents/CONTEXT_FORK.md</files>
  <action>
    Create documentation explaining context fork:
    
    **Sections**:
    1. Problem: Context pollution from high-volume operations
    2. Solution: context:fork creates separate context
    3. How it works: Diagram of fork lifecycle
    4. Benefits: Context savings, parallel execution
    5. When to use: Guidelines for fork vs inline
    6. Examples: Before/after context usage
    
    WHY separate doc: Complex concept needs detailed explanation
  </action>
  <verify>type .kiro\agents\CONTEXT_FORK.md</verify>
  <done>Documentation exists with examples</done>
</task>

## Success Criteria

- [ ] `.kiro/agents/` directory exists with README.md
- [ ] Subagent template exists
- [ ] Context fork documentation exists
- [ ] All files committed to git

## Notes

Foundation for subagent implementations in Wave 2.
