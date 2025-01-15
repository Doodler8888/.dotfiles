#!/bin/sh

clean_file() {
    temp_file=$(mktemp) || exit 1
    dir_file="$HOME/.dirs"
    # NF is 'number of fields'. Don't forget that field in awk is a symbol
    # separated by whitespaces.
    awk 'NF > 0' "$dir_file" | sort -d | uniq > "$temp_file"
    rm "$dir_file"
    mv "$temp_file" "$dir_file"
}

cd_add() {
    if [ ! -f $HOME/.dirs ]; then
        touch $HOME/.dirs
    fi

    clean_file
    current_path="$1"
    # If i don't give any parameter
    if [ -z "$1" ]; then
        current_path=$(pwd)
        echo "current_path" >> $HOME/.dirs
    # If the given parameter doesn't exist and the logic implies, that i just
    # gave an unfull path
    elif [ ! -f $current_path ]; then
        current_path="$(pwd)/$current_path"
        echo "$current_path" >> $HOME/.dirs
    else
        echo "$current_path" >> $HOME/.dirs 
    fi
}
    
# print_dirs() {
#     # In this situation i have two inputs. One is the content of the file itself
#     # that i pass at the end of the while loop (reprented as $1). And the lines
#     # of the file that are automatically parsed through the read command that
#     # are represented as 'dir'.
#     while read -r dir; do
#         echo $dir
#     done < "${1:-$HOME/.dirs}"
# }


# c_path() {
#     current_path="$1"
#     if [ -z "$1" ]; then
#         current_path=$(pwd)
#     elif [ ! -f $current_path ]; then
#         current_path="$(pwd)/$current_path"
#     fi
#     echo $current_path
# }
