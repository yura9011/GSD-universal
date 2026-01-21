---
phase: 1
level: 3
researched_at: 2026-01-20
---

# Phase 1 Research: Core Ralph Engine

## Questions Investigated

1. **Core Architecture**: How does the Ralph Loop work fundamentally?
2. **Implementation Details**: What are the key files and scripts needed?
3. **Integration with GSD**: How to adapt Ralph for our existing GSD framework?
4. **Cross-Platform Requirements**: Windows, Linux, Mac compatibility
5. **Quality Control**: How does backpressure validation work?
6. **Context Management**: How does Ralph maintain context hygiene?

## Findings

### Core Ralph Architecture - The Original Concept

**The Fundamental Insight:**
Ralph Loop is NOT a complex orchestration system. It's deliberately simple: a bash loop that runs the same prompt repeatedly until completion. The genius is in its simplicity and fresh context approach.

**The Pure Ralph Formula:**
```bash
while true; do
  cat PROMPT.md | claude-code
done
```

**Key Principles from Geoffrey Huntley:**
1. **Fresh Context Per Iteration**: Each loop starts a new session - no conversation history pollution
2. **Disk Is State**: Files persist between iterations, conversation context doesn't
3. **Git Is Memory**: Version control tracks progress, not chat history
4. **One Task Per Loop**: Each iteration does ONE thing, then exits
5. **Let Ralph Ralph**: AI decides what's most important, human sets constraints
6. **Backpressure Critical**: Validation gates prevent bad work from being marked complete

**The "Piloto Automático" Pattern:**
- **Before**: Human pilots each step manually
- **Now**: Human engineers the environment, AI flies autonomously until task complete

**Sources:**
- https://github.com/ghuntley/how-to-ralph-wiggum (Original repository)
- https://zerosync.co/blog/ralph-loop-technical-deep-dive (Comprehensive analysis)
- https://www.siddharthbharath.com/blog/ralph-wiggum-claude-code (Practical implementation)
- Geoffrey Huntley's CURSED project (3-month autonomous language creation)

**Recommendation:** Implement the pure Ralph approach - simple loop with fresh context, not complex orchestration.

### Essential Files and Their Exact Purposes

**Core Files (From Original Ralph):**
- `PROMPT.md` - Single prompt file fed to AI each iteration
- `AGENTS.md` - Project conventions and "signs" (60 lines max, operational only)
- `specs/*` - Specification files, one per feature/component
- `fix_plan.md` - Dynamic task tracker (NOT implementation plan - this is key difference)

**Advanced Files (Two-Mode Approach):**
- `PROMPT_plan.md` - Planning mode: reads all specs, generates/updates fix_plan.md
- `PROMPT_build.md` - Building mode: reads fix_plan.md, implements one item

