#!/bin/bash
while IFS= read -r line; do
  if [[ $line == "$last" ]]; then
    echo "$line"
  fi
  last="$line"
done <tokens.xml
