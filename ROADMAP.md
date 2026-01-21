# ROADMAP.md

> **Current Milestone**: ralph-loop
> **Goal**: Implement autonomous execution loop (Ralph) for GSD framework with Kiro IDE integration

## Must-Haves

- [ ] Ralph Loop engine (loop.sh script) for autonomous execution
- [ ] AGENTS.md operational manual for autonomous agents
- [ ] PROMPT_build.md template for build mode execution
- [ ] PROMPT_plan.md template for planning mode execution
- [ ] Integration with existing GSD validation scripts
- [ ] Backpressure validation system for quality gates
- [ ] Cross-platform compatibility (Windows/Linux/Mac)
- [ ] Documentation and usage examples

## Nice-to-Haves

- [ ] Web interface for monitoring Ralph execution
- [ ] Integration with CI/CD pipelines
- [ ] Advanced error recovery mechanisms
- [ ] Performance metrics and analytics
- [ ] Multi-project Ralph orchestration

## Phases

### Phase 1: Core Ralph Engine
**Status**: ⬜ Not Started
**Objective**: Implement the basic Ralph Loop engine with autonomous execution capabilities

**Key Deliverables:**
- loop.sh script for autonomous execution
- Cross-platform compatibility (PowerShell equivalent)
- Basic error handling and recovery
- Integration with existing validation scripts

### Phase 2: Agent Operational System
**Status**: ⬜ Not Started
**Objective**: Create operational manual and prompt templates for autonomous agents

**Key Deliverables:**
- AGENTS.md operational manual
- PROMPT_build.md for build mode
- PROMPT_plan.md for planning mode
- Validation integration with backpressure system

### Phase 3: Kiro IDE Integration
**Status**: ⬜ Not Started
**Objective**: Integrate Ralph Loop with Kiro-specific features and capabilities

**Key Deliverables:**
- Kiro hooks integration for Ralph execution
- Subagent support for autonomous operations
- Skills integration for Ralph workflows
- Slash command for Ralph control

### Phase 4: Quality Gates & Validation
**Status**: ⬜ Not Started
**Objective**: Implement comprehensive validation and quality control systems

**Key Deliverables:**
- Backpressure validation system
- Integration with existing GSD validation scripts
- Error recovery and retry mechanisms
- Quality metrics and reporting

### Phase 5: Documentation & Examples
**Status**: ⬜ Not Started
**Objective**: Complete documentation and provide practical examples

**Key Deliverables:**
- Complete Ralph Loop documentation
- Usage examples and tutorials
- Best practices guide
- Migration guide from manual to autonomous execution

## Timeline

- **Phase 1**: 1 week (Core Ralph Engine)
- **Phase 2**: 1 week (Agent Operational System)
- **Phase 3**: 1 week (Kiro IDE Integration)
- **Phase 4**: 1 week (Quality Gates & Validation)
- **Phase 5**: 1 week (Documentation & Examples)

**Total**: ~5 weeks (Target: 2026-03-01)

## Success Metrics

- Ralph Loop can autonomously execute complete phases without human intervention
- 95% success rate on validation scripts during autonomous execution
- Zero manual intervention required for standard development workflows
- Complete integration with existing GSD framework
- Cross-platform compatibility verified on Windows, Linux, and Mac
- Documentation enables users to implement Ralph in 15 minutes

## Previous Milestones

### kiro-integration (Completed 2026-01-20)
**Goal**: Modernizar GSD para aprovechar capacidades nativas de Kiro IDE

**Completed Deliverables:**
- ✅ Sistema de Hooks para auto-validación (PostToolUse) en fase /execute
- ✅ Skills ejecutables que reemplacen templates estáticos
- ✅ Subagentes para operaciones que consumen mucho contexto (/map, /research-phase)
- ✅ Hooks PreToolUse para enforcement de Planning Lock
- ✅ Documentación actualizada con ejemplos de Kiro
- ✅ Scripts de validación embebidos en Skills
- ✅ Migración de comandos GSD a formato Kiro-compatible