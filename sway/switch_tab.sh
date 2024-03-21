#!/bin/bash

switch_to_tab() {
    # Get the current workspace's name
    current_workspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
    echo "Current_workspace: $current_workspace"

    # Debug: Print the entire JSON structure
    # swaymsg -t get_tree | jq -r '.'

    # Get the list of container IDs (tabs) within the tabbed container of the current workspace
    container_ids=$(
container_ids=$(swaymsg -t get_tree | jq -r --arg current_workspace "$current_workspace" '.nodes[] | .nodes[] | .nodes[] | select(.name==$current_workspace) | .nodes[] | select(.layout=="tabbed").nodes[].id')
)
    echo "Containers ids: $container_ids"

    # Get the total number of containers (tabs)
    total_containers=$(echo "$container_ids" | wc -l)
    echo "Total_containers: $total_containers"

    # # Get the desired tab index from the command line argument
    # if [ $# -eq 1 ]; then
    #     tab_index=$1
    #     if [[ "$tab_index" =~ ^[0-9]+$ ]] && [ "$tab_index" -ge 1 ] && [ "$tab_index" -le "$total_containers" ]; then
    #         # Get the container ID of the desired tab
    #         container_id=$(echo "$container_ids" | sed -n "${tab_index}p")
    #         swaymsg "[con_id=$container_id] focus"
    #     else
    #         echo "Invalid tab index. Please provide a number between 1 and $total_containers."
    #     fi
    # else
    #     echo "Usage: $0 <tab_index>"
    #     exit 1
    # fi
}

# switch_to_tab "$@"
switch_to_tab

#
# # Function to switch to a specific container
# switch_to_container() {
#     container_id=$1
#     swaymsg "[con_id=$container_id] focus"
# }
#
# # Get the current workspace's ID
# current_workspace_id=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true).id')
#
# # Get the list of container IDs (tabs) within the tabbed container of the current workspace
# container_ids=$(swaymsg -t get_tree | jq -r --arg current_workspace_id "$current_workspace_id" '.nodes[] | select(.id==$current_workspace_id) | .nodes[] | select(.layout=="tabbed").nodes[].id')
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

# #!/bin/bash
#
# # Function to switch to a specific container
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
