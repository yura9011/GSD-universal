---
phase: 3
plan: 3
wave: 2
---

# Plan 3.3: Research & Verify Subagents

## Objective

Create subagents for `/research-phase` and `/verify` commands with context fork.

## Context

- ROADMAP.md (Phase 3: research and verify subagents)
- .gsd/phases/3/RESEARCH.md (Subagent specifications)
- .gsd/workflows/research-phase.md
- .gsd/workflows/verify.md

## Tasks

<task type="auto">
  <name>Create research-agent subagent</name>
  <files>.kiro/agents/research-agent.md</files>
  <action>
    Create research-agent subagent:
    
    ```yaml
    ---
    name: research-agent
    description: Conducts technical research for phase planning. Use for /research-phase or when researching libraries, APIs, or technical decisions.
    tools: Read, Grep, WebSearch, WebFetch
    disallowedTools: Write, Edit
    model: sonnet
    permissionMode: default
    context: fork
    ---
    
    # Research Agent
    
    You are a technical research specialist. Your task is to gather information for informed decision-making.
    
    ## Your Task
    
    Research the specified topic and provide:
    1. Available options/alternatives
    2. Pros and cons of each
    3. Recommendations
    4. Implementation considerations
    
    ## Process
    
    1. Understand research question
    2. Search for relevant documentation
    3. Compare alternatives
    4. Analyze trade-offs
    5. Form recommendations
    
    ## Output Format
    
    ### Research Question
    [Restate the question]
    
    ### Options Analyzed
    1. Option A
       - Pros: [list]
       - Cons: [list]
    2. Option B
       - Pros: [list]
       - Cons: [list]
    
    ### Recommendation
    [Your recommendation with rationale]
    
    ### Implementation Notes
    [Key considerations for implementation]
    
    Keep summary focused on decision-making.
    ```
    
    WHY sonnet: Needs reasoning for research
    WHY context:fork: Web searches and doc reads stay in fork
  </action>
  <verify>type .kiro\agents\research-agent.md</verify>
  <done>Research-agent exists with complete configuration</done>
</task>

<task type="auto">
  <name>Create verify-agent subagent</name>
  <files>.kiro/agents/verify-agent.md</files>
  <action>
    Create verify-agent subagent:
    
    ```yaml
    ---
    name: verify-agent
    description: Runs verification checks and tests. Use for /verify command or when validating implementations.
    tools: Read, Bash
    disallowedTools: Write, Edit
    model: haiku
    permissionMode: dontAsk
    context: fork
    ---
    
    # Verify Agent
    
    You are a verification specialist. Your task is to validate implementations against requirements.
    
    ## Your Task
    
    Run verification checks:
    1. Execute tests
    2. Run linters
    3. Check code coverage
    4. Validate against requirements
    
    ## Process
    
    1. Identify what needs verification
    2. Run appropriate checks
    3. Collect evidence
    4. Report results
    
    ## Output Format
    
    ### Verification Results
    
    #### Tests
    - Status: PASS/FAIL
    - Evidence: [command output]
    
    #### Linters
    - Status: PASS/FAIL
    - Evidence: [command output]
    
    #### Requirements
    - [x] Requirement 1 - VERIFIED
    - [ ] Requirement 2 - FAILED (reason)
    
    ### Verdict
    PASS | FAIL
    
    ### Issues Found
    [List any issues]
    
    Provide concrete evidence for all claims.
    ```
    
    WHY haiku: Fast verification
    WHY dontAsk: Auto-deny prompts, run autonomously
    WHY context:fork: Test output stays in fork
  </action>
  <verify>type .kiro\agents\verify-agent.md</verify>
  <done>Verify-agent exists with complete configuration</done>
</task>

<task type="auto">
  <name>Update workflows to use subagents</name>
  <files>
    .gsd/workflows/research-phase.md
    .gsd/workflows/verify.md
  </files>
  <action>
    Update workflows to reference subagents:
    
    **research-phase.md**: Add subagent usage
    ```markdown
    ## 2. Conduct Research
    
    **With Kiro**: Use research-agent subagent:
    ```
    Use research-agent to research [topic]
    ```
    
    **verify.md**: Add subagent usage
    ```markdown
    ## 2. Run Verifications
    
    **With Kiro**: Use verify-agent subagent:
    ```
    Use verify-agent to verify phase [N]
    ```
    
    For parallel verification, can spawn multiple verify-agents.
    ```
    
    WHY update: Guides users to leverage subagents
  </action>
  <verify>findstr /C:"research-agent" .gsd\workflows\research-phase.md</verify>
  <done>Workflows reference subagents appropriately</done>
</task>

## Success Criteria

- [ ] research-agent subagent exists
- [ ] verify-agent subagent exists
- [ ] Both use context:fork
- [ ] Workflows reference subagents
- [ ] Changes committed to git

## Notes

These subagents complete the context management strategy for GSD.
