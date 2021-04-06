#!/usr/bin/env bash

# configure
LIBRARY='./library'
JSON='json'
PATTERN='*.json'
SQL='sql'
INSERTS='inserts.sql'
TRANSACTION='transaction.sql'
DATABASE='bibliographics.db'
ETC='etc'

# sanity check
if [[ -z $1 ]]; then
	echo "Usage: $(basename $0) <name>" >&2
	exit
fi

# (re-)initialize
NAME=$1
rm    -rf "$LIBRARY/$NAME/$SQL"
mkdir -p  "$LIBRARY/$NAME/$SQL"

# read json and create sql
find "$LIBRARY/$NAME/$JSON" -name "$PATTERN" | parallel ./bin/json2db.py > "$LIBRARY/$NAME/$SQL/$INSERTS"

# build a transaction
echo "BEGIN TRANSACTION;"          >  "$LIBRARY/$NAME/$SQL/$TRANSACTION"
cat "$LIBRARY/$NAME/$SQL/$INSERTS" >> "$LIBRARY/$NAME/$SQL/$TRANSACTION"
echo "END TRANSACTION;"            >> "$LIBRARY/$NAME/$SQL/$TRANSACTION"

# execute the transaction and done
cat "$LIBRARY/$NAME/$SQL/$TRANSACTION" | sqlite3 "$LIBRARY/$NAME/$ETC/$DATABASE"
exit
