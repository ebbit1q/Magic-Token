#!/bin/bash
tag="reverse-related"
relationrx="<$tag([^>]*)>([^<]*)</$tag>"
declare -A list # associative array
while IFS= read -r line; do
  if [[ $line =~ $relationrx ]]; then
    yes=1
    name="${BASH_REMATCH[2]}"
    args="${BASH_REMATCH[1]}"
    key="$name	$(printf "%03d" "${#args}")$args"
    list["$key"]="$line"
    keys+="
$key"
  elif [[ $yes ]]; then
    # LC_ALL=C determines the sort behavior!
    <<<"${keys:1}" LC_ALL=C sort --ignore-case | while read -r; do
      echo "${list[$REPLY]}"
    done
    yes=""
    list=()
    keys=""
    echo "$line"
  else
    echo "$line"
  fi
done <tokens.xml | sponge tokens.xml
