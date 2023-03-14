#!/bin/bash

# checks for and updates the version in tokens.xml when a pull request gets
# approved
set -e

# reset all changes to version.txt
git fetch origin
git checkout origin/master version.txt

# get date
olddate="$(cat version.txt)"
date="$(date --utc +%Y%m%d)"
echo "it is currently $date"

# check for suffix used when multiple changes happen in a day
suffixrx='[a-z]+'
if [[ $olddate =~ $date ]]; then
  if [[ $olddate =~ $suffixrx ]]; then
    suffix="${BASH_REMATCH[0]}"
    # it's very unlikely we'll ever do 25 updates a day...
    if [[ $suffix == z ]]; then
      echo "SUFFIX OVERFLOW" >&2
      exit 3
    fi
    alphabet="abcdefghijklmnopqrstuvwxyz"
    for (( i=0; i<25; i++ )); do
      if [[ $suffix == "${alphabet:$i:1}" ]]; then
        date="$date${alphabet:$i+1:1}"
        break
      fi
    done
  else
    date="${date}b"
  fi
fi

# edit files
echo "updating version from $olddate to $date"
sed -i "s?<sourceVersion>.*</sourceVersion>?<sourceVersion>$date</sourceVersion>?" tokens.xml
echo "$date" >version.txt
git commit tokens.xml version.txt -m "update version"
