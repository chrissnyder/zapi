config = require('config').cta
db = require '../lib/db'
moment = require 'moment'
parseXml = require('xml2js').parseString
request = require 'request'

class CtaFetcher
  key: 'asdf'
  stops: '4877'

  # 4877 is the stop ID for the Adler
  query: ->
    url = "http://www.ctabustracker.com/bustime/api/v1/getpredictions?key=#{@key}&stpid=#{@stops}"

    request.get {url: url}, (err, result, data) ->
      parseXml data, (err, results) ->
        results = JSON.stringify results

        for result in results
          result.ttl = moment().diff(result.prdtm, 'seconds')
          unless db.redis.get "cta:#{stpid}:#{vid}"
            db.redis.setex "#{stpid}:#{vid}", result.ttl, result
            db.redis.sadd 'cta', "#{stpid}:#{vid}"

module.exports = new CtaFetcher