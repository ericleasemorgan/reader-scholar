#!/usr/bin/env bash


# configure
TEMPLATE=".mode tabs\nSELECT '##NAME##', key, mime_type, url FROM bibliographics WHERE language IS 'en';"
LIBRARY='./library'
CACHE='cache'
SQL='sql'
ETC='etc'
DATABASE='bibliographics.db'
UPDATES='updates.sql'
TRANSACTION='transaction.sql'

# make sane
if [[ -z $1 ]]; then
	echo "Usage: $(basename $0) <name>" >&2
	exit
fi

# initialize
NAME=$1

# remove empty files
find "$LIBRARY/$NAME/$CACHE" -size 0 | parallel rm -rf

# query, and submit the work (in parallel)
find "$LIBRARY/$NAME/$CACHE" -type f | parallel ./bin/update-with-size.py > "$LIBRARY/$NAME/$SQL/$UPDATES"

# create a transaction
echo "BEGIN TRANSACTION;"          >  "$LIBRARY/$NAME/$SQL/$TRANSACTION"
cat "$LIBRARY/$NAME/$SQL/$UPDATES" >> "$LIBRARY/$NAME/$SQL/$TRANSACTION"
echo "END TRANSACTION;"            >> "$LIBRARY/$NAME/$SQL/$TRANSACTION"

# update the database and done
cat "$LIBRARY/$NAME/$SQL/$TRANSACTION" | sqlite3 "$LIBRARY/$NAME/$ETC/$DATABASE"
exit
