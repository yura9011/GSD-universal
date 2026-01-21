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
  cat PROMPT.md | ai-cli
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

### Essential Files and Their Exact Purposes (CORRECTED)

**Core Files (From Original Ralph Repository):**
- `PROMPT.md` - Single prompt file OR mode-specific prompts
- `PROMPT_plan.md` - Planning mode: generates/updates IMPLEMENTATION_PLAN.md
- `PROMPT_build.md` - Building mode: implements from IMPLEMENTATION_PLAN.md
- `AGENTS.md` - Project conventions and backpressure commands (60 lines max)
- `specs/*` - Specification files, one per topic of concern
- `IMPLEMENTATION_PLAN.md` - Dynamic task tracker (NOT fix_plan.md as I initially thought)

**Exact Prompt Structure (From Repository):**
```
Phase 0 (0a, 0b, 0c) - Orient: study specs, source location, current plan
Phase 1-4 - Main instructions: task, validation, commit  
999... numbering - Guardrails/invariants (higher number = more critical)
```

**PROMPT_build.md Template (Exact from Repository):**
```markdown
0a. Study `specs/*` with up to 500 parallel Sonnet subagents to learn the application specifications.
0b. Study @IMPLEMENTATION_PLAN.md.
0c. For reference, the application source code is in `src/*`.

1. Your task is to implement functionality per the specifications using parallel subagents. Follow @IMPLEMENTATION_PLAN.md and choose the most important item to address. Before making changes, search the codebase (don't assume not implemented) using Sonnet subagents. You may use up to 500 parallel Sonnet subagents for searches/reads and only 1 Sonnet subagent for build/tests. Use Opus subagents when complex reasoning is needed (debugging, architectural decisions).

2. After implementing functionality or resolving problems, run the tests for that unit of code that was improved. If functionality is missing then it's your job to add it as per the application specifications. Ultrathink.

3. When you discover issues, immediately update @IMPLEMENTATION_PLAN.md with your findings using a subagent. When resolved, update and remove the item.

4. When the tests pass, update @IMPLEMENTATION_PLAN.md, then `git add -A` then `git commit` with a message describing the changes. After the commit, `git push`.

99999. Important: When authoring documentation, capture the why — tests and implementation importance.
999999. Important: Single sources of truth, no migrations/adapters. If tests unrelated to your work fail, resolve them as part of the increment.
9999999. As soon as there are no build or test errors create a git tag. If there are no git tags start at 0.0.0 and increment patch by 1 for example 0.0.1 if 0.0.0 does not exist.
99999999. You may add extra logging if required to debug issues.
999999999. Keep @IMPLEMENTATION_PLAN.md current with learnings using a subagent — future work depends on this to avoid duplicating efforts. Update especially after finishing your turn.
9999999999. When you learn something new about how to run the application, update @AGENTS.md using a subagent but keep it brief. For example if you run commands multiple times before learning the correct command then that file should be updated.
99999999999. For any bugs you notice, resolve them or document them in @IMPLEMENTATION_PLAN.md using a subagent even if it is unrelated to the current piece of work.
999999999999. Implement functionality completely. Placeholders and stubs waste efforts and time redoing the same work.
9999999999999. When @IMPLEMENTATION_PLAN.md becomes large periodically clean out the items that are completed from the file using a subagent.
99999999999999. If you find inconsistencies in the specs/* then use an Opus 4.5 subagent with 'ultrathink' requested to update the specs.
999999999999999. IMPORTANT: Keep @AGENTS.md operational only — status updates and progress notes belong in `IMPLEMENTATION_PLAN.md`. A bloated AGENTS.md pollutes every future loop's context.
```

**AGENTS.md Structure (Exact Purpose):**
- Single, canonical "heart of the loop"
- Concise, operational "how to run/build" guide
- Contains project-specific commands for backpressure validation
- Status, progress, and planning belong in IMPLEMENTATION_PLAN.md, NOT here
- Enables "loopback" - immediate self-evaluation within same loop

**Sources:**
- https://github.com/ghuntley/how-to-ralph-wiggum (Direct repository analysis)
- Exact templates and structures from Geoffrey Huntley's implementation

**Recommendation:** Use EXACT naming and structure from original repository for compatibility.

### Loop Mechanics - The Exact Implementation (CORRECTED)

**Geoff's Initial Minimal Loop (From Repository):**
```bash
while :; do cat PROMPT.md | ai-cli ; done
```

**Enhanced Loop Example (From Repository):**
```bash
#!/bin/bash
MODE="build"  # or "plan"
PROMPT_FILE="PROMPT_${MODE}.md"
MAX_ITERATIONS=50

for i in $(seq 1 $MAX_ITERATIONS); do
  echo "--- Iteration $i ---"
  cat "$PROMPT_FILE" | claude -p --dangerously-skip-permissions --model opus
  
  # Auto-push after each iteration
  git push origin $(git branch --show-current)
  sleep 2
done
```

**What Controls Task Continuation (Exact Mechanism):**
1. **Bash loop runs** → feeds PROMPT.md to claude
2. **PROMPT.md instructs** → "Study IMPLEMENTATION_PLAN.md and choose the most important thing"
3. **Agent completes one task** → updates IMPLEMENTATION_PLAN.md on disk, commits, exits
4. **Bash loop restarts immediately** → fresh context window
5. **Agent reads updated plan** → picks next most important thing

**Key Insight from Repository:**
"The IMPLEMENTATION_PLAN.md file persists on disk between iterations and acts as shared state between otherwise isolated loop executions. Each iteration deterministically loads the same files (PROMPT.md + AGENTS.md + specs/*) and reads the current state from disk."

**Building Mode Loop Lifecycle (Exact from Repository):**
1. **Orient** – subagents study specs/* (requirements)
2. **Read plan** – study IMPLEMENTATION_PLAN.md
3. **Select** – pick the most important task
4. **Investigate** – subagents study relevant /src ("don't assume not implemented")
5. **Implement** – N subagents for file operations
6. **Validate** – 1 subagent for build/tests (backpressure)
7. **Update IMPLEMENTATION_PLAN.md** – mark task done, note discoveries/bugs
8. **Update AGENTS.md** – if operational learnings
9. **Commit**
10. **Loop ends** → context cleared → next iteration starts fresh

**Critical Success Factors (From Repository Analysis):**
- **No sophisticated orchestration needed** - just a dumb bash loop
- **Agent figures out what to do next** by reading the plan file each time
- **Fresh context per iteration** prevents context rot
- **Deterministic file loading** each iteration

**Sources:**
- Direct analysis of https://github.com/ghuntley/how-to-ralph-wiggum
- Geoffrey Huntley's exact loop mechanics documentation

**Recommendation:** Implement exact repository patterns, not my initial interpretations.

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
- AI CLI or equivalent AI interface (claude, kiro, openai, etc.)
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
| AI CLI | Latest | AI interface for autonomous execution (claude, kiro, openai, etc.) |
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

## Implementation Strategy - Exact Replication Approach (CORRECTED)

### Phase 1: Pure Ralph Implementation (Following Exact Repository Patterns)
1. **Core Loop**: Implement Geoffrey Huntley's exact loop.sh pattern from repository
2. **File Structure**: Use exact original naming (PROMPT_plan.md, PROMPT_build.md, AGENTS.md, IMPLEMENTATION_PLAN.md, specs/*)
3. **Prompt Templates**: Copy exact templates with 999... guardrail numbering system
4. **Subagent Patterns**: Follow exact patterns (500 Sonnet, 1 for build/tests, Opus for reasoning)
5. **GSD Integration**: Map GSD concepts to Ralph structure without changing Ralph's core

### Exact File Mapping Strategy (CORRECTED)
```
Ralph Original (Repository)    GSD Integration
├── PROMPT_plan.md        →   ├── PROMPT_plan.md (GSD planning mode)
├── PROMPT_build.md       →   ├── PROMPT_build.md (GSD execution mode)
├── AGENTS.md             →   ├── AGENTS.md (GSD validation commands)
├── specs/                →   ├── specs/ (from ROADMAP.md phases)
├── IMPLEMENTATION_PLAN.md →  ├── IMPLEMENTATION_PLAN.md (from ROADMAP.md tasks)
└── loop.sh               →   └── loop.sh (with GSD validation integration)
```

### Critical Corrections from Repository Analysis
- **File naming**: `IMPLEMENTATION_PLAN.md` NOT `fix_plan.md`
- **Prompt structure**: Exact 999... numbering system for guardrails
- **Subagent limits**: Specific numbers (500 Sonnet, 1 build/test, Opus for complex reasoning)
- **AGENTS.md purpose**: Operational commands for backpressure, NOT status tracking
- **Loop mechanics**: Exact bash patterns from repository

### Success Criteria for Phase 1 (UPDATED)
- [ ] Exact Ralph loop from repository executes autonomous iterations
- [ ] PROMPT_plan.md and PROMPT_build.md templates match repository exactly
- [ ] AGENTS.md under 60 lines, contains only operational commands
- [ ] IMPLEMENTATION_PLAN.md updates automatically during execution
- [ ] Guardrail numbering system (999...) implemented correctly
- [ ] Subagent patterns follow repository specifications
- [ ] Backpressure validation prevents bad completions
- [ ] Atomic commits created per task
- [ ] Integration with existing GSD validation scripts (`./scripts/validate-all.sh`)

### Key Insight from Deep Repository Analysis
Ralph is simpler than I initially thought, but the details matter enormously. The exact prompt structure, file naming, and guardrail system are what make it work reliably. My initial research captured the philosophy but missed the precise implementation patterns that Geoffrey Huntley developed through extensive testing.

## Ready for Planning

- [x] Core architecture understood (Three-phase Ralph approach)
- [x] Essential files identified (loop scripts, prompts, operational manual)
- [x] Integration strategy defined (Extend GSD, leverage existing validation)
- [x] Cross-platform requirements clarified (bash + PowerShell)
- [x] Backpressure mechanism designed (existing validation scripts)
- [x] Risk mitigation strategies identified
- [x] Implementation approach selected (autonomous execution with context hygiene)

## Research Validation and Next Steps

### Research Completeness Verification
- [x] **Core Concept**: Pure Ralph Loop understood (simple bash loop, fresh context)
- [x] **Original Implementation**: Geoffrey Huntley's exact patterns analyzed
- [x] **File Structure**: Original naming and purposes documented
- [x] **Loop Mechanics**: Exact iteration process mapped
- [x] **Backpressure System**: Quality control mechanisms understood
- [x] **Real-World Evidence**: Success cases documented (CURSED, $50k contract, YC hackathon)
- [x] **Integration Strategy**: How to adapt GSD without breaking Ralph's core
- [x] **Anti-Patterns**: What breaks Ralph identified
- [x] **Cross-Platform**: Implementation requirements clarified

### Key Insight Validation
Ralph Loop is NOT complex orchestration. It's deliberately simple:
- **Core**: `while true; do cat PROMPT.md | claude; done`
- **Power**: Fresh context + file persistence + backpressure validation
- **Philosophy**: "Deterministically bad in an undeterministic world" - eventual consistency through iteration

### Ready for Implementation Planning
The research provides complete understanding of:
1. **What Ralph is**: Simple autonomous loop with fresh context
2. **How to replicate it**: Exact file structure and loop mechanics
3. **How to integrate with GSD**: Ralph as execution engine, not replacement
4. **Success patterns**: Proven approaches from real implementations

### Next Steps
Ready to proceed with `/plan 1` to create detailed execution plans that implement the pure Ralph Loop approach within our GSD framework, maintaining Ralph's core simplicity while leveraging GSD's validation infrastructure.