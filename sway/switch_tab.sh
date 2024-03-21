#!/bin/bash

# Function to switch to a specific container
switch_to_container() {
    container_id=$1
    swaymsg "[con_id=$container_id] focus"
}

# Get the list of container IDs (tabs) within the tabbed container
container_ids=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.layout=="tabbed").nodes[].id')

# Get the total number of containers (tabs)
total_containers=$(echo "$container_ids" | wc -l)

# Get the desired tab index from the command line argument
if [ $# -eq 1 ]; then
    tab_index=$1
    if [[ "$tab_index" =~ ^[0-9]+$ ]] && [ "$tab_index" -ge 1 ] && [ "$tab_index" -le "$total_containers" ]; then
        # Get the container ID of the desired tab
        container_id=$(echo "$container_ids" | sed -n "${tab_index}p")
        switch_to_container "$container_id"
    else
        echo "Invalid tab index. Please provide a number between 1 and $total_containers."
    fi
else
    echo "Usage: $0 <tab_index>"
    exit 1
fi

# # Function to switch to a specific container
# switch_to_container() {
#     container_id=$1
#     swaymsg "[con_id=$container_id] focus"
# }
#
# # Get the list of container IDs (tabs) within the tabbed container
# container_ids=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.layout=="tabbed").nodes[].id')
#
# # Initialize the index counter
# index=1
#
# # Iterate over each container ID and print the index and ID
# while IFS= read -r container_id; do
#     echo "Tab $index: $container_id"
#     ((index++))
# done <<< "$container_ids"
#
# # Test the switch_to_container function
# echo "Switching to Tab 2..."
# switch_to_container "$(echo "$container_ids" | sed -n '2p')"


# swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.layout=="tabbed").nodes[].id'
# 5
# 6
# 7
# 8
# 15


