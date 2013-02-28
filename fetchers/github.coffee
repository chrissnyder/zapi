async = require 'async'
config = require('config').github
GithubApi = require 'github'
mongoose = require 'mongoose'

class GithubFetcher
  constructor: ->
    @gitapi = new GithubApi config.options
    @gitapi.authenticate config.auth

  getRepo: (project, repo_cb = null) =>
    @gitapi.repos.get {user: 'zooniverse', repo: project.repo}, (err, repo_res) =>
      throw err if err
      # Get additional repo information
      async.parallel
          commits: (cb) =>
            opts = {user: 'zooniverse', repo: project.repo}
            opts.sha = project.branch if project.branch
            @gitapi.repos.getCommits opts, (err, res) ->
              throw err if err
              cb null, res.slice(0, 2)
          ,
          issues: (cb) =>
            @gitapi.issues.repoIssues {user: 'zooniverse', repo: project.repo, state: 'open'}, (err, res) ->
              cb null, res.slice(0, 2)
        ,
        (err, res) =>
          for key, value of res
            repo_res[key] = value
          repo_res = @_cleanRepoData repo_res
          if repo_cb then repo_cb null, repo_res else repo_res

  getAllRepos: (projects, cb = null) =>
    funcList = []

    for project, i in projects
      do (project) =>
        funcList.push (callb) =>
          @getRepo project, callb

    async.parallel funcList, (err, res) ->
      if cb then cb null, res else res

  # Helpers
  _cleanRepoData: (repo) ->
    cleanRepo = {}
    for key, value of repo when key isnt ['meta', 'organization', 'permissions']
      cleanRepo[key] = value

    return cleanRepo

module.exports = new GithubFetcher