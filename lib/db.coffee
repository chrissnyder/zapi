mongoose = require 'mongoose'
redis = require 'redis'

class Db
  port = process.env.PORT || 3001

  constructor: ->
    @connected = false

  connect: (cb) =>
    # Redis setup
    @redis = redis.createClient()
    @redis.on 'error', (err) ->
      console.log 'redis error', err

    # Mongo setup
    mongoose.connection.on 'error', console.error.bind(console, 'connection error:')
    mongoose.connection.once 'open', ->
      cb()
      
    mongoose.connect 'mongodb://localhost/zapi'

module.exports = new Db