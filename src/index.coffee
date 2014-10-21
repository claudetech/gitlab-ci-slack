express    = require 'express'
bodyParser = require 'body-parser'
request    = require 'request'

port     = process.env['PORT'] || 5000
ciUrl    = process.env['CI_SERVER_URL']
slackUrl = process.env['SLACK_URL']
username = process.env['CI_SLACK_USERNAME'] || 'Gitlab CI'

app = express()
app.use bodyParser.json()

diffUrl = (body, url) ->
  "#{url}/compare/#{body.before_sha}...#{body.sha}"

diffLink = (body, url) ->
  "<#{diffUrl(body, url)}|#{body.sha[0..6]}>"

buildLink = (body) ->
  if ciUrl
    "<#{ciUrl}projects/#{body.project_id}/builds/#{body.build_id}|##{body.build_id}>"
  else
    "##{body.build_id}"

getTime = (body) ->
  diff = Date.parse(body.build_finished_at) - Date.parse(body.build_started_at)
  min = Math.floor((diff / 1000) / 60)
  sec = Math.floor((diff / 1000) % 60)
  "#{min} min #{sec} sec"

app.post '/', (req, res) ->
  body = req.body
  repoUrl = body.gitlab_url
  diff = diffLink(body, repoUrl)
  build = buildLink(body)
  branch = body.push_data.ref
  author = "#{body.push_data.user_name}"
  pushInfo = "#{body.project_name}@#{branch} by #{author}"
  time = getTime(body)
  text = "Build #{build} (#{diff}) of #{pushInfo} finished with #{body.build_status} in #{time}."
  icon = if body.build_status == 'success' then ':ok:' else ':warning:'

  data =
    text: text
    icon_emoji: icon
    username: username

  request.post(url: slackUrl, body: data, json: true)
  res.send 'ok'

app.listen port
