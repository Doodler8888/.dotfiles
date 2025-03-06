version = '0.21.9'


xplr.config.modes.builtin.go_to.key_bindings.on_key.z = {
  help = "add-cd",
  messages = {
    "PopMode",
    {
      BashExec0 = [===[
        PTH=$(cat ~/.dirs | fzf )
        if [ "$PTH" ]; then
          "$XPLR" -m 'ChangeDirectory: %q' "$PTH"
        fi
      ]===],
    },
  },
}


xplr.config.modes.builtin.symlink_to = {
  name = "symlink_to",
  prompt = "ð ❯ ",
  key_bindings = {
    on_key = {
      ["enter"] = {
        help = "submit",
        messages = {
          {
            BashExec0 = [===[
              DEST="$XPLR_INPUT_BUFFER"
              [ -z "$DEST" ] && exit
              # Expand tilde to home directory if present
              DEST="${DEST/#\~/$HOME}"
              if [ ! -d "$DEST" ] && ! mkdir -p -- "$DEST"; then
                  "$XPLR" -m 'LogError: %q' "could not create $DEST"
                  exit
              fi
              "$XPLR" -m "ChangeDirectory: %q" "$DEST"
              ! cd -- "$DEST" && exit
              DEST="$(pwd)" && echo "PWD=$DEST"
              while IFS= read -r -d '' PTH; do
                PTH_ESC=$(printf %q "$PTH")
                BASENAME=$(basename -- "$PTH")
                BASENAME_ESC=$(printf %q "$BASENAME")
                if [ -e "$BASENAME" ]; then
                  echo
                  echo "$BASENAME_ESC exists, do you want to overwrite it?"
                  read -p "[y]es, [n]o, [S]kip: " ANS < /dev/tty
                  case "$ANS" in
                    [yY]*)
                      ;;
                    [nN]*)
                      read -p "Enter new name: " BASENAME < /dev/tty
                      BASENAME_ESC=$(printf %q "$BASENAME")
                      ;;
                    *)
                      continue
                      ;;
                  esac
                fi
                if ln -sv -- "${PTH:?}" "./${BASENAME:?}"; then
                  "$XPLR" -m 'LogSuccess: %q' "Symlinked $PTH_ESC to $BASENAME_ESC"
                  "$XPLR" -m 'FocusPath: %q' "$BASENAME"
                else
                  "$XPLR" -m 'LogError: %q' "Could not symlink $PTH_ESC to $BASENAME_ESC"
                fi
              done < "${XPLR_PIPE_RESULT_OUT:?}"
              echo
              read -p "[press enter to continue]"
            ]===],
          },
          "PopMode",
        },
      },
      ["tab"] = {
        help = "try complete",
        messages = {
          { CallLuaSilently = "builtin.try_complete_path" },
        },
      },
    },
    default = {
      messages = {
        "UpdateInputBufferFromKey",
      },
    },
  },
}



xplr.config.modes.builtin.action.key_bindings.on_key["S"] = {
  help = "Symlink to",
  messages = {
    "PopMode",
    { SwitchModeBuiltin = "symlink_to" },
    { SetInputBuffer = "" },
  },
}
