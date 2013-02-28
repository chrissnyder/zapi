mongoose = require 'mongoose'

Project = require '../models/project'

# Fetchers
GithubFetcher = require '../fetchers/github'

module.exports =
  get: (req) ->
    if req.params.name
      Project.findOne {'name': req.params.name}, (err, project) ->
        req.reply project
    else
      Project.find {}, 'name repo', (err, projects) ->
        req.reply projects

  create: (req) ->
    project =
      name: req.payload.name
      repo: req.payload.repo
    Project.create project, ->
      req.reply 'ok'

  update: (req) ->
    req.reply 'ok'
    Project.find (err, projects) ->
      for project in projects
        GithubFetcher.getRepo project, (err, gitProject) ->
          for key, value of gitProject
            project[key] = value
          project.save()