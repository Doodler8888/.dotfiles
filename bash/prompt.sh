# ~/.bash_prompt

# default colors
RGB_COLOR_WHITE='254'
RGB_COLOR_GREEN='28'
RGB_COLOR_YELLOW='136'
RGB_COLOR_RED='124'

# colors => exit code
RGB_COLOR_EXIT_CODE_OK_FG=$RGB_COLOR_GREEN
RGB_COLOR_EXIT_CODE_ERROR_FG=$RGB_COLOR_RED

# colors => user
RGB_COLOR_USER_BG='24'
RGB_COLOR_USER_FG=$RGB_COLOR_WHITE

# colors => directory
RGB_COLOR_DIR_BG='236'
RGB_COLOR_DIR_FG=$RGB_COLOR_WHITE

# colors => git
RGB_COLOR_GIT_OK_BG=$RGB_COLOR_GREEN
RGB_COLOR_GIT_DIRTY_BG=$RGB_COLOR_RED
RGB_COLOR_GIT_DELETED_BG=$RGB_COLOR_RED
RGB_COLOR_GIT_UNTRACKED_BG=$RGB_COLOR_YELLOW
RGB_COLOR_GIT_NEWFILE_BG=$RGB_COLOR_YELLOW
RGB_COLOR_GIT_RENAMED_BG=$RGB_COLOR_RED
RGB_COLOR_GIT_AHEAD_BG='30'
RGB_COLOR_GIT_FG=$RGB_COLOR_WHITE

# colors => user input
RGB_COLOR_INPUT_FG=$RGB_COLOR_WHITE

# color reset
COLOR_RESET="\e[0m"

# special characters
# note, this separator will require `fonts-powerline` to be installed!
SEPARATOR=$'\uE0B0'

# color handling
# $1: foreground color
# $2: background color (optional)
function prompt_set_color {
  if [ "$#" -eq 2 ]; then
    echo -e "\e[0;38;5;$1;48;5;$2m"
  elif [ "$#" -eq 1 ]; then
    echo -e "\e[0;38;5;$1;49m"
  fi
}

# color handling
# $1: foreground color
# $2: background color (optional)
function prompt_set_color_bold {
  if [ "$#" -eq 2 ]; then
    echo -e "\e[1;38;5;$1;48;5;$2m"
  elif [ "$#" -eq 1 ]; then
    echo -e "\e[1;38;5;$1;49m"
  fi
}


# build info about the last exit code
# $1: last exit code
function prompt_set_exit_code {
  if [ $1 -eq 0 ]; then
    PS1_EXIT_CODE="\[\$(prompt_set_color $RGB_COLOR_EXIT_CODE_OK_FG $RGB_COLOR_USER_BG)\]"
    PS1_EXIT_CODE+=" ✔"
  else
    PS1_EXIT_CODE="\[\$(prompt_set_color $RGB_COLOR_EXIT_CODE_ERROR_FG $RGB_COLOR_USER_BG)\]"
    PS1_EXIT_CODE+=" ✘"
  fi
}


# build the common info
function prompt_set_common_info {
  PS1_COMMON_INFO="\[\$(prompt_set_color $RGB_COLOR_USER_FG $RGB_COLOR_USER_BG)\]"
  PS1_COMMON_INFO+=" \u "
  PS1_COMMON_INFO+="\[\$(prompt_set_color $RGB_COLOR_USER_BG $RGB_COLOR_DIR_BG)\]"
  PS1_COMMON_INFO+="$SEPARATOR"
  PS1_COMMON_INFO+="\[\$(prompt_set_color $RGB_COLOR_DIR_FG $RGB_COLOR_DIR_BG)\]"
  PS1_COMMON_INFO+=" \w "
}


# git handling => current branch or commit
function prompt_git_branch {
  local GIT_STATUS="$(LANG=en_US.UTF-8 git status 2> /dev/null)"
  local ON_BRANCH="On branch ([^${IFS}]*)"
  local ON_COMMIT="HEAD detached at ([^${IFS}]*)"

  if [[ $GIT_STATUS =~ $ON_BRANCH ]]; then
    echo " ${BASH_REMATCH[1]} "
  elif [[ $GIT_STATUS =~ $ON_COMMIT ]]; then
    echo " ${BASH_REMATCH[1]} "
  fi
}

