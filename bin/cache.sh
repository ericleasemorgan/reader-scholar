#!/usr/bin/env bash


# configure
TEMPLATE=".mode tabs\nSELECT '##NAME##', key, mime_type, url FROM bibliographics WHERE language IS 'en';"
LIBRARY='./library'
ETC='etc'
DATABASE='bibliographics.db'

# make sane
if [[ -z $1 ]]; then
	echo "Usage: $(basename $0) <name>" >&2
	exit
fi

# initialize
NAME=$1
SQL=$( echo -e "$TEMPLATE" | sed "s/##NAME##/$NAME/" )

# query, submit the work (in parallel), and done
echo -e "$SQL" | sqlite3 "$LIBRARY/$NAME/$ETC/$DATABASE" | parallel --colsep '\t' ./bin/wget.sh
exit
