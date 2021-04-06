#!/usr/bin/env bash

# configure
TEMPLATE='wget -k --no-check-certificate --timeout=10 --tries=2 -O ##OUTPUT## ##URL##'
LIBRARY='./library'
CACHE='cache'

# sanity check
if [[ -z $1 || -z $2 || -z $3 || -z $4 ]]; then
	echo "Usage: $(basename $0) <name> <key> <mime_type>, <url>" >&2
	exit
fi

# initialize
NAME=$1
KEY=$2
MIMETYPE=$3
URL=$4

# calculate extension
if   [[ $MIMETYPE == 'application/pdf' ]]; then EXTENSION='pdf'
elif [[ $MIMETYPE == 'text/html'       ]]; then EXTENSION='htm'
else
	echo "Exiting; unknown value for mime-type ($MIMETYPE). Call Eric." >&2
	exit
fi

# build the command
OUTPUT="$LIBRARY/$NAME/$CACHE/$KEY.$EXTENSION"
WGET=$( echo $TEMPLATE | sed "s|##OUTPUT##|$OUTPUT|" | sed "s|##URL##|$URL|" )

# do the work and done
$WGET
exit
