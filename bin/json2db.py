#!/usr/bin/env python


# configure
BIBLIOGRAPHICS = "INSERT INTO bibliographics ( 'key', 'title', 'date', 'year', 'mime_type', 'url', 'access_type', 'access_url', 'language', 'type' ) VALUES ( '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s' );"
AUTHORS        = "INSERT INTO authors ( 'key', 'author' ) VALUES ( '%s', '%s' );"

# require
import json
import sys

# sanity check
if len( sys.argv ) != 2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <file>\n" )
	exit()

# initialize
file   = sys.argv[ 1 ]
record = json.load( open( file ) )
  
# parse
key         = record[ 'key' ]
access_type = record[ 'fulltext' ][ 'access_type' ]

# date
try             : date = record[ 'biblio' ][ 'release_date' ]
except KeyError : date = ''

# year
try             : year = record[ 'biblio' ][ 'release_year' ]
except KeyError : year = ''

# language
try             : language = record[ 'biblio' ][ 'lang_code' ]
except KeyError : language = ''

# type
try             : type = record[ 'biblio' ][ 'release_type' ]
except KeyError : type = ''

# title
try             : title = record[ 'biblio' ][ 'title' ]
except KeyError : title = ''
title = title.replace( "'", "''" )

# mime type
try             : mime_type = record[ 'fulltext' ][ 'file_mimetype' ]
except KeyError : mime_type = ''

access_url = record[ 'fulltext' ][ 'access_url' ]
try :
	url = access_url.split( 'http' )[ 2 ]
	url = 'http' + url
except IndexError : url = url

# build sql, output, and done
bibliographics = ( BIBLIOGRAPHICS % ( key, title, date, year, mime_type, url, access_type, access_url, language, type ) )
print( bibliographics )

# authors
try             : authors = record[ 'biblio' ][ 'contrib_names' ]
except KeyError : authors = []
for author in authors :
	author = author.replace( "'", "''" )
	author = ( AUTHORS % ( key, author ) )
	print( author )

exit()

