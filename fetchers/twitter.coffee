config = require('config').twitter
Twitter = require 'twit'

TweetModel = require '../models/tweet'

class TwitterFetcher
  search_terms: [
    'the_zooniverse'
    'galaxy_zoo'
    'galaxyzoo'
    'seafloorexplorer'
    'seafloorexp'
    'batdetective'
    'cyclonecenter'
  ]

  constructor: ->
    @twitter = new Twitter config.auth

  search: =>
    terms = @search_terms.join " OR "
    @twitter.get 'search/tweets', {q: terms, rpp: 15, lang: 'en'}, @processData

  processData: (err, data) =>
    twitter_data = []
    if err then console.log 'Error retrieving data from twitter'; return

    for result in data.statuses
      datum =
        id: result.id
        author: result.user.screen_name
        author_name: result.user.name
        text: result.text
        time: result.created_at
      if twitter_data.indexOf(datum) == -1
        twitter_data.push datum

    @saveData twitter_data

  saveData: (data) ->
    for datum in data
      TweetModel.create datum, (err, doc) ->
        TweetModel.count {}, (err, count) ->
          if count > 15
            TweetModel.findOneAndRemove {}, ->

module.exports = new TwitterFetcher