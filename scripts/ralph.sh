#!/bin/bash

# ralph.sh - Universal Ralph Loop coordinator
# Works with ANY AI assistant (no CLI dependencies)

set -euo pipefail

# Configuration
MODE="build"
MAX_ITERATIONS=50
MANUAL_MODE=false
DRY_RUN=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Usage
show_help() {
    cat << EOF
Universal Ralph Loop - AI Coordination Protocol

USAGE:
    ./ralph.sh [MODE] [OPTIONS]

MODES:
    build       Execute PROMPT_build.md (default)
    plan        Execute PROMPT_plan.md

OPTIONS:
    --manual    Manual mode (just show prompts, no automation)
    --dry-run   Validate setup without executing
    -i NUM      Maximum iterations (default: 50)
    -h, --help  Show this help

EXAMPLES:
    ./ralph.sh build              # Build mode, interactive
    ./ralph.sh plan               # Planning mode
    ./ralph.sh --manual           # Manual mode (no automation)
    ./ralph.sh --dry-run          # Validate setup

UNIVERSAL PROTOCOL:
Ralph works with ANY AI assistant:
- ChatGPT web interface
- Claude web interface
- Kiro IDE
- VS Code + Copilot
- Terminal + any AI

See .gsd/protocols/ralph-loop.md for complete protocol.

EOF
}

# Logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validate setup
validate_setup() {
    local errors=0
    
    log_info "Validating Ralph Loop setup..."
    
    # Check required files
    local prompt_file="PROMPT_${MODE}.md"
    if [[ ! -f "$prompt_file" ]]; then
        log_error "Missing prompt file: $prompt_file"
        ((errors++))
    fi
    
    if [[ ! -f "IMPLEMENTATION_PLAN.md" ]]; then
        log_error "Missing IMPLEMENTATION_PLAN.md"
        ((errors++))
    fi
    
    if [[ ! -f "AGENTS.md" ]]; then
        log_error "Missing AGENTS.md"
        ((errors++))
    fi
    
    if [[ ! -d "specs" ]]; then
        log_error "Missing specs/ directory"
        ((errors++))
    fi
    
    # Check git
    if ! command -v git &> /dev/null; then
        log_error "Git not found - required for Ralph Loop"
        ((errors++))
    fi
    
    # Check validation scripts (optional but recommended)
    if [[ -f "scripts/validate.sh" ]]; then
        log_info "Found validation script: scripts/validate.sh"
    else
        log_warning "Validation script not found (optional)"
    fi
    
    if [[ $errors -eq 0 ]]; then
        log_success "Ralph Loop setup validation passed"
        return 0
    else
        log_error "Ralph Loop setup validation failed with $errors errors"
        return 1
    fi
}

# Show prompt to user
show_prompt() {
    local prompt_file="$1"
    local iteration="$2"
    
    clear
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " RALPH LOOP - Iteration $iteration/$MAX_ITERATIONS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Mode: $MODE"
    echo "Prompt file: $prompt_file"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    cat "$prompt_file"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Wait for user to execute AI
wait_for_user() {
    echo ""
    echo "INSTRUCTIONS:"
    echo "1. Copy the prompt above to your AI assistant"
    echo "2. Execute the prompt with your AI (ChatGPT, Claude, Kiro, etc.)"
    echo "3. Let the AI complete its work"
    echo "4. Press ENTER when done to continue..."
    echo ""
    read -r
}

# Run validation
run_validation() {
    log_info "Running validation (backpressure)..."
    
    if [[ -x "./scripts/validate.sh" ]]; then
        if ./scripts/validate.sh --all; then
            log_success "Validation passed"
            return 0
        else
            log_error "Validation failed"
            return 1
        fi
    else
        log_warning "Validation script not found, skipping"
        return 0
    fi
}

# Check for git changes
check_git_changes() {
    if [[ -n $(git status --porcelain) ]]; then
        return 0  # Changes exist
    else
        return 1  # No changes
    fi
}

# Prompt for commit
prompt_commit() {
    echo ""
    log_info "Changes detected in git"
    echo "Do you want to commit these changes? (y/n)"
    read -r response
    
    if [[ "$response" == "y" ]]; then
        log_info "Creating commit..."
        git add -A
        
        echo "Enter commit message (or press ENTER for default):"
        read -r commit_msg
        
        if [[ -z "$commit_msg" ]]; then
            commit_msg="feat(ralph): iteration $1 complete"
        fi
        
        git commit -m "$commit_msg"
        
        echo "Push to remote? (y/n)"
        read -r push_response
        
        if [[ "$push_response" == "y" ]]; then
            git push
            log_success "Changes pushed to remote"
        fi
        
        log_success "Changes committed"
    else
        log_info "Skipping commit"
    fi
}

# Main Ralph Loop
run_ralph_loop() {
    local prompt_file="PROMPT_${MODE}.md"
    
    log_info "Starting Universal Ralph Loop"
    log_info "Mode: $MODE"
    log_info "Max iterations: $MAX_ITERATIONS"
    log_info "Manual mode: $MANUAL_MODE"
    echo ""
    
    # Create session log directory
    mkdir -p .ralph
    local session_log=".ralph/session-$(date +%Y%m%d-%H%M%S).log"
    log_info "Session log: $session_log"
    echo ""
    
    for ((iteration=1; iteration<=MAX_ITERATIONS; iteration++)); do
        # Log iteration start
        echo "=== Iteration $iteration started at $(date) ===" >> "$session_log"
        
        # Show prompt
        show_prompt "$prompt_file" "$iteration"
        
        # Wait for user to execute AI
        wait_for_user
        
        # Run validation
        if run_validation; then
            echo "Validation: PASS" >> "$session_log"
        else
            echo "Validation: FAIL" >> "$session_log"
            log_warning "Validation failed, but continuing..."
        fi
        
        # Check for git changes
        if check_git_changes; then
            prompt_commit "$iteration"
        else
            log_info "No changes detected"
        fi
        
        # Ask to continue
        echo ""
        echo "Continue to next iteration? (y/n)"
        read -r response
        
        if [[ "$response" != "y" ]]; then
            log_info "Stopping Ralph Loop at iteration $iteration"
            break
        fi
        
        echo ""
    done
    
    log_success "Ralph Loop completed"
    log_info "Session log: $session_log"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        build|plan)
            MODE="$1"
            shift
            ;;
        --manual)
            MANUAL_MODE=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -i)
            MAX_ITERATIONS="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate setup
if ! validate_setup; then
    exit 1
fi

# Handle dry-run
if [[ "$DRY_RUN" == "true" ]]; then
    log_success "Dry-run complete - setup is valid"
    exit 0
fi

# Run Ralph Loop
run_ralph_loop

log_success "Universal Ralph Loop execution complete"
