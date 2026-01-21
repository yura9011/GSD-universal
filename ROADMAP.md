# ROADMAP.md

> **Current Milestone**: gsd-universal
> **Goal**: Transform GSD into the first truly IDE-agnostic framework for AI development

## Must-Haves

- [ ] Universal validation protocol (no IDE-specific dependencies)
- [ ] Generic subagent/parallel processing pattern
- [ ] IDE-agnostic file structure and conventions
- [ ] Cross-IDE workflow compatibility
- [ ] Universal Ralph Loop (protocol-based, not CLI-based)
- [ ] Adapter system for IDE-specific optimizations
- [ ] Backward compatibility with existing GSD projects
- [ ] Multi-IDE documentation and examples

## Nice-to-Haves

- [ ] GSD Universal CLI for non-IDE environments
- [ ] Browser-based GSD interface
- [ ] Community plugin ecosystem
- [ ] Integration with traditional code editors
- [ ] GSD Universal marketplace/registry

## Phases

### Phase 1: Core Protocol Abstraction
**Status**: ✅ Complete
**Objective**: Extract IDE-agnostic core from current GSD implementation

**Key Deliverables:**
- ✅ Universal validation protocol (replaces getDiagnostics)
- ✅ Generic parallel processing pattern (replaces invokeSubAgent)
- ✅ IDE-agnostic file structure (no .kiro/ dependencies)
- ✅ Universal workflow definitions
- ✅ Universal environment setup guide

### Phase 2: Adapter System Design
**Status**: ⬜ Not Started  
**Objective**: Create IDE-specific adapters that implement universal protocol

**Key Deliverables:**
- Adapter interface specification
- Kiro adapter (maintains current functionality)
- Claude Code adapter
- Generic IDE adapter (fallback)

### Phase 3: Ralph Universal Protocol
**Status**: ⬜ Not Started
**Objective**: Transform Ralph Loop into pure protocol-based system

**Key Deliverables:**
- Protocol-based Ralph (no external CLI dependencies)
- Self-executing within IDE context
- Universal prompt templates
- Cross-IDE compatibility validation

### Phase 4: Documentation & Migration
**Status**: ⬜ Not Started
**Objective**: Enable seamless adoption across all AI IDEs

**Key Deliverables:**
- GSD Universal specification document
- Migration guides for each supported IDE
- Multi-IDE setup tutorials
- Community adoption toolkit

### Phase 5: Community & Ecosystem
**Status**: ⬜ Not Started
**Objective**: Establish GSD Universal as the industry standard

**Key Deliverables:**
- Community governance model
- Plugin/extension ecosystem framework
- Integration partnerships with IDE vendors
- Adoption metrics and feedback systems

## Timeline

- **Phase 1**: 1 week (Core Protocol Abstraction)
- **Phase 2**: 1 week (Adapter System Design)  
- **Phase 3**: 1 week (Ralph Universal Protocol)
- **Phase 4**: 1 week (Documentation & Migration)
- **Phase 5**: 2 weeks (Community & Ecosystem)

**Total**: ~6 weeks (Target: 2026-03-15)

## Success Metrics

### Technical Success
- GSD works identically in 5+ different AI IDEs
- Zero IDE-specific code in core GSD protocol
- 100% backward compatibility with existing projects
- <5 minute setup time in any supported IDE
- Universal Ralph Loop executes in any AI IDE

### Adoption Success  
- Community adoption in 3+ different IDE ecosystems
- 10+ community contributions/adaptations
- Documentation available for major AI IDEs
- 95% user satisfaction across different IDEs

### Impact Success
- Referenced as standard methodology for AI development
- Eliminates vendor lock-in for AI development teams
- Enables seamless IDE switching without workflow disruption
- Establishes GSD as the platform-agnostic solution

## Previous Milestones

### ralph-loop (In Progress 2026-01-20)
**Goal**: Implement autonomous execution loop (Ralph) for GSD framework

**Current Status**: Phase 1 completed with gap closure
- ✅ Core Ralph Engine implemented
- ✅ Cross-platform compatibility (bash + PowerShell)
- ✅ Integration with GSD validation system
- ✅ AI-agnostic design (works with kiro, claude, openai, etc.)

### kiro-integration (Completed 2026-01-20)
**Goal**: Modernize GSD to leverage Kiro IDE native capabilities

**Completed Deliverables:**
- ✅ Hooks system for auto-validation and Planning Lock
- ✅ Skills for executable templates with validation
- ✅ Subagents for context-efficient operations (99% savings)
- ✅ 25 slash commands with Kiro integration
- ✅ Complete documentation and cross-platform portability

## Revolutionary Vision

**GSD Universal will be:**
- **The jQuery of AI development** - same API, works everywhere
- **The first truly portable AI methodology** - switch IDEs seamlessly
- **The community standard** - adopted across all AI IDE ecosystems  
- **Future-proof foundation** - compatible with IDEs that don't exist yet

This milestone transforms GSD from a Kiro-specific tool into the universal standard for AI-assisted development, working identically across all current and future AI IDEs.