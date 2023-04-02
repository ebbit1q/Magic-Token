#!/bin/bash

# squashes the current changes into one commit onto $UPSTREAM $BRANCH
# uses $NUMBER and $TITLE to set the commit title and referenced pr
# note that this intentionally includes uncommitted changes (commit -a)
set -e

echo "fetching upstream"
git fetch "$UPSTREAM" "$BRANCH"

# get authors
declare -A authormap=()
primary=""
while read -r; do
  if [[ ! $primary ]]; then
    primary=$REPLY
  fi
  authormap[$REPLY]=1
done < <(git log FETCH_HEAD..HEAD --reverse --format="%an <%ae>")
unset "authormap[$primary]"
coauthors=""
for author in "${!authormap[@]}"; do
  coauthors+="
Co-authored-by: $author"
done

# create commit message
message="$TITLE (#$NUMBER)

$(git log FETCH_HEAD..HEAD --reverse --format="* %B%n")"
if [[ $coauthors ]]; then
  message+="

---------

$coauthors"
fi

echo "resetting current commits"
git reset --soft FETCH_HEAD
echo "creating new commit"
git commit --author "$primary" -am "$message"
echo "created commit:"
git log FETCH_HEAD..HEAD
