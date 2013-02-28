config = require('config').desk
request = require 'request'

Ticket = require '../models/ticket'

class TicketsFetcher
  openUrl: 'https://zooniverse.desk.com/api/v1/cases.json?status=new,open&count=100'

  query: =>
    request.get {url: @openUrl, oauth: config.auth, json: true}, @saveOpenCases

  saveOpenCases: (err, res, cases) =>
    if err then console.log 'Error retrieving tickets.', err; return
    cases = cases.results

    data = []
    if res.statusCode is 200
      for kase in cases
        Ticket.findOneAndUpdate {"case.id": kase.id}, kase, {upsert: true}, (err, doc) ->
          if err then console.log 'Error saving ticket.', err

module.exports = new TicketsFetcher