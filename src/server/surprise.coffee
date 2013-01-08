###
surprise
https://github.com/southerd/surprise

Copyright (c) 2012 David Souther
Licensed under the MIT license.
###

# `jefri-server` provides an express server configured to handle jefri
# transactions, so we'll use that first. We also need to do some express things.
server = require "jefri-server"
express = require "express"
_ = require "underscore"
superscore = require "superscore"
nconf = require "nconf"

nconf.argv()
	.env()
	.file({ file: 'config.json' })
	.defaults({ port: 3000 })

# The jefri-server runtime doesn't have a default context, load the app's.
server.jefri.runtime.load "http://localhost:#{nconf.get 'port'}/surprise.json"

# Use index.html for /
server.get '/', (req, res)->
	res.sendfile "lib/client/index.html"

server.get '/context.json', (req, res)->
	res.sendfile 'lib/client/surprise.json'

# Otherwise, serve requests as static files from lib/client/
server.use '/', express.static 'lib/client/'

# Start the server.
server.listen nconf.get 'port'
