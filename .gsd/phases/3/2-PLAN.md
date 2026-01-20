---
phase: 3
plan: 2
wave: 2
---

# Plan 3.2: Map Explorer Subagent

## Objective

Create subagent for `/map` command that analyzes codebase in forked context.

## Context

- ROADMAP.md (Phase 3: Subagente para /map)
- .gsd/phases/3/RESEARCH.md (map-explorer specification)
- .gsd/workflows/map.md (current /map workflow)

## Tasks

<task type="auto">
  <name>Create map-explorer subagent</name>
  <files>.kiro/agents/map-explorer.md</files>
  <action>
    Create map-explorer subagent:
    
    ```yaml
    ---
    name: map-explorer
    description: Analyzes codebase architecture and tech stack. Use for /map command or when exploring unfamiliar codebases.
    tools: Read, Grep, Glob, Bash
    disallowedTools: Write, Edit
    model: haiku
    permissionMode: plan
    context: fork
    ---
    
    # Map Explorer
    
    You are a codebase analysis specialist. Your task is to explore and understand the codebase architecture.
    
    ## Your Task
    
    Analyze the codebase and identify:
    1. Tech stack (languages, frameworks, libraries)
    2. Architecture patterns (MVC, microservices, etc.)
    3. Code conventions (naming, structure)
    4. Technical debt (TODOs, deprecated code)
    5. Entry points and key modules
    
    ## Process
    
    1. List all source files (use Glob)
    2. Identify file types and structure
    3. Read key files (package.json, requirements.txt, etc.)
    4. Analyze directory structure
    5. Search for patterns (Grep for imports, classes, etc.)
    6. Identify dependencies
    7. Note any issues or concerns
    
    ## Output Format
    
    Return a structured summary:
    
    ### Tech Stack
    - Languages: [list]
    - Frameworks: [list]
    - Key dependencies: [list]
    
    ### Architecture
    - Pattern: [description]
    - Directory structure: [overview]
    - Entry points: [list]
    
    ### Code Conventions
    - Naming: [patterns observed]
    - Structure: [organization]
    
    ### Technical Debt
    - Issues found: [list]
    - Recommendations: [list]
    
    Keep summary concise - focus on key insights.
    ```
    
    WHY haiku: Fast and cheap for exploration
    WHY plan mode: Read-only, no permission prompts
    WHY context:fork: Keeps file reads out of main conversation
  </action>
  <verify>type .kiro\agents\map-explorer.md</verify>
  <done>Subagent file exists with complete configuration</done>
</task>

<task type="auto">
  <name>Update /map workflow</name>
  <files>.gsd/workflows/map.md</files>
  <action>
    Update /map workflow to use map-explorer subagent:
    
    Find the codebase analysis section and add:
    
    ```markdown
    ## 2. Analyze Codebase
    
    **With Kiro**: Use map-explorer subagent for context-efficient analysis:
    
    ```
    Use the map-explorer subagent to analyze this codebase.
    ```
    
    The subagent will:
    - Explore codebase in forked context
    - Analyze architecture and tech stack
    - Return concise summary
    - Keep main conversation clean
    
    **Without Kiro**: Manually explore and document findings.
    ```
    
    WHY update workflow: Guides users to use subagent
    AVOID: Removing existing instructions - add Kiro-specific section
  </action>
  <verify>findstr /C:"map-explorer" .gsd\workflows\map.md</verify>
  <done>Workflow references map-explorer subagent</done>
</task>

<task type="checkpoint:human-verify">
  <name>Test map-explorer subagent</name>
  <files>test_map.md</files>
  <action>
    Manual test of map-explorer:
    
    1. Ask Claude to analyze this codebase using map-explorer
    2. Verify subagent is invoked
    3. Verify it runs in forked context
    4. Verify summary is returned
    5. Check main conversation context usage
    6. Confirm context savings vs inline analysis
    
    This validates context fork works correctly.
  </action>
  <verify>User confirms map-explorer reduces context usage</verify>
  <done>Map-explorer successfully analyzes codebase with context savings</done>
</task>

## Success Criteria

- [ ] map-explorer subagent exists
- [ ] Subagent uses context:fork
- [ ] Subagent is read-only (plan mode)
- [ ] /map workflow references subagent
- [ ] Testing confirms context savings
- [ ] Changes committed to git

## Notes

This is the key innovation - massive context savings for codebase analysis.
