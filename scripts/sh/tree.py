#!/bin/python

def clean_tree(tree_str):
    lines = tree_str.split('\n')
    if not lines:
        return ""

    # First, analyze the structure to find last siblings at each level
    levels = {}  # Dictionary to store the last occurrence of each indent level

    # First pass: count levels and find actual indent positions
    for i, line in enumerate(lines):
        if not line.strip():
            continue
        # Count leading spaces and pipes to determine actual indent level
        leading_part = line.split('___')[0] if '___' in line else line
        indent = len(leading_part)
        levels[indent] = i

    # Sort indent levels to help with processing
    indent_levels = sorted(levels.keys())

    # Second pass: clean up unnecessary pipes
    cleaned_lines = []
    for i, line in enumerate(lines):
        if not line.strip():
            cleaned_lines.append(line)
            continue

        leading_part = line.split('___')[0] if '___' in line else line
        current_indent = len(leading_part)

        # Find index of current indent level
        current_level_idx = indent_levels.index(current_indent)

        # Replace pipes that don't lead to siblings
        new_line = list(line)
        for j, char in enumerate(leading_part):
            if char == '|':
                # Find what indent level this pipe represents
                prefix = line[:j+1]
                prefix_indent = len(prefix)

                # If this indent level has no more siblings below in the tree,
                # replace the pipe with a space
                if prefix_indent in indent_levels:
                    if levels[prefix_indent] <= i:
                        new_line[j] = ' '

        cleaned_lines.append(''.join(new_line))

    return '\n'.join(cleaned_lines)

# Example usage
example_tree = """.
.config
|___recursive_dir
|   |___deeply_nested
|   |   |___level2
|   |   |   |___level3
|   |   |   |   |___level4
|   |   |   |   |   |___level5
|   |___even_more_nested
|   |   |___level_a
|   |   |   |___level_b
|___config321
|   |___another_level
|   |   |___even_deeper
|   |   |   |___deeper_still
|   |   |   |   |___final_depth
|   |   |___sibling_level
|   |___yet_another_level
|   |   |___more_inside
|   |___completely_separate_branch"""

print(clean_tree(example_tree))
