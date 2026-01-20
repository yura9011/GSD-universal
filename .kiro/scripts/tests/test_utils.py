#!/usr/bin/env python3
"""
Tests for utility modules
"""

import unittest
import sys
import os
import json
from io import StringIO

# Add parent directory to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'utils'))

from hook_input import read_hook_input, get_tool_name, get_file_path
from state_reader import read_state, is_planning_phase


class TestHookInput(unittest.TestCase):
    """Test hook_input module."""
    
    def test_read_hook_input(self):
        """Test reading hook input from stdin."""
        test_input = {
            "tool_name": "Write",
            "tool_input": {"file_path": "/test/file.py"}
        }
        
        # Simulate stdin
        sys.stdin = StringIO(json.dumps(test_input))
        data = read_hook_input()
        
        self.assertEqual(data["tool_name"], "Write")
        self.assertEqual(data["tool_input"]["file_path"], "/test/file.py")
    
    def test_get_tool_name(self):
        """Test extracting tool name."""
        data = {"tool_name": "Edit"}
        self.assertEqual(get_tool_name(data), "Edit")
    
    def test_get_file_path(self):
        """Test extracting file path."""
        data = {"tool_input": {"file_path": "/test.py"}}
        self.assertEqual(get_file_path(data), "/test.py")


class TestStateReader(unittest.TestCase):
    """Test state_reader module."""
    
    def test_read_state_missing_file(self):
        """Test reading non-existent STATE.md."""
        state = read_state("nonexistent.md")
        self.assertEqual(state["status"], "unknown")
    
    def test_is_planning_phase(self):
        """Test planning phase detection."""
        # This would need a mock STATE.md file
        # For now, just test it doesn't crash
        result = is_planning_phase("nonexistent.md")
        self.assertIsInstance(result, bool)


if __name__ == "__main__":
    unittest.main()
