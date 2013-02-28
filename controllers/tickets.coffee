mongoose = require 'mongoose'

Ticket = require '../models/ticket'

TicketFetcher = require '../fetchers/desk'

module.exports =
  get: (req) ->
    Ticket.find (err, tickets) ->
      req.reply tickets

  update: (req) ->
    req.reply 'ok'
    TicketFetcher.query()