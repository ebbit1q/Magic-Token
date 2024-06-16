#!/bin/bash

# find missing tokens using scryfall's tag for missing tokens

# NOTE: cards that create multiple tokens that are not all missing would not
# be picked up by this script!
set -eo pipefail
url="https://api.scryfall.com/cards/search?q=otag:unprinted-token+legal:commander"
# we only really care about commander legal cards, other cards are of less
# priority, if someone wants some other card added it's up to them to report it
mapfile -t list < <(
  declare -i i=0
  while
    curl "$url&page=$i" | jq -r '.has_more, .data[].name' | {
      read -r
      cat
      if [[ $REPLY == false ]]; then
        exit 1
      fi
    }
  do i+=1; done
)

if [[ ${#list[@]} == 0 ]]; then
  echo "didn't find any cards" >&2
  exit 1
fi

tag="reverse-related"
relationrx="<${tag}[^>]*>([^<]*)</$tag>"
while read -r; do
  if [[ $REPLY =~ $relationrx ]]; then
    name="${BASH_REMATCH[1]}"
    for i in "${!list[@]}"; do
      if [[ $name == "${list[i]}" ]]; then
        unset 'list[i]'
        break
      fi
    done
  fi
done <tokens.xml

if [[ ${#list[@]} != 0 ]]; then
  echo "
these tokens are tagged on scryfall with missing-token but are not present in
the tokens.xml:"
  for i in "${!list[@]}"; do
    echo "${list[i]}"
  done
  exit 1
fi
