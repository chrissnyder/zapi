CtaFetcher = require '../fetchers/cta'
db = require '../lib/db'

module.exports =
  get: (req) ->
    db.redis.smembers 'cta', (err, times) ->
      req.reply times

  update: (req) ->
    req.reply 'ok'
    CtaFetcher.query()