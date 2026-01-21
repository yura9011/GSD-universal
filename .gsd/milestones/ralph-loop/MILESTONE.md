# Milestone: ralph-loop

## Objective
Implement autonomous execution loop (Ralph) for GSD framework with Kiro IDE integration, enabling AI agents to work autonomously through complete development phases.

## Background
Based on the Ralph Loop concept from [ghuntley/how-to-ralph-wiggum](https://github.com/ghuntley/how-to-ralph-wiggum), this milestone implements autonomous execution capabilities that allow AI agents to:

- Execute complete development phases without human intervention
- Maintain context hygiene through automatic session restarts
- Validate work through backpressure systems
- Integrate with existing GSD validation scripts

## Key Innovation: The "Piloto Automático" Pattern

**Before (GSD Clásico)**: You are the pilot. You write `/execute`, wait, read, write `/verify`.

**Now (Ralph)**: You are the flight engineer. You configure the course (ROADMAP.md) and start the engine (loop.sh). The AI flies alone segment by segment.

## Must-Have Deliverables

### Core Engine
- [ ] `loop.sh` - The autonomous execution engine
- [ ] `loop.ps1` - PowerShell equivalent for Windows
- [ ] Cross-platform compatibility and testing

### Operational System
- [ ] `AGENTS.md` - Operational manual for autonomous agents (60 lines max)
- [ ] `PROMPT_build.md` - Build mode execution template
- [ ] `PROMPT_plan.md` - Planning mode execution template

### Integration
- [ ] Integration with existing GSD validation scripts
- [ ] Backpressure validation system
- [ ] Kiro IDE hooks and skills integration
- [ ] Error recovery and retry mechanisms

### Documentation
- [ ] Complete Ralph Loop documentation
- [ ] Usage examples and tutorials
- [ ] Migration guide from manual to autonomous execution

## Success Criteria

1. **Autonomous Execution**: Ralph can complete entire phases without human intervention
2. **Quality Assurance**: 95% success rate on validation scripts during autonomous execution
3. **Context Hygiene**: Automatic session restarts prevent context pollution
4. **Integration**: Seamless integration with existing GSD framework
5. **Cross-Platform**: Works on Windows, Linux, and Mac
6. **Usability**: Users can implement Ralph in 15 minutes

## Technical Architecture

### The Ralph Loop Flow
1. **Read State**: Parse ROADMAP.md for next uncompleted task
2. **Execute Task**: Use AI to implement the specific task
3. **Validate**: Run backpressure validation (./scripts/validate-all.sh)
4. **Update State**: Mark task complete in ROADMAP.md if validation passes
5. **Commit**: Create atomic git commit
6. **Restart**: Kill session and start fresh (context hygiene)
7. **Repeat**: Continue until all tasks complete

### Key Files Structure
```
Root/
├── loop.sh                 # The autonomous execution engine
├── loop.ps1               # PowerShell equivalent
├── AGENTS.md              # Operational manual (60 lines max)
├── PROMPT_build.md        # Build mode template
├── PROMPT_plan.md         # Planning mode template
├── ROADMAP.md             # Task list with checkboxes
└── scripts/
    └── validate-all.sh    # Backpressure validation
```

## Phases Overview

### Phase 1: Core Ralph Engine
Implement the basic autonomous execution loop with cross-platform support.

### Phase 2: Agent Operational System
Create operational manuals and prompt templates for autonomous agents.

### Phase 3: Kiro IDE Integration
Integrate Ralph with Kiro-specific features (hooks, skills, subagents).

### Phase 4: Quality Gates & Validation
Implement comprehensive validation and error recovery systems.

### Phase 5: Documentation & Examples
Complete documentation with practical examples and migration guides.

## Risk Mitigation

### Context Pollution
**Risk**: Long conversations degrade AI performance
**Mitigation**: Automatic session restarts after each task

### Infinite Loops
**Risk**: AI gets stuck failing the same validation
**Mitigation**: Error counting and human intervention triggers

### Quality Control
**Risk**: AI marks tasks complete without proper validation
**Mitigation**: Mandatory backpressure validation before task completion

### Cross-Platform Issues
**Risk**: Scripts work on one platform but fail on others
**Mitigation**: Parallel development of bash and PowerShell versions

## Dependencies

### Internal
- Existing GSD validation scripts (./scripts/validate-all.sh)
- ROADMAP.md structure with checkboxes
- STATE.md for session persistence

### External
- AI CLI (claude, kiro, openai, etc.) or equivalent AI interface
- Git for version control
- Cross-platform shell environments (bash, PowerShell)

## Timeline
**Target Completion**: 2026-03-01 (5 weeks)
**Critical Path**: Core engine → Operational system → Integration → Validation → Documentation

## Inspiration and Credits
Based on the Ralph Loop concept by [ghuntley](https://github.com/ghuntley) from [how-to-ralph-wiggum](https://github.com/ghuntley/how-to-ralph-wiggum).

The Ralph Loop represents a paradigm shift from conversational AI to autonomous AI execution, enabling true "set it and forget it" development workflows.