format_to_threshold() {
  local char_threshold=80  # Hard-coded value
  local input_text=$1
  local current_line=""
  local formatted_text=""
  local current_length=0

  for word in $input_text; do
    if ((current_length + ${#word} + 1 > char_threshold)); then
      formatted_text="${formatted_text}${current_line}\n"
      current_line=$word
      current_length=${#word}
    else
      if [[ -z $current_line ]]; then
        current_line=$word
      else
        current_line="${current_line} $word"
      fi
      ((current_length += ${#word} + 1))
    fi
  done

  formatted_text="${formatted_text}${current_line}"
  echo -e $formatted_text
}
