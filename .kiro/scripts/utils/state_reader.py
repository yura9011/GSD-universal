#!/usr/bin/env python3
"""
State Reader

Utilities for reading and parsing STATE.md file.
"""

import os
import re
from typing import Dict, Optional


def read_state(state_file: str = "STATE.md") -> Dict[str, str]:
    """
    Read and parse STATE.md file.
    
    Args:
        state_file: Path to STATE.md (default: "STATE.md" in current dir)
        
    Returns:
        dict: Parsed state with keys like 'status', 'phase', 'milestone'
    """
    state = {
        "status": "unknown",
        "phase": "unknown",
        "milestone": "unknown"
    }
    
    if not os.path.exists(state_file):
        return state
    
    try:
        with open(state_file, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Extract status
        status_match = re.search(r'\*\*Status\*\*:\s*(.+?)(?:\n|$)', content)
        if status_match:
            state["status"] = status_match.group(1).strip()
            
        # Extract phase
        phase_match = re.search(r'\*\*Phase\*\*:\s*(.+?)(?:\n|$)', content)
        if phase_match:
            state["phase"] = phase_match.group(1).strip()
            
        # Extract milestone
        milestone_match = re.search(r'\*\*Milestone\*\*:\s*(.+?)(?:\n|$)', content)
        if milestone_match:
            state["milestone"] = milestone_match.group(1).strip()
            
    except Exception as e:
        print(f"Warning: Could not read STATE.md: {e}")
        
    return state


def is_planning_phase(state_file: str = "STATE.md") -> bool:
    """
    Check if current state is in planning phase.
    
    Returns True if:
    - Status contains "planning" (case-insensitive)
    - Status contains "DRAFT"
    - Phase is "Not started"
    
    Args:
        state_file: Path to STATE.md
        
    Returns:
        bool: True if in planning phase, False otherwise
    """
    state = read_state(state_file)
    status = state["status"].lower()
    phase = state["phase"].lower()
    
    # Check for planning indicators
    if "planning" in status:
        return True
    if "draft" in status:
        return True
    if "not started" in phase:
        return True
        
    return False


def get_current_phase(state_file: str = "STATE.md") -> Optional[str]:
    """Get current phase number/name from STATE.md."""
    state = read_state(state_file)
    return state.get("phase")


if __name__ == "__main__":
    # Test mode: display current state
    state = read_state()
    print(f"Status: {state['status']}")
    print(f"Phase: {state['phase']}")
    print(f"Milestone: {state['milestone']}")
    print(f"Is Planning: {is_planning_phase()}")
