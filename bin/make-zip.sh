#!/usr/bin/env bash


# configure
SQL=".mode csv\n.headers on\nSELECT a.author, b.title, b.year AS date, b.key || '.' || b.extension AS file FROM bibliographics AS b, authors AS a WHERE a.key = b.key AND size > 0 GROUP BY b.title ORDER BY a.author;"
LIBRARY='./library'
CACHE='cache'
TMP='tmp'
ETC='etc'
DATABASE='bibliographics.db'
METADATA='metadata.csv'

# make sane
if [[ -z $1 ]]; then
	echo "Usage: $(basename $0) <name>" >&2
	exit
fi

# (re-)initialize
NAME=$1
rm    -rf "$LIBRARY/$NAME/$TMP/$NAME"
mkdir -p  "$LIBRARY/$NAME/$TMP/$NAME"

# duplicate the data and create the metadata file
cp $LIBRARY/$NAME/$CACHE/* "$LIBRARY/$NAME/$TMP/$NAME/"
echo -e "$SQL" | sqlite3 "$LIBRARY/$NAME/$ETC/$DATABASE" > "$LIBRARY/$NAME/$TMP/$NAME/$METADATA"

# zip and done
cd "$LIBRARY/$NAME/$TMP/"
zip -r "$NAME.zip" "$NAME/"
mv "$NAME.zip" ../.
exit
