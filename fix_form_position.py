#!/usr/bin/env python3
"""Fix the form position in main.dart"""

def fix_form_position():
    file_path = r'C:\tarot\smart-divination\apps\tarot\lib\main.dart'

    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    # Find and remove the incorrectly placed widget (around line 2015-2021)
    # Looking for the pattern that was inserted incorrectly
    i = 0
    while i < len(lines):
        line = lines[i]
        if '// Form card fixed at bottom' in line and i > 2000:
            # Remove this incorrectly placed section
            # Remove from here until we find the next Positioned
            j = i
            while j < len(lines) and 'Positioned' not in lines[j]:
                j += 1
            # Now remove the incorrectly formed Positioned widget
            while j < len(lines) and '),\n' not in lines[j]:
                j += 1
            j += 1  # Include the closing line

            # Keep only up to i
            lines = lines[:i] + lines[j:]
            break
        i += 1

    # Now find where we should insert the new Positioned widget
    # Look for the Stack's children array and the original form card position
    i = 0
    form_start = -1
    form_end = -1

    while i < len(lines):
        line = lines[i]
        # Find where the form card was originally (around line 2001-2005)
        if '// Draw form card (without button)' in line:
            form_start = i
            # Find the end of this widget
            j = i + 1
            paren_count = 0
            while j < len(lines):
                paren_count += lines[j].count('(') - lines[j].count(')')
                if '),' in lines[j] and paren_count <= 0:
                    form_end = j + 1
                    break
                j += 1
            break
        i += 1

    if form_start >= 0 and form_end >= 0:
        # Remove the form from its original position
        removed_section = lines[form_start:form_end]
        lines = lines[:form_start] + lines[form_end:]

    # Now find where to insert the new Positioned widget
    # Find the Stack's children closing point, before the last Positioned (the button)
    i = 0
    insert_pos = -1
    while i < len(lines):
        if '// Sticky button at bottom' in lines[i]:
            insert_pos = i
            break
        i += 1

    if insert_pos >= 0:
        # Insert the new Positioned widget before the button
        new_widget = [
            '    // Form card fixed at bottom (above button)\n',
            '    Positioned(\n',
            '      bottom: 100, // Position above the button\n',
            '      left: 8,\n',
            '      right: 8,\n',
            '      child: _buildDrawFormCard(localisation),\n',
            '    ),\n',
        ]
        lines = lines[:insert_pos] + new_widget + lines[insert_pos:]

    # Write back
    with open(file_path, 'w', encoding='utf-8') as f:
        f.writelines(lines)

    print(f"Fixed form position. Removed from line {form_start}, inserted at line {insert_pos}")

if __name__ == '__main__':
    fix_form_position()
