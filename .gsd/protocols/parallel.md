# Universal Parallel Processing Protocol

## Overview

This protocol defines universal patterns for coordinating multiple tasks that work in any environment with any AI assistant, using only file-based coordination and standard operations.

## Core Principles

1. **Environment Agnostic**: Works with terminal + AI chat, any IDE, or web-based environments
2. **AI Agnostic**: Functions identically with any AI assistant or human execution
3. **File-Based Coordination**: Uses standard files and git for task management
4. **Graceful Degradation**: Clear sequential execution when parallel processing unavailable

## Task Coordination Patterns

### File-Based Task Queue

Tasks are managed through standardized markdown files in `.gsd/tasks/` directory:

```
.gsd/tasks/
├── queue.md          # Active task queue
├── in-progress.md    # Currently executing tasks
├── completed.md      # Finished tasks with results
└── failed.md         # Failed tasks with error details
```

### Task Definition Format

Each task follows this standard format:

```markdown
## Task: {unique-id}
- **Type**: {research|implementation|verification|documentation}
- **Priority**: {high|medium|low}
- **Dependencies**: {comma-separated task IDs}
- **Assigned**: {ai-assistant|human|auto}
- **Status**: {queued|in-progress|completed|failed}
- **Created**: {timestamp}
- **Updated**: {timestamp}

### Description
{Clear description of what needs to be done}

### Context Files
- {list of relevant files to read}

### Success Criteria
- [ ] {measurable outcome 1}
- [ ] {measurable outcome 2}

### Results
{filled when task completes}
```

## Execution Patterns

### Pattern 1: Parallel Execution (When Available)

For AI assistants that support parallel processing:

1. **Task Distribution**: Split work into independent tasks
2. **Concurrent Execution**: Execute tasks simultaneously
3. **Status Synchronization**: Update status files as tasks complete
4. **Result Aggregation**: Combine results when all tasks finish

### Pattern 2: Sequential Execution (Universal Fallback)

For any environment:

1. **Task Ordering**: Sort tasks by dependencies and priority
2. **Sequential Processing**: Execute one task at a time
3. **Progress Tracking**: Update status after each task
4. **Clear Indicators**: Show progress to user throughout execution

### Pattern 3: Manual Coordination (Human Fallback)

When AI coordination unavailable:

1. **Task Breakdown**: Provide clear task list with instructions
2. **Manual Execution**: Human executes tasks following guidelines
3. **Status Updates**: Human updates status files manually
4. **Verification**: Clear checkpoints to verify completion

## Cross-Platform Implementation

### Bash Implementation
```bash
#!/bin/bash
# Universal task coordination

TASK_DIR=".gsd/tasks"
mkdir -p "$TASK_DIR"

# Initialize task queue
init_task_queue() {
    echo "# Task Queue" > "$TASK_DIR/queue.md"
    echo "# In Progress" > "$TASK_DIR/in-progress.md"
    echo "# Completed Tasks" > "$TASK_DIR/completed.md"
    echo "# Failed Tasks" > "$TASK_DIR/failed.md"
}

# Add task to queue
add_task() {
    local task_id="$1"
    local description="$2"
    local timestamp=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    
    cat >> "$TASK_DIR/queue.md" << EOF

## Task: $task_id
- **Type**: implementation
- **Priority**: medium
- **Dependencies**: none
- **Assigned**: auto
- **Status**: queued
- **Created**: $timestamp
- **Updated**: $timestamp

### Description
$description

### Success Criteria
- [ ] Task completed successfully

EOF
}

# Move task between states
move_task() {
    local task_id="$1"
    local from_file="$2"
    local to_file="$3"
    
    # Extract task block and move it
    sed -n "/^## Task: $task_id$/,/^## Task:/p" "$TASK_DIR/$from_file.md" | head -n -1 >> "$TASK_DIR/$to_file.md"
    sed -i "/^## Task: $task_id$/,/^## Task:/{/^## Task: $task_id$/d; /^## Task:/!d;}" "$TASK_DIR/$from_file.md"
}
```

