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
    DIR=`zipinfo -1 "$f" | grep -E "$QUESTION/" | head -1`

    if [ $(echo "$DIR" | wc -c) -le 1 ] # no idea why empty gives wc of 1??
    then
        # some people have zipped all CWK2Qx.* in a single directory.
        FILE=`zipinfo -1 "$f" | grep -E "CWK2$QUESTION" | head -1`

        if [ $(echo "$FILE" | wc -c) -le 1 ] # no idea why empty gives wc of 1??
        then
            echo "WARNING: Unable to find \"$QUESTION\" in \"$f\""
            zipinfo "$f"
            echo ""

            continue
        fi
        echo "NOTICE: \"$f\" could not find the directory, but found a source file."
        echo ""
    fi

    # place in a new folder with unique name
    # extract the 8-digit participant number from moodle files
    ZIP_NAME=`echo "$f" | awk -F'/' '{print substr($NF, 13, 8)}'`

    OUT_DIR="$PROCESSED/$ZIP_NAME-$QUESTION"
    # NOTE: -o will overwrite duplicate files. this may not be what we want
    if [[ -z $FILE ]]
    then # standard directory structure
        unzip -o -j "$f" "$DIR*" -d $OUT_DIR > /dev/null
    else # single dir, multiple files
        unzip -o -j "$f" "$FILE" -d $OUT_DIR > /dev/null
    fi
done

