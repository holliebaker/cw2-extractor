#!/bin/bash

# read cmd line args: in-folder, out-folder, q-number
if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]
then
    echo "Usage: $0 <in-folder> <out-folder> <question-number>"
    exit 1
fi

QUESTION="Q$3"
SUB_DIR=$1
PROCESSED=$2

mkdir -p $PROCESSED

# process submissions (zips in folder)
for f in $SUB_DIR/*.zip
do
    # find the first folder in zip file called "Q$i"
    DIR=`zipinfo -1 "$f" | grep -E "$QUESTION/$" | head -1`

    if [ $(echo "$DIR" | wc -c) -le 1 ] # no idea why empty gives wc of 1??
    then
        echo "WARNING: Unable to find \"$QUESTION\" in \"$f\""
        continue
    fi

    # place in a new folder with unique name
    # extract the 8-digit participant number from moodle files
    # ZIP_NAME=`echo $f | awk '{print substr($1, 13, 8)}'`
    # for testing purposes - removes the .zip from end of name
    ZIP_NAME=`echo "$f" | awk -F'/' '{print substr($NF, 1, length($NF)-4)}'`

    OUT_DIR="$PROCESSED/$ZIP_NAME-$QUESTION"
    unzip $f "$DIR" -d $OUT_DIR >> /dev/null
done

