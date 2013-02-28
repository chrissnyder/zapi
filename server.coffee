Db = require './lib/db'
Hapi = require 'hapi'

Buses = require './controllers/buses'
Projects = require './controllers/projects'
Tickets = require './controllers/tickets'
Tweets = require './controllers/tweets'

start = ->
  port = process.env.port || 8000
  server = new Hapi.Server 'localhost', port

  # Project routes
  server.route([
    {method: 'PUT', path: '/projects', handler: Projects.update}
    {method: 'GET', path: '/projects/{name?}', handler: Projects.get}
    {method: 'POST', path: '/projects', handler: Projects.create}
  ])

  # Support ticket routes
  server.route([
    {method: 'PUT', path: '/tickets', handler: Tickets.update}
    {method: 'GET', path: '/tickets', handler: Tickets.get}
  ])

  # Tweet routes
  server.route([
    {method: 'PUT', path: '/tweets', handler: Tweets.update}
    {method: 'GET', path: '/tweets', handler: Tweets.get}
    {method: 'GET', path: '/tweets/terms', handler: Tweets.getTerms}
    {method: 'POST', path: '/tweets/terms', handler: Tweets.setTerm}
  ])

  # CTA Routes
  server.route([
    {method: 'GET', path: '/buses/{bus?}', handler: Buses.get}
  ])

  server.start()
  console.log 'server started on port', port

  update = ->
    server.inject {method: 'GET', url: '/projects/update'}, (res) ->
      console.log 'updated projects'

    server.inject {method: 'GET', url: '/tickets/update'}, (res) ->
      console.log 'updated tickets'

    server.inject {method: 'GET', url: '/tweets/update'}, (res) ->
      console.log 'updated tweets'

  # setInterval update, 20000

Db.connect start