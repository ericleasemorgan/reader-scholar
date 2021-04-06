#!/usr/bin/env python
 
# configure
TEMPLATE = "UPDATE bibliographics SET size = '##SIZE##', extension = '##EXTENSION##' WHERE key IS '##KEY##';"

# require
import sys
import os

# sanity check
if len( sys.argv ) != 2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <file>\n" )
	exit()

# initialize
file      = sys.argv[ 1 ]
size      = str( os.path.getsize( file ) )
key       = os.path.splitext( os.path.basename( file ) )[ 0 ]
extension = os.path.splitext( os.path.basename( file ) )[ 1 ].replace( '.', '' )
sql       = TEMPLATE.replace( '##SIZE##', size ).replace( '##EXTENSION##', extension ).replace( '##KEY##', key )

# output and done
print( sql )
exit
