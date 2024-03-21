# Step 1: Get the name of the current workspace
current_workspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .name')

# Step 2: Get the tabs of the first layer in the current workspace
# This command navigates through the tree to find the first layer of containers (tabs) in the focused workspace
swaymsg -t get_tree | jq -r --arg workspace "$current_workspace" '
  recurse(.nodes[]?, .floating_nodes[]?) | 
  select(.type == "workspace" and .name == $workspace) |
  .nodes[] | 
  select(.layout == "tabbed") | 
  .nodes[] | 
  select(.type == "con" and .nodes == []) | 
  .id
'
