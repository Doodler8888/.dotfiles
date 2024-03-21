import subprocess

def get_focused_workspace():
    tree_output = subprocess.check_output(['swaymsg', '-t', 'get_tree']).decode('utf-8')
    workspace_id = None
    for line in tree_output.split('\n'):
        if line.startswith('#') and 'workspace' in line and '*' in line:
            workspace_id = line.split(':')[0].strip('# ')
            break
    return workspace_id

def get_tabs_in_workspace(workspace_id):
    tree_output = subprocess.check_output(['swaymsg', '-t', 'get_tree']).decode('utf-8')
    tab_ids = []
    in_workspace = False
    for line in tree_output.split('\n'):
        if line.startswith(f'#{workspace_id}:'):
            in_workspace = True
        elif in_workspace and line.startswith('#'):
            tab_id = line.split(':')[0].strip('# ')
            tab_ids.append(tab_id)
        elif in_workspace and not line.startswith(' '):
            break
    return tab_ids

# Get the focused workspace ID
focused_workspace_id = get_focused_workspace()
print(f"Focused workspace ID: {focused_workspace_id}")

# Get the tab IDs in the focused workspace
tab_ids = get_tabs_in_workspace(focused_workspace_id)
print(f"Tab IDs in the focused workspace: {tab_ids}")
