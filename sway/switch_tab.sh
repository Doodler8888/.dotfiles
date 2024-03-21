#!/bin/bash

# Function to switch to a specific container
switch_to_container() {
    container_id=$1
    swaymsg "[con_id=$container_id] focus"
}

# Get the ID of the currently focused workspace
swaymsg "focus parent"
current_workspace_id=$(swaymsg -t get_tree | jq '.nodes[].nodes[] | select(.focused==true or (.nodes[].focused==true)) | .id')

# Get the list of container IDs (tabs) within the tabbed container of the current workspace
container_ids=$(swaymsg -t get_tree | jq -r --arg id_value "$current_workspace_id" '.nodes[].nodes[] | select(.id == ($id_value | tonumber) ) | recurse(.nodes[]) | select(.layout == "tabbed") | .nodes[].id')

# Get the total number of containers (tabs)
total_containers=$(echo "$container_ids" | wc -l)

# Get the desired tab index from the command line argument
if [ $# -eq 1 ]; then
    tab_index=$1
    if [[ "$tab_index" =~ ^[0-9]+$ ]] && [ "$tab_index" -ge 1 ] && [ "$tab_index" -le "$total_containers" ]; then
        # Get the container ID of the desired tab
        container_id=$(echo "$container_ids" | sed -n "${tab_index}p")
        switch_to_container "$container_id"
        swaymsg "focus child"
    else
        echo "Invalid tab index. Please provide a number between 1 and $total_containers."
    fi
else
    echo "Usage: $0 <tab_index>"
    exit 1
fi

# #!/bin/bash
#
# Function to switch to a specific container
# switch_to_container() {
#     container_id=$1
#     swaymsg "[con_id=$container_id] focus"
# }
#
# # Get the list of container IDs (tabs) within the tabbed container
# container_ids=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.layout=="tabbed").nodes[].id')
#
# # Get the total number of containers (tabs)
# total_containers=$(echo "$container_ids" | wc -l)
#
# # Get the desired tab index from the command line argument
# if [ $# -eq 1 ]; then
#     tab_index=$1
#     if [[ "$tab_index" =~ ^[0-9]+$ ]] && [ "$tab_index" -ge 1 ] && [ "$tab_index" -le "$total_containers" ]; then
#         # Get the container ID of the desired tab
#         container_id=$(echo "$container_ids" | sed -n "${tab_index}p")
#         switch_to_container "$container_id"
#     else
#         echo "Invalid tab index. Please provide a number between 1 and $total_containers."
#     fi
# else
#     echo "Usage: $0 <tab_index>"
#     exit 1
# fi


# command that extracts the current workspaces:
# swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true).name'