# git handling => status
function git_status {
  LANG=en_US.UTF-8 git status 2> /dev/null | (
    unset dirty deleted untracked newfile ahead renamed
    while read line ; do
        case "$line" in
          *modified:*)                      dirty='!' ; ;;
          *deleted:*)                       deleted='x' ; ;;
          *'Untracked files:')              untracked='?' ; ;;
          *'new file:'*)                    newfile='+' ; ;;
          *'Your branch is ahead of '*)     ahead='*' ; ;;
          *renamed:*)                       renamed='>' ; ;;
        esac
    done
    bits="$dirty$deleted$untracked$newfile$ahead$renamed"
    [ -n "$bits" ] && echo " $bits" || echo "c"
  )
}

# git handling => background color depending on the status
function prompt_git_bg_color {
  local GIT_STATUS=$(git_status)

  if [[ -n $GIT_STATUS ]]; then
    if [[ $GIT_STATUS =~ "!" ]]; then
      echo $RGB_COLOR_GIT_DIRTY_BG
    elif [[ $GIT_STATUS =~ "x" ]]; then
      echo $RGB_COLOR_GIT_DELETED_BG
    elif [[ $GIT_STATUS =~ "?" ]]; then
      echo $RGB_COLOR_GIT_UNTRACKED_BG
    elif [[ $GIT_STATUS =~ "+" ]]; then
      echo $RGB_COLOR_GIT_NEWFILE_BG
    elif [[ $GIT_STATUS =~ ">" ]]; then
      echo $RGB_COLOR_GIT_RENAMED_BG
    elif [[ $GIT_STATUS =~ "*" ]]; then
      echo $RGB_COLOR_GIT_AHEAD_BG
    else
      echo $RGB_COLOR_GIT_OK_BG
    fi
  fi
}

# build the git info
function prompt_set_git_info {
  local GIT_BRANCH="$(prompt_git_branch)"
  if [ -n "$GIT_BRANCH" ]; then
    local GIT_BG_COLOR="$(prompt_git_bg_color)"

    PS1_GIT_INFO="\[\$(prompt_set_color $RGB_COLOR_DIR_BG $GIT_BG_COLOR)\]"
    PS1_GIT_INFO+="$SEPARATOR"
    PS1_GIT_INFO+="\[\$(prompt_set_color $RGB_COLOR_GIT_FG $GIT_BG_COLOR)\]"
    PS1_GIT_INFO+="$GIT_BRANCH"
    PS1_GIT_INFO+="\[\$(prompt_set_color $GIT_BG_COLOR)\]"
    PS1_GIT_INFO+="$SEPARATOR"
  else
    PS1_GIT_INFO="\[\$(prompt_set_color $RGB_COLOR_DIR_BG)\]"
    PS1_GIT_INFO+="$SEPARATOR"
  fi
}


# build the user input
function prompt_set_input {
  PS1_INPUT="\[\$(prompt_set_color_bold $RGB_COLOR_INPUT_FG)\]"
  PS1_INPUT+=" \$ "
  PS1_INPUT+="\[$COLOR_RESET\]"
}


# overwrite the prompt command
PROMPT_COMMAND=__prompt_command
__prompt_command() {
  local EXIT_CODE="$?"

  # build string regarding the last exit code
  prompt_set_exit_code $EXIT_CODE

  # build string regarding the common info (user, directory, ...)
  prompt_set_common_info

  # build string regarding the git status
  prompt_set_git_info

  # build string regarding the user input
  prompt_set_input

  # build prompt
  if (tput cuu1 && tput sc && tput rc && tput el) >/dev/null 2>&1
  then
    PS1="
${PS1_EXIT_CODE}${PS1_COMMON_INFO}${PS1_GIT_INFO}${PS1_INPUT}"
    PS2="\[$(tput el)\]> "
    trap 'tput el' DEBUG
  fi
}
