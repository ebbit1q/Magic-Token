#!/bin/bash
e=0
declare -i i=0
while read -r; do
  if [[ $REPLY == "$last" ]]; then
    e=1
    echo "duplicate line at $i: $REPLY"
  fi
  last=$REPLY
  i+=1
done <tokens.xml
exit $e
