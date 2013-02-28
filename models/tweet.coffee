mongoose = require 'mongoose'

tweetSchema = mongoose.Schema
  author: String
  author_name: String
  text: String
  time: Date

Tweet = mongoose.model('Tweet', tweetSchema)

module.exports = Tweet