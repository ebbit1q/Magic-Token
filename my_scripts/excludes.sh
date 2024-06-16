#!/bin/bash
tag="reverse-related"
relationrx="( *)<$tag([^>]*)>([^<]*)</$tag>"
exclude='exclude="exclude"'
while IFS= read -r line; do
  if [[ $line =~ $relationrx ]]; then
    space=${BASH_REMATCH[1]}
    args=${BASH_REMATCH[2]}
    name=${BASH_REMATCH[3]}
    if [[ $last_name && $name == "$last_name" ]]; then
      if [[ ! $args =~ $exclude ]]; then
        echo "$space<$tag$args $exclude>$name</$tag>"
        continue
      fi
    else
      last_name=$name
    fi
  else
    last_name=""
  fi
  echo "$line"
done <tokens.xml | sponge tokens.xml
