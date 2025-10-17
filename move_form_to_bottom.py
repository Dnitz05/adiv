#!/usr/bin/env python3
"""Script to move the _buildDrawFormCard widget to the bottom of the home page."""

import re

def move_form_to_bottom():
    file_path = r'C:\tarot\smart-divination\apps\tarot\lib\main.dart'

    # Read the file
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Pattern to find and remove the _buildDrawFormCard from its current position
    # This is around line 2001-2005
    form_pattern = r'(\s*)// Draw form card \(without button\)\n\s*Padding\(\n\s*padding: const EdgeInsets\.symmetric\(horizontal: 8\),\n\s*child: _buildDrawFormCard\(localisation\),\n\s*\),'

    # Find the pattern
    form_match = re.search(form_pattern, content)
    if not form_match:
        print("Could not find the _buildDrawFormCard pattern")
        return False

    # Remove the form from its current position
    content = re.sub(form_pattern, '', content)

    # Now find the Stack children array to add the new Positioned widget
    # We need to find where the current Positioned button is and add our form before it

    # Pattern to find the Positioned button (around line 2043)
    button_pattern = r'(\s*)(// Sticky button at bottom\n\s*Positioned\(\n\s*bottom: bottomSpacing,)'

    # Create the new Positioned widget for the form
    new_form_widget = '''    // Form card fixed at bottom (above button)
    Positioned(
      bottom: 100, // Position above the button
      left: 8,
      right: 8,
      child: _buildDrawFormCard(localisation),
    ),
    '''

    # Insert the new Positioned form widget before the button
    content = re.sub(button_pattern, new_form_widget + r'\1\2', content)

    # Write the modified content back
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

    print("Successfully moved _buildDrawFormCard to bottom as Positioned widget")
    return True

if __name__ == '__main__':
    move_form_to_bottom()