### PowerShell Implementation
```powershell
# Universal task coordination

$TaskDir = ".gsd/tasks"
New-Item -ItemType Directory -Path $TaskDir -Force | Out-Null

# Initialize task queue
function Initialize-TaskQueue {
    "# Task Queue" | Out-File "$TaskDir/queue.md" -Encoding UTF8
    "# In Progress" | Out-File "$TaskDir/in-progress.md" -Encoding UTF8
    "# Completed Tasks" | Out-File "$TaskDir/completed.md" -Encoding UTF8
    "# Failed Tasks" | Out-File "$TaskDir/failed.md" -Encoding UTF8
}

# Add task to queue
function Add-Task {
    param(
        [string]$TaskId,
        [string]$Description
    )
    
    $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss UTC")
    
    $taskBlock = @"

## Task: $TaskId
- **Type**: implementation
- **Priority**: medium
- **Dependencies**: none
- **Assigned**: auto
- **Status**: queued
- **Created**: $timestamp
- **Updated**: $timestamp

### Description
$Description

### Success Criteria
- [ ] Task completed successfully

"@
    
    Add-Content "$TaskDir/queue.md" $taskBlock -Encoding UTF8
}

# Move task between states
function Move-Task {
    param(
        [string]$TaskId,
        [string]$FromFile,
        [string]$ToFile
    )
    
    $content = Get-Content "$TaskDir/$FromFile.md" -Raw
    # Implementation would extract and move task blocks
    # Simplified for example
}
```

## Workflow Integration Patterns

### Research Workflow Pattern
```markdown
## Research Coordination

### Traditional (invokeSubAgent)
```
invokeSubAgent({
  name: "research-agent",
  prompt: "Research topic X"
})
```

### Universal Pattern
```
1. Create research task in queue.md
2. Execute research following task template
3. Document findings in task results
4. Move task to completed.md
5. Aggregate results for main workflow
```

### Map Workflow Pattern
```markdown
## Codebase Analysis Coordination

### Traditional (invokeSubAgent)
```
invokeSubAgent({
  name: "context-gatherer", 
  prompt: "Analyze codebase structure"
})
```

### Universal Pattern
```
1. Break analysis into focused tasks:
   - File structure analysis
   - Dependency mapping  
   - Architecture documentation
2. Execute tasks sequentially or in parallel
3. Combine results into ARCHITECTURE.md
4. Verify completeness against requirements
```

## Status Tracking

### Progress Indicators
```
=== Task Execution Progress ===
✓ Task 1: File structure analysis (completed)
⏳ Task 2: Dependency mapping (in progress)  
⏸ Task 3: Architecture docs (queued)
❌ Task 4: Performance analysis (failed)

3/4 tasks processed, 1 remaining
```

### Status File Format
```markdown
# Execution Status

## Summary
- **Total Tasks**: 4
- **Completed**: 2  
- **In Progress**: 1
- **Failed**: 1
- **Remaining**: 0

## Timeline
- 14:30 - Started task queue processing
- 14:32 - Completed file structure analysis
- 14:35 - Started dependency mapping
- 14:38 - Failed performance analysis (tool unavailable)
- 14:40 - Completed dependency mapping

## Next Steps
- Retry failed tasks with manual fallback
- Aggregate completed results
- Update main workflow status
```

## Error Handling

### When Parallel Processing Unavailable
```
⚠ Parallel processing not available
📋 Switching to sequential execution
✓ Task queue initialized for sequential processing
💡 Tasks will execute one at a time with progress updates
```

### When AI Coordination Fails
```
❌ AI task coordination failed
📖 Switching to manual coordination mode
📋 Task list generated for human execution
💡 Follow task instructions and update status manually
```

### When File System Restricted
```
⚠ File system access limited
💾 Using git-based coordination
✓ Task status tracked via git commits
💡 Each task completion creates atomic commit
```

## Integration with GSD Workflows

### Execute Workflow Integration
```markdown
## Wave-Based Execution with Universal Coordination

### Wave 1 Tasks
1. Initialize task queue: `.gsd/tasks/queue.md`
2. Add wave 1 tasks to queue
3. Execute tasks (parallel if available, sequential otherwise)
4. Verify wave completion before proceeding

### Wave 2 Tasks  
1. Add wave 2 tasks to queue
2. Check wave 1 dependencies satisfied
3. Execute wave 2 tasks
4. Aggregate results and update roadmap
```

### Verify Workflow Integration
```markdown
## Verification with Task Coordination

1. Create verification task queue
2. Break verification into independent checks
3. Execute verification tasks
4. Aggregate results into VERIFICATION.md
5. Report overall phase status
```

## Success Criteria

This protocol succeeds when:
- Works identically in any environment (terminal, IDE, web)
- Provides clear coordination with or without parallel processing
- Maintains task visibility and progress tracking
- Enables confident multi-task execution anywhere
- Requires zero IDE-specific features
- Supports both AI and human task execution