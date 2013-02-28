mongoose = require 'mongoose'
findOrCreate = require 'mongoose-findorcreate'
mongoose.plugin(findOrCreate)

settingSchema = mongoose.Schema
  name: String
  value: mongoose.Schema.Types.Mixed

Setting = mongoose.model('Setting', settingSchema)

module.exports = Setting