#!/usr/bin/env bash


# make sane
if [[ -z $1 || -z $2 ]]; then
	echo "Usage: $(basename $0) <name> <query>" >&2
	exit
fi

# initialize
NAME=$1
QUERY=$2

./bin/initialize.sh $NAME
./bin/search.py "$QUERY" $NAME
./bin/json2db.sh $NAME
./bin/cache.sh $NAME
./bin/update-with-size.sh $NAME
./bin/make-zip.sh $NAME
