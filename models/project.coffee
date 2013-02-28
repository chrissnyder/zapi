mongoose = require 'mongoose'

projectSchema = mongoose.Schema
  name: String
  repo: String
  issues: Array
  commits: Array

Project = mongoose.model 'Project', projectSchema

module.exports = Project