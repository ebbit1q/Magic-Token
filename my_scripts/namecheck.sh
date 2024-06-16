#!/bin/bash
# makes sure all cards in the tokens.xml are present in the cards.xml
namerx='<name>([^<]*)</name>'
relationrx='<reverse-related[^>]*>([^<]*)</reverse-related>'
cards="$HOME/.local/share/Cockatrice/Cockatrice/cards.xml"

declare -A names=()
while read -r; do
  if [[ $REPLY =~ $namerx ]]; then
    name=${BASH_REMATCH[1]}
    names[$name]=1
  fi
done <"$cards"

list=()
while read -r; do
  if [[ $REPLY =~ $relationrx ]]; then
    name=${BASH_REMATCH[1]//\"/&quot;}
    # oracle escapes " while the tokens.xml doesn't, the only card with this
    # issue is Meet and Greet "Sisay"
    if [[ $name && ${names[$name]} != 1 ]]; then
      list+=("$name")
    fi
  fi
done <tokens.xml

if [[ ${#list[@]} != 0 ]]; then
  echo "these tokens in the tokens.xml are not present in the cards.xml:"
  for i in "${!list[@]}"; do
    echo "${list[i]}"
  done
  echo
  exit 1
fi