**Critical Distinctions:**
- **specs/***: Static requirements (what should be built)
- **fix_plan.md**: Dynamic task list (what needs to be done right now)
- **AGENTS.md**: Operational commands only, NOT status/progress
- **Fresh Context**: Each iteration re-reads ALL files from disk

**File Naming Matters:**
- Original uses `fix_plan.md` not `IMPLEMENTATION_PLAN.md`
- Original uses single `PROMPT.md` for simple cases
- Two-mode approach uses `PROMPT_plan.md` and `PROMPT_build.md`

**Sources:**
- Geoffrey Huntley's original repository structure
- CURSED project file organization
- Multiple implementation examples analyzed

**Recommendation:** Follow exact original naming and structure for compatibility with existing Ralph ecosystem.

### Loop Mechanics - The Exact Process

**The Pure Ralph Loop (Original):**
```bash
while true; do
  cat PROMPT.md | claude -p --dangerously-skip-permissions
done
```

**Enhanced Loop (With Safety Features):**
```bash
#!/bin/bash
MODE="build"  # or "plan"
PROMPT_FILE="PROMPT_${MODE}.md"
MAX_ITERATIONS=50

for i in $(seq 1 $MAX_ITERATIONS); do
  echo "--- Iteration $i ---"
  cat "$PROMPT_FILE" | claude -p --dangerously-skip-permissions --model opus
  
  # Check for completion signal
  if grep -q "COMPLETE" output.log; then
    echo "Task completed!"
    break
  fi
  
  # Auto-push after each iteration
  git push origin $(git branch --show-current)
  sleep 2
done
```

**What Happens Each Iteration:**
1. **Fresh Start**: New Claude session, clean context window
2. **File Loading**: AI reads PROMPT.md, AGENTS.md, specs/*, fix_plan.md from disk
3. **Decision**: AI picks most important item from fix_plan.md
4. **Implementation**: AI makes changes, runs tests (backpressure)
5. **Update**: AI updates fix_plan.md with progress
6. **Commit**: AI creates atomic git commit
7. **Exit**: Session ends, loop restarts immediately

**Critical Success Factors:**
- **One Item Per Iteration**: Never try to do multiple things
- **Fresh Context**: No memory between iterations except files
- **Backpressure**: Must validate before marking complete
- **Atomic Commits**: Each iteration = one commit

**Sources:**
- Geoffrey Huntley's original loop.sh implementations
- Multiple production Ralph setups analyzed
- Anthropic's research on long-running agents

**Recommendation:** Start with pure Ralph loop, add safety features incrementally.

### Integration Strategy with GSD Framework

**Critical Insight: Ralph vs GSD Philosophy Alignment**
- **GSD**: Structured phases with human oversight at each step
- **Ralph**: Autonomous execution with minimal human intervention
- **Integration Approach**: Ralph becomes the execution engine for GSD phases

**Mapping GSD to Ralph:**
1. **GSD Planning** → **Ralph Planning Mode**: Generate fix_plan.md from ROADMAP.md
2. **GSD Execution** → **Ralph Building Mode**: Autonomous implementation loop
3. **GSD Verification** → **Ralph Backpressure**: Integrated validation gates

**File Mapping Strategy:**
```
GSD Structure          Ralph Structure
├── ROADMAP.md    →   ├── specs/roadmap.md (static requirements)
├── STATE.md      →   ├── fix_plan.md (dynamic tasks)
├── ARCHITECTURE.md → ├── specs/architecture.md
└── scripts/      →   └── AGENTS.md (validation commands)
```

**Backpressure Integration:**
- Use existing `./scripts/validate-all.sh` as Ralph's validation gate
- Kiro's `getDiagnostics` for syntax checking
- Existing GSD validation patterns as quality gates

**Kiro Enhancement Opportunities:**
- **Subagents**: Use for parallel file operations (up to 500 parallel Sonnet subagents)
- **Hooks**: PreToolUse for planning lock, PostToolUse for validation
- **Skills**: Convert to Ralph "signs" in AGENTS.md
- **Context Fork**: Leverage for massive parallelism without context pollution

**Sources:**
- Analysis of GSD framework structure
- Ralph integration patterns from multiple implementations
- Kiro capabilities from previous milestone

**Recommendation:** Ralph becomes the autonomous execution engine that powers GSD phases, not a replacement for GSD structure.

### Cross-Platform Implementation

**Core Requirements:**
- Bash script for Linux/Mac (`loop.sh`)
- PowerShell script for Windows (`loop.ps1`)
- Claude CLI or equivalent AI interface
- Git for version control

**Platform-Specific Considerations:**
- **Windows**: PowerShell equivalent of bash loop
- **Linux/Mac**: Standard bash implementation
- **Cross-platform**: Shared prompt files and AGENTS.md

**Enhanced Loop Features:**
- Mode selection (plan/build)
- Max iterations support
- Automatic git push after each iteration
- Error handling and recovery

**Sources:**
- Enhanced loop examples in repository
- Cross-platform shell scripting patterns

**Recommendation:** Develop parallel bash and PowerShell implementations with shared templates.

### Backpressure System - The Quality Control Mechanism

**Core Philosophy:**
"Code generation is cheap now; ensuring correctness is what's hard. The key is that the validation wheel must turn fast." - Geoffrey Huntley

**How Backpressure Works:**
1. **AI implements something**
2. **Validation runs automatically** (tests, linting, build)
3. **If validation fails**: AI must fix before marking task complete
4. **If validation passes**: Task marked complete, commit created
5. **Loop continues** with next task

**Types of Backpressure (From Research):**
- **Compilation**: Language compiler catches syntax/type errors
- **Tests**: Unit/integration tests verify functionality
- **Linting**: Code style and quality checks
- **Build Systems**: Ensure project builds successfully
- **Custom Validation**: Project-specific checks

**AGENTS.md Structure for Backpressure:**
```markdown
# AGENTS.md

## Validation Commands
Run these before marking any task complete:

- Full validation: `./scripts/validate-all.sh`
- Syntax check: `npm run lint`
- Tests: `npm test`
- Build: `npm run build`

## Project Conventions
- Use TypeScript strict mode
- All functions must have tests
- No console.log in production code
```

**Critical Success Factors:**
- **Fast Feedback**: Validation must complete quickly (< 30 seconds)
- **Clear Signals**: Pass/fail must be unambiguous
- **Comprehensive**: Cover syntax, functionality, style
- **Automated**: No human intervention required

**GSD Integration Opportunity:**
Our existing `./scripts/validate-all.sh` is PERFECT for Ralph backpressure - it already provides comprehensive validation in a single command.

**Sources:**
- Geoffrey Huntley's backpressure philosophy
- CURSED project validation patterns
- Multiple Ralph implementation examples

**Recommendation:** Use existing GSD validation infrastructure as Ralph's backpressure system.

### Advanced Patterns and Real-World Evidence

**Subagent Parallelism (From Original Ralph):**
Geoffrey Huntley's prompts allow massive parallelism:
- "up to 500 parallel Sonnet subagents" for file operations
- "only 1 subagent for build/tests" to avoid conflicts
- Opus subagents for complex reasoning ("oracle" pattern)

**Real-World Success Cases:**

**1. CURSED Programming Language (Geoffrey Huntley)**
- 3 months of autonomous operation
- Complete compiler: lexer, parser, LLVM codegen, stdlib
- Language didn't exist in training data
- Proof of concept for long-term autonomous development

**2. $50,000 Contract for $297 (VentureBeat Coverage)**
- Developer completed major contract using Ralph
- API costs under $300
- Demonstrates economic viability

**3. Y Combinator Hackathon Results**
- Team used Ralph for hackathon project
- Documented systematic approach
- Validated technique under time pressure

**The "Signs" Evolution Pattern:**
Ralph will fail predictably. When it does:
1. Add "signs" (instructions) to AGENTS.md
2. If too many signs accumulate, simplify and tune
3. Treat failures as tuning opportunities, not blockers

**Context Window Management:**
- Quality degrades as you approach ~170k tokens
- Output clips around 147-152k tokens
- Fresh context per iteration prevents degradation
- One task per iteration preserves quality

**Sources:**
- Geoffrey Huntley's documented CURSED development
- VentureBeat article on Ralph success stories
- Y Combinator hackathon case study
- Anthropic research on long-running agents

**Recommendation:** Start simple, add complexity only when needed. The power is in the simplicity.

## Decisions Made

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Core Philosophy** | Pure Ralph Loop approach | Simple bash loop with fresh context - proven by Geoffrey Huntley |
| **File Structure** | Original Ralph naming: PROMPT.md, AGENTS.md, specs/*, fix_plan.md | Maintain compatibility with Ralph ecosystem |
| **Loop Implementation** | Single loop.sh with mode switching | Start simple, add complexity only when needed |
| **Integration Strategy** | Ralph as execution engine for GSD phases | Leverage GSD structure, enhance with Ralph automation |
| **Backpressure System** | Existing `./scripts/validate-all.sh` | Perfect fit for Ralph's validation requirements |
| **Context Management** | Fresh context per iteration, files as state | Core Ralph principle - no conversation memory |
| **Task Granularity** | One task per iteration | Preserve context window quality |
| **Cross-Platform** | Bash primary, PowerShell secondary | Follow original Ralph patterns |

## Patterns to Follow (The Ralph Tenets)

- **Fresh Context Is Reliability**: Each iteration clears context. Re-read specs, plan, code every cycle
- **Backpressure Over Prescription**: Don't prescribe how; create gates that reject bad work
- **The Plan Is Disposable**: Regeneration costs one planning loop. Cheap.
- **Disk Is State, Git Is Memory**: Files are the handoff mechanism between iterations
- **Steer With Signals, Not Scripts**: Add signs to AGENTS.md, not complex orchestration
- **Let Ralph Ralph**: Sit on the loop, not in it. Trust Ralph to decide what's most important
- **One Task Per Loop**: Each iteration does ONE thing, then exits for fresh context
- **Deterministic File Loading**: Same files read each iteration (PROMPT.md + AGENTS.md + specs/* + fix_plan.md)
- **Operational AGENTS.md**: Contains commands and conventions, NOT status or progress
- **Atomic Everything**: One task, one commit, one iteration

## Anti-Patterns to Avoid (What Breaks Ralph)

- **Multi-Agent Orchestration**: Ralph is single-process, not multi-agent coordination
- **Conversation Memory**: No chat history between iterations - files only
- **Complex State Management**: Don't build sophisticated handoff protocols
- **Prescriptive Implementation**: Don't tell Ralph HOW, tell it WHAT and let it figure out HOW
- **Status Tracking in AGENTS.md**: Status goes in fix_plan.md, commands go in AGENTS.md
- **Multiple Tasks Per Iteration**: One thing at a time, always
- **Skipping Backpressure**: Never mark complete without validation
- **Bloated AGENTS.md**: Keep under 60 lines, operational only
- **Assuming Implementation**: Always search before assuming something doesn't exist
- **Fighting Ralph's Nature**: When Ralph fails predictably, add signs, don't fight the pattern

## Dependencies Identified

| Package | Version | Purpose |
|---------|---------|---------|
| Claude CLI | Latest | AI interface for autonomous execution |
| Git | Any | Version control and atomic commits |
| Bash | 4.0+ | Linux/Mac loop implementation |
| PowerShell | 5.1+ | Windows loop implementation |
| Node.js | 18+ | For npm-based validation scripts (if applicable) |

## Technical Requirements

### Minimum Setup
- AI CLI tool (Claude, amp, codex, opencode, etc.)
- Git repository with existing validation scripts
- Cross-platform shell environment
- ROADMAP.md with checkbox tasks

### Recommended Setup
- Kiro IDE with hooks, skills, subagents
- Existing GSD validation scripts
- CI/CD integration capabilities
- Multi-core system for parallel subagent operations

## Risks and Mitigations

### Context Pollution
**Risk**: Long conversations degrade AI performance over time
**Mitigation**: Automatic session restarts after each task (core Ralph principle)

### Infinite Loops
**Risk**: AI gets stuck failing same validation repeatedly
**Mitigation**: 
- Error counting and max iterations
- Human intervention triggers
- Improved prompt engineering based on failure patterns

### Quality Control
**Risk**: AI marks tasks complete without proper validation
**Mitigation**: 
- Mandatory backpressure validation before completion
- Integration with existing GSD validation scripts
- Atomic commits for easy rollback

### Cross-Platform Issues
**Risk**: Scripts work on one platform but fail on others
**Mitigation**: 
- Parallel development of bash and PowerShell versions
- Shared template files for consistency
- Platform-specific testing

### Integration Complexity
**Risk**: Ralph conflicts with existing GSD workflows
**Mitigation**: 
- Build as extension, not replacement
- Maintain compatibility with manual workflows
- Gradual adoption path

## Implementation Strategy - Exact Replication Approach

### Phase 1: Pure Ralph Implementation
1. **Core Loop**: Implement exact Geoffrey Huntley loop.sh pattern
2. **File Structure**: Use original Ralph naming (PROMPT.md, AGENTS.md, specs/*, fix_plan.md)
3. **GSD Adaptation**: Map GSD concepts to Ralph structure without changing Ralph's core
4. **Validation Integration**: Use `./scripts/validate-all.sh` as backpressure mechanism
5. **Testing**: Verify with simple tasks before complex workflows

### Exact File Mapping Strategy
```
Ralph Original          GSD Integration
├── PROMPT.md      →   ├── PROMPT.md (GSD-aware instructions)
├── AGENTS.md      →   ├── AGENTS.md (GSD validation commands)
├── specs/         →   ├── specs/ (from ROADMAP.md phases)
├── fix_plan.md    →   ├── fix_plan.md (from ROADMAP.md tasks)
└── loop.sh        →   └── loop.sh (with GSD enhancements)
```

### Success Criteria for Phase 1
- [ ] Pure Ralph loop executes autonomous iterations
- [ ] Fresh context per iteration verified
- [ ] AGENTS.md under 60 lines, operational only
- [ ] fix_plan.md updates automatically during execution
- [ ] Backpressure validation prevents bad completions
- [ ] Atomic commits created per task
- [ ] Cross-platform compatibility (bash + PowerShell)
- [ ] Integration with existing GSD validation scripts

## Ready for Planning

- [x] Core architecture understood (Three-phase Ralph approach)
- [x] Essential files identified (loop scripts, prompts, operational manual)
- [x] Integration strategy defined (Extend GSD, leverage existing validation)
- [x] Cross-platform requirements clarified (bash + PowerShell)
- [x] Backpressure mechanism designed (existing validation scripts)
- [x] Risk mitigation strategies identified
- [x] Implementation approach selected (autonomous execution with context hygiene)

## Next Steps

The research is complete and comprehensive. Ready to proceed with `/plan 1` to create detailed execution plans for implementing the Core Ralph Engine.

Key insight: Ralph Loop is not just "a loop that codes" - it's a complete paradigm shift from conversational AI to autonomous AI execution, with sophisticated context management and quality control mechanisms that align perfectly with GSD's empirical validation principles.