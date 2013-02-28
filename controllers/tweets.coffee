mongoose = require 'mongoose'

Tweet = require '../models/tweet'
Setting = require '../models/setting'

TwitterFetcher = require '../fetchers/twitter'

module.exports =
  get: (req) ->
    Ticket.find (err, tickets) ->
      req.reply tickets

  update: (req) ->
    req.reply 'ok'
    TwitterFetcher.search()

  getTerms: (req) ->
    Setting.findOne {name: 'twitter'}, (err, settings) ->
      if settings?
        req.reply settings.value.terms
      else
        req.reply []

  setTerm: (req) ->
    Setting.findOne {name: 'twitter'}, (err, setting) ->
      if setting
        console.log 'setting', setting, req.payload
        setting.value.terms.push req.payload.term
        console.log 'post push', setting
        setting.save (err, setting) ->
          console.log err, setting
          req.reply 'ok'
      else
        # No terms exist
        obj =
          name: 'twitter'
          value:
            terms: [req.payload.term]
        Setting.create obj, (err, setting) ->
          req.reply 'ok'
