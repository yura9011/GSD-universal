# ROADMAP.md

> **Current Milestone**: kiro-integration
> **Goal**: Modernizar GSD para aprovechar capacidades nativas de Kiro IDE

## Must-Haves

- [ ] Sistema de Hooks para auto-validación (PostToolUse) en fase /execute
- [ ] Skills ejecutables que reemplacen templates estáticos
- [ ] Subagentes para operaciones que consumen mucho contexto (/map, /research-phase)
- [ ] Hooks PreToolUse para enforcement de Planning Lock
- [ ] Documentación actualizada con ejemplos de Kiro
- [ ] Scripts de validación embebidos en Skills
- [ ] Migración de comandos GSD a formato Kiro-compatible

## Phases

### Phase 1: Hooks Foundation
**Status**: ✅ Complete
**Objective**: Implementar sistema de hooks para auto-validación y enforcement de reglas GSD

**Key Deliverables:**
- PostToolUse hooks para validación automática de código
- PreToolUse hooks para Planning Lock enforcement
- Hook de validación de sintaxis (linters)
- Scripts de validación en Python/PowerShell
- Configuración de hooks en `.kiro/hooks/`

### Phase 2: Skills Migration
**Status**: ✅ Complete
**Objective**: Convertir templates estáticos a Skills ejecutables con scripts embebidos

**Key Deliverables:**
- Skill para SPEC.md con validador programático
- Skill para ROADMAP.md con validador de estructura
- Skill para generación de commits atómicos
- Skill para verificación empírica con evidencia
- Scripts de validación embebidos en cada Skill
- Skill para generación de commits atómicos
- Skill para verificación empírica con evidencia
- Scripts de validación embebidos en cada Skill

### Phase 3: Subagent Integration
**Status**: ✅ Complete
**Objective**: Implementar subagentes para operaciones de alto contexto

**Key Deliverables:**
- Subagente para /map (context:fork, read-only)
- Subagente para /research-phase (context:fork)
- Subagente para /verify con paralelización
- Configuración de subagentes en `.kiro/agents/`
- Documentación de cuándo usar subagentes vs main conversation

### Phase 4: Command Modernization
**Status**: ⬜ Not Started
**Objective**: Actualizar comandos GSD a formato Slash Commands de Kiro

**Key Deliverables:**
- Migrar 25 comandos GSD a `.kiro/commands/`
- Agregar frontmatter con allowed-tools
- Implementar argument-hint para cada comando
- Agregar bash command execution donde sea necesario
- Mantener compatibilidad con workflows existentes

### Phase 5: Documentation & Testing
**Status**: ⬜ Not Started
**Objective**: Documentar nuevas capacidades y validar integración completa

**Key Deliverables:**
- Actualizar `.gsd/SYSTEM.md` con features de Kiro
- Crear guías de uso para Hooks, Skills, Subagents
- Ejemplos prácticos de cada feature
- Tests de integración end-to-end
- Guía de migración para usuarios existentes

## Nice-to-Haves

- [ ] Paralelización de verificaciones usando subagentes
- [ ] Hooks de notificación para eventos importantes
- [ ] Skills visuales (generación de diagramas de arquitectura)
- [ ] Integración con MCP para herramientas externas
- [ ] Dashboard interactivo de progreso del proyecto

## Timeline

- **Phase 1**: 1 week (Hooks Foundation)
- **Phase 2**: 1 week (Skills Migration)
- **Phase 3**: 1 week (Subagent Integration)
- **Phase 4**: 1 week (Command Modernization)
- **Phase 5**: 1 week (Documentation & Testing)

**Total**: ~5 weeks (Target: 2026-02-15)

## Success Metrics

- Zero syntax errors in generated code (hooks validation)
- 90% reduction in manual verification steps
- Context window usage reduced by 50% (subagents)
- All 25 GSD commands working in Kiro
- 100% test coverage for critical workflows
