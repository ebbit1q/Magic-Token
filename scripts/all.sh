#!/bin/bash

set -e
source_dir="${BASH_SOURCE%/*}"

# in place edits
echo "$source_dir/cardsort.sh"
"$source_dir/cardsort.sh"
echo "$source_dir/excludes.sh"
"$source_dir/excludes.sh"
echo "$source_dir/ordersets.sh"
"$source_dir/ordersets.sh"
echo "$source_dir/sort.sh"
"$source_dir/sort.sh"

# checks
echo "$source_dir/duplicates.sh"
"$source_dir/duplicates.sh"
echo "$source_dir/lint.sh"
"$source_dir/lint.sh"
echo "$source_dir/missing.sh"
"$source_dir/missing.sh" || :  # allow failure
echo "$source_dir/namecheck.sh"
"$source_dir/namecheck.sh"
echo "$source_dir/takenname.sh"
"$source_dir/takenname.sh"

# test in cockatrice
echo "$source_dir/install.sh"
"$source_dir/install.sh"
echo "running cockatrice"
cockatrice

if git diff --quiet; then
  echo "is this ready to deploy? (^C to exit)"
  read -r
  echo "$source_dir/updateversion.sh"
  "$source_dir/updateversion.sh"
  echo "you can push these to the upstream branch now"
else
  echo "please commit changes before performing tests again"
fi
