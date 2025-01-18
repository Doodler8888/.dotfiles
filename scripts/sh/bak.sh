#!/bin/sh

is_back() {
    arg=$(echo "$1" | sed 's/\/*$//')
    case $arg in
        *.bak)
            # echo "is bak"
            # echo "returning 0"
            return 0
            ;;
        *)
            # echo "not a bak"
            # echo "returning 1"
            return 1
            ;;
    esac
}

unbaked() {
    # If i uncomment this line, then the function will return not only the
    # result, but also the debug output, which isn't correct. The possible fix
    # is to redirect the debug output to stderr.
    # echo "This is an argument coming to the unbaked function: $1"
    result=$(echo "$1" | sed 's/\/*$//; s/\.bak$//')
    echo "$result"
    # if i do the whole part just with "echo "$1" | sed 's/\/$//; s/\.bak$//'",
    # then i just capture the result in the function, but i don't return it
    # anywhere
}

uncreate_bak() {
    for arg in "$@"; do
        if is_back "$arg"; then
            echo "this is the current processed parameter: $arg"
            # "'s/\/*$//;" - '*' is added to delete any number of slashes at the end
            arg=$(echo "$arg" | sed 's/\/*$//')
            unbaked_string=$(unbaked "$arg")
            # echo "this is the unbaked_string: $unbaked_string"
            # echo "this is how the move command should look: mv $arg $unbaked_string"
            mv "$arg" "$unbaked_string"
        else
            arg=$(unbaked "$arg")
            # echo "this is how the move command should look: mv $arg $arg.bak"
            # mv $arg $arg".bak"
        fi
    done;
}

copy_args() {
    for arg in "$@"; do
        arg=$(echo "$arg" | sed 's/\/*$//; s/\.bak$//')
        if is_back "$arg"; then
            cp -r "$arg" "$(unbaked "$arg")"
        else
            cp -r "$arg" "$arg.bak"
        fi
    done;
}

bak() {
    case $1 in
        -c)
            shift
            # echo "c flag is used"
            # echo "coping the file first"
            copy_args "$@"
            ;;
        *)
            echo "c flag wasn't used"
            create_bak "$@"
            ;;
    esac
}

