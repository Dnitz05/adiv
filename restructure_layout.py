#!/usr/bin/env python3
"""
Script to restructure the Flutter home screen layout to make the button sticky at the bottom.
"""

import re

def restructure_layout(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find the bodyContent = CustomScrollView section and replace it with Stack-based layout
    # We need to:
    # 1. Replace CustomScrollView with Stack
    # 2. Wrap quote and banner in SingleChildScrollView
    # 3. Extract button and wrap it in Positioned widget

    # Pattern to find the CustomScrollView section
    pattern = r'(bodyContent = CustomScrollView\(\s*slivers: \[\s*SliverFillRemaining\(\s*hasScrollBody: false,\s*child: Column\(\s*children: \[)'

    # Find the pattern
    match = re.search(pattern, content, re.DOTALL)
    if not match:
        print("Pattern not found")
        return False

    # Find the closing of the CustomScrollView
    start_pos = match.start()

    # Let's use a simpler approach - find the lines we need to change
    lines = content.split('\n')

    # Find the line with "bodyContent = CustomScrollView("
    body_content_line = None
    for i, line in enumerate(lines):
        if 'bodyContent = CustomScrollView(' in line:
            body_content_line = i
            break

    if body_content_line is None:
        print("Could not find bodyContent = CustomScrollView line")
        return False

    print(f"Found bodyContent at line {body_content_line + 1}")

    # Now we need to restructure. Let's create the new structure as a string
    # and replace the entire CustomScrollView block

    # The new structure should be:
    # bodyContent = Stack(
    #   children: [
    #     SingleChildScrollView(
    #       padding: EdgeInsets.only(bottom: 100),  // Space for fixed button
    #       child: Padding(
    #         padding: EdgeInsets.fromLTRB(24, topSpacing, 24, 0),
    #         child: Column(
    #           children: [
    #             // Quote card
    #             // Banner
    #           ],
    #         ),
    #       ),
    #     ),
    #     Positioned(
    #       bottom: 24,
    #       left: 24,
    #       right: 24,
    #       child: ElevatedButton(...),  // The button
    #     ),
    #   ],
    # );

    # For now, let's just output what we found
    print(f"Line {body_content_line + 1}: {lines[body_content_line]}")

    return True

if __name__ == '__main__':
    file_path = r'C:\tarot\smart-divination\apps\tarot\lib\main.dart'
    restructure_layout(file_path)
