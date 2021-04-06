#!/usr/bin/env bash

SCHEMA='./etc/schema.sql'
DATABASE='bibliographics.db'
LIBRARY='./library'

if [[ -z $1 ]]; then
	echo "Usage: $(basename $0) <name>" >&2
	exit
fi

NAME=$1

mkdir "$LIBRARY/$NAME"
mkdir "$LIBRARY/$NAME/etc"
mkdir "$LIBRARY/$NAME/cache"
mkdir "$LIBRARY/$NAME/json"

cat $SCHEMA | sqlite3 "$LIBRARY/$NAME/etc/$DATABASE"