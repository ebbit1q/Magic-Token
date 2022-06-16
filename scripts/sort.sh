#!/bin/bash
tag="reverse-related"
relationrx="<$tag([^>]*)>([^<]*)</$tag>"
numberrx='[0-9]+'
declare -A list # associative array
while IFS= read -r line; do
  if [[ $line =~ $relationrx ]]; then
    yes=1
    name="${BASH_REMATCH[2]}"
    args="${BASH_REMATCH[1]}"
    if [[ $args =~ $numberrx ]]; then
      args="$(printf "%03d" "${BASH_REMATCH[0]}")$args"
    fi
    list[ "$name$args"]="$line"
    keys+="
$name$args"
  elif [[ $yes ]]; then
    # LC_ALL=C determines the sort behavior!
    <<<"${keys:1}" LC_ALL=C sort --ignore-case | while read -r key; do
      echo "${list[ $key]}"
    done
    yes=""
    list=()
    keys=""
    echo "$line"
  else
    echo "$line"
  fi
done <tokens.xml | sponge tokens.xml
