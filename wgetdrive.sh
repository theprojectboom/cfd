#!/bin/bash
# https://stackoverflow.com/a/50573452/6023997

# Get files from Google Drive

# $1 = file ID
# $2 = file name

URL="https://docs.google.com/uc?export=download&id=$1"

wget --no-verbose --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "$URL" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$1" -O $2 && rm -rf /tmp/cookies.txt
