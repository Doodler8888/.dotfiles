help() {
    file_name="$XDG_HELP_DIR/$1.txt"
    cat "$file_name"
}
