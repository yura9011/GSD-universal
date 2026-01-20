#!/usr/bin/env python3
"""
SPEC.md Validator

Validates SPEC.md structure and content.
"""

import sys
import os

# Add skills utils to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', 'utils'))

from validator_base import SkillValidator


class SpecValidator(SkillValidator):
    """Validator for SPEC.md files."""
    
    REQUIRED_SECTIONS = [
        "Vision",
        "Goals",
        "Non-Goals",
        "Constraints",
        "Success Criteria"
    ]
    
    def validate(self, file_path: str) -> bool:
        """
        Validate SPEC.md file.
        
        Args:
            file_path: Path to SPEC.md
            
        Returns:
            bool: True if valid, False otherwise
        """
        # Check file exists
        if not self.check_file_exists(file_path):
            self.report_error(f"File not found: {file_path}")
            return False
        
        # Read content
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            self.report_error(f"Error reading file: {e}")
            return False
        
        # Check YAML frontmatter
        yaml = self.check_yaml_frontmatter(content)
        if not yaml:
            self.report_error("Missing or invalid YAML frontmatter")
            self.report_error("Expected format:")
            self.report_error("---")
            self.report_error("status: DRAFT | FINALIZED")
            self.report_error("---")
            return False
        
        # Check status field
        if 'status' not in yaml:
            self.report_error("Missing 'status' field in frontmatter")
            self.report_error("Add: status: DRAFT")
            return False
        
        # Check required sections
        missing_sections = []
        for section in self.REQUIRED_SECTIONS:
            if not self.check_section_exists(content, section):
                missing_sections.append(section)
        
        if missing_sections:
            self.report_error("Missing required sections:")
            for section in missing_sections:
                self.report_error(f"  - ## {section}")
            return False
        
        # Check sections are not empty (basic check)
        for section in self.REQUIRED_SECTIONS:
            # Look for section followed immediately by another section or end
            if f"## {section}\n\n##" in content or f"## {section}\n---" in content:
                self.report_error(f"Section '{section}' appears to be empty")
                self.report_error(f"Add content after ## {section}")
                return False
        
        return True


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: validate_spec.py <spec-file>", file=sys.stderr)
        print("", file=sys.stderr)
        print("Example:", file=sys.stderr)
        print("  python validate_spec.py SPEC.md", file=sys.stderr)
        sys.exit(1)
    
    validator = SpecValidator()
    if validator.validate(sys.argv[1]):
        print("✓ SPEC.md validation passed")
        print("  All required sections present")
        print("  Structure is correct")
        sys.exit(0)
    else:
        print("", file=sys.stderr)
        print("Fix the issues above and run validation again.", file=sys.stderr)
        sys.exit(1)
