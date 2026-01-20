---
phase: 6
plan: 2
wave: 1
milestone: v1.1
---

# Plan 6.2: Create Documentation Directory

## Objective
Create a docs/ directory and move documentation files for better organization. Keep README.md and QUICKSTART.md in root for visibility, but move other docs.

## Context
- Documentation is currently scattered in root
- Need centralized docs/ directory
- README.md and QUICKSTART.md should stay in root (GitHub convention)

## Tasks

<task type="auto">
  <name>Create docs directory structure</name>
  <files>docs/</files>
  <action>
    Create docs/ directory with organized structure:
    
    ```
    docs/
    ├── ARCHITECTURE.md (if exists, move from root)
    ├── CONTRIBUTING.md (create new)
    └── TROUBLESHOOTING.md (extract from README.md)
    ```
    
    Steps:
    1. Create docs/ directory
    2. If ARCHITECTURE.md exists in root, move it to docs/
    3. Create docs/CONTRIBUTING.md with basic contribution guidelines:
       - How to set up development environment
       - How to run tests
       - Code style guidelines (no emojis, professional prefixes)
    4. Create docs/TROUBLESHOOTING.md by extracting troubleshooting section from README.md
    
    IMPORTANT:
    - Keep README.md and QUICKSTART.md in root
    - Update any references to moved files
    - Keep documentation professional and emoji-free
  </action>
  <verify>dir docs</verify>
  <done>docs/ directory created with organized documentation</done>
</task>

<task type="auto">
  <name>Update README.md references</name>
  <files>README.md</files>
  <action>
    Update README.md to reference new docs/ structure:
    
    Changes:
    1. Add "Documentation" section near top:
       ```markdown
       ## Documentation
       
       - [Quick Start Guide](QUICKSTART.md)
       - [Architecture](docs/ARCHITECTURE.md)
       - [Troubleshooting](docs/TROUBLESHOOTING.md)
       - [Contributing](docs/CONTRIBUTING.md)
       ```
    
    2. Replace detailed troubleshooting section with:
       ```markdown
       ## Troubleshooting
       
       For detailed troubleshooting, see [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).
       
       Quick fixes:
       - VB-Cable not found: Install and restart PC
       - Python 3.14 error: Use Python 3.11 or 3.12
       - No audio: Check Discord uses "CABLE Output"
       ```
    
    IMPORTANT:
    - Keep README.md concise
    - Maintain professional style
    - All links should work
  </action>
  <verify>cat README.md | Select-String "docs/"</verify>
  <done>README.md updated with docs/ references</done>
</task>

## Success Criteria
- [ ] docs/ directory exists
- [ ] Documentation files organized in docs/
- [ ] README.md references docs/ structure
- [ ] All documentation links work
- [ ] README.md and QUICKSTART.md remain in root
