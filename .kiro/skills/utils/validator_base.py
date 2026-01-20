#!/usr/bin/env python3
"""
Skill Validator Base Class

Base class for all GSD skill validators.
Provides common validation methods.
"""

import os
import sys
import re
from typing import Optional, Dict


class SkillValidator:
    """Base class for skill validators."""
    
    def check_file_exists(self, path: str) -> bool:
        """
        Check if file exists.
        
        Args:
            path: File path to check
            
        Returns:
            bool: True if file exists, False otherwise
        """
        return os.path.exists(path) and os.path.isfile(path)
    
    def check_section_exists(self, content: str, section: str) -> bool:
        """
        Check if a section header exists in content.
        
        Args:
            content: File content to search
            section: Section name (without ## prefix)
            
        Returns:
            bool: True if section found, False otherwise
        """
        # Match ## Section or ### Section
        pattern = rf'^##+ {re.escape(section)}'
        return bool(re.search(pattern, content, re.MULTILINE))
    
    def check_yaml_frontmatter(self, content: str) -> Optional[Dict[str, str]]:
        """
        Extract and parse YAML frontmatter.
        
        Args:
            content: File content
            
        Returns:
            dict: Parsed YAML as dict, or None if invalid/missing
        """
        # Match YAML frontmatter between --- markers
        match = re.match(r'^---\s*\n(.*?)\n---\s*\n', content, re.DOTALL)
        if not match:
            return None
        
        yaml_content = match.group(1)
        
        # Simple YAML parser (key: value format)
        result = {}
        for line in yaml_content.split('\n'):
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            
            if ':' in line:
                key, value = line.split(':', 1)
                result[key.strip()] = value.strip()
        
        return result if result else None
    
    def report_error(self, message: str) -> None:
        """
        Report validation error to stderr.
        
        Args:
            message: Error message to display
        """
        print(f"✗ {message}", file=sys.stderr)
    
    def validate(self, file_path: str) -> bool:
        """
        Validate file. Override in subclasses.
        
        Args:
            file_path: Path to file to validate
            
        Returns:
            bool: True if validation passes, False otherwise
        """
        raise NotImplementedError("Subclasses must implement validate()")


if __name__ == "__main__":
    # Test mode
    print("SkillValidator base class")
    print("This is a base class - use subclasses for actual validation")
