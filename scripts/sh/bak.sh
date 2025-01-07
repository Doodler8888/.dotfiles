#!/bin/sh


is-back() {
    if [ $1 = *.bak ]; then
        echo "true"
    else
        echo "false"
    fi
}

# back() {
#     case $1 in
#         "*.bak")
#             echo "true"
#             ;;
#         "notback")
#             echo "false"
#             ;;
#     esac
# }

# is-back() {
#     case $1 in
#         "*.bak")
#             echo "true"
#         ;;
# 	!"*bak")
# 	    echo "false"
# 	;;
#     esac
# }

# bak() {
#     case "$OPTION" in
#         h)
#         ;;
#         b)
#         ;;
#     esac
# }
