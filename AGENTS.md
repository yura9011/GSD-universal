# AGENTS.md

## Validation Commands (Backpressure)

Run these commands before marking any task complete:

**Windows**:
- Consolidated validation: `./scripts/validate.ps1 -All`
- Specific validation: `./scripts/validate.ps1 -Code -Workflows`
- Run bash scripts: `./scripts/run-bash.ps1 ./scripts/validate.sh --all`

**Linux/Mac**:
- Consolidated validation: `./scripts/validate.sh --all`
- Specific validation: `./scripts/validate.sh --code --workflows`

**All platforms**:
- Git status: `git status --porcelain` (should be clean after commit)

## Project Conventions

- Use markdown for all documentation
- Follow GSD framework structure and patterns
- Atomic commits with format: `feat(phase-N): description`
- All scripts must be cross-platform (bash + PowerShell)
- Keep AGENTS.md under 60 lines (operational only)
- Status updates go in IMPLEMENTATION_PLAN.md, not here

## Build/Test Commands

- Consolidated validation: `./scripts/validate.sh --all` or `./scripts/validate.ps1 -All`
- Specific validation: `./scripts/validate.sh --code --workflows` or `./scripts/validate.ps1 -Code -Workflows`
- Legacy validation: `./scripts/validate-all.sh` or `./scripts/validate-all.ps1`
- Test loop scripts: `./loop.sh --dry-run` or `./loop.ps1 -DryRun`
- Check file structure: `ls -la` or `Get-ChildItem`
- Verify git state: `git status`

## Ralph Loop Operations

- Build mode: `./scripts/ralph.sh build` or `./scripts/ralph.ps1 -Mode build`
- Plan mode: `./scripts/ralph.sh plan` or `./scripts/ralph.ps1 -Mode plan`
- Manual mode: `./scripts/ralph.sh --manual` or `./scripts/ralph.ps1 -Manual`
- Dry run: `./scripts/ralph.sh --dry-run` or `./scripts/ralph.ps1 -DryRun`
- Help: `./scripts/ralph.sh --help` or `./scripts/ralph.ps1 -Help`

Note: Universal Ralph works with any AI (ChatGPT, Claude, Kiro, etc.)

## File Structure Requirements

- PROMPT_build.md and PROMPT_plan.md must exist
- IMPLEMENTATION_PLAN.md tracks current tasks
- specs/ directory contains static requirements
- All files use UTF-8 encoding with LF line endings

## Quality Gates

- No task marked complete without validation passing
- All changes committed atomically with descriptive messages
- Cross-platform compatibility verified
- Documentation updated when operational procedures change

## Emergency Procedures

- If loop fails repeatedly: Check IMPLEMENTATION_PLAN.md for issues
- If validation fails: Fix issues before continuing
- If git conflicts: Resolve manually, then resume loop
- If context pollution: Restart loop for fresh context