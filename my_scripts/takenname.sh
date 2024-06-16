#!/bin/bash
# checks if cards in the tokens.xml aren't taken
namerx='<name>([^<]*)</name>'
cards="$HOME/.local/share/Cockatrice/Cockatrice/cards.xml"

declare -A cardnames=()
declare -A allnames=()
while read -r; do
  if [[ $REPLY =~ $namerx ]]; then
    name=${BASH_REMATCH[1]}
    cardnames[$name]=1
    allnames[$name]=1
  fi
done <"$cards"

list=()
declare -i withspace=0
declare -i withtoken=0
while read -r; do
  if [[ $REPLY =~ $namerx ]]; then
    name=${BASH_REMATCH[1]}
    if [[ $name ]]; then
      nospace=${name%% }
      notoken=${name%% (Token)}
      if [[ ${allnames[$name]} == 1 ]]; then
        list+=("$name")
      elif [[ ${cardnames[$nospace]} == 1 ]]; then
        withspace+=1
      elif [[ ${cardnames[$notoken]} == 1 ]]; then
        withtoken+=1
      else
        if [[ $name != "$notoken" ]]; then
          echo "$name doesn't have a card without (Token)!"
        fi
        allnames[$name]=1
      fi
    fi
  fi
done <tokens.xml

if [[ $withspace != 0 ]]; then
  echo "there are $withspace tokens that have a space extra compared to a card"
fi
if [[ $withtoken != 0 ]]; then
  echo "there are $withtoken tokens that have (Token) added"
fi
if [[ ${#list[@]} != 0 ]]; then
  echo "these tokens have duplicate names!"
  for i in "${!list[@]}"; do
    echo "${list[i]}"
  done
  echo
  exit 1
fi
