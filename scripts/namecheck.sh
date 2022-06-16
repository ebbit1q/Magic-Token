#!/bin/bash
relationrx='<reverse-related([^>]*)>([^<]*)</reverse-related>'
while read -r line; do
  if [[ $line =~ $relationrx ]]; then
    name="${BASH_REMATCH[2]}"
    #args="${BASH_REMATCH[1]}"
    if ! grep -F "$name" "$HOME/.local/share/Cockatrice/Cockatrice/cards.xml" -q; then
      echo "$name"
    fi
  fi
done <tokens.xml
