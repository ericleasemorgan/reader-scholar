#!/usr/bin/env python
 
# configure
TEMPLATE  = 'https://scholar.archive.org/search?q=##query##=&offset=##OFFSET##&limit=##LIMIT##'
HEADERS   = { 'Accept': 'application/json' }
LIMIT     = 100
OFFSET    = 0
LIBRARY   = './library'
JSON      = 'json'

# require
import requests
import json
import sys

# sanity check
if len( sys.argv ) != 3 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <query> <name>\n" )
	exit()

# return total number of records in a search result
def get_total_records( query, template=TEMPLATE, offset=1, limit=1 ) :

	# build a query URL
	url = template.replace( '##query##', query )
	url = url.replace( '##OFFSET##', str( offset ) )
	url = url.replace( '##LIMIT##', str( limit ) )
	
	# search
	response = requests.get( url, headers=HEADERS )
	
	# read the response and return the total number of records
	return response.json()[ 'count_found' ]

# get input
query = sys.argv[ 1 ]
name  = sys.argv[ 2 ]

# initialize
total  = get_total_records( query )
offset = OFFSET
limit  = LIMIT

# search
while ( offset <= total ) :

	# debug
	sys.stderr.write( "Getting records %s - %s of %s\n" % ( str( offset ), str( offset + limit), str( total ) ) )

	# build url
	url = TEMPLATE.replace( '##query##', query )
	url = url.replace( '##OFFSET##', str( offset ) )
	url = url.replace( '##LIMIT##', str( limit ) )

	# search
	response = requests.get( url, headers=HEADERS )

	# process each record
	records = response.json()[ 'results' ]
	for record in records :

		key  = record[ 'key' ]	
		file = LIBRARY + '/' + name + '/' + JSON + '/' + key + '.json'
	
		handle = open( file, "w" )
		handle.write( json.dumps( record ) ) 
		handle.close()
	
	# increment
	offset += limit
	
# done
exit()
