(function() {
  var app, bodyParser, buildLink, ciUrl, diffLink, diffUrl, express, getTime, port, request, slackUrl, username;

  express = require('express');

  bodyParser = require('body-parser');

  request = require('request');

  port = process.env['PORT'] || 5000;

  ciUrl = process.env['CI_SERVER_URL'];

  slackUrl = process.env['SLACK_URL'];

  username = process.env['CI_SLACK_USERNAME'] || 'Gitlab CI';

  app = express();

  app.use(bodyParser.json());

  diffUrl = function(body, url) {
    return "" + url + "/compare/" + body.before_sha + "..." + body.sha;
  };

  diffLink = function(body, url) {
    return "<" + (diffUrl(body, url)) + "|" + body.sha.slice(0, 7) + ">";
  };

  buildLink = function(body) {
    if (ciUrl) {
      return "<" + ciUrl + "projects/" + body.project_id + "/builds/" + body.build_id + "|#" + body.build_id + ">";
    } else {
      return "#" + body.build_id;
    }
  };

  getTime = function(body) {
    var diff, min, sec;
    diff = Date.parse(body.build_finished_at) - Date.parse(body.build_started_at);
    min = Math.floor((diff / 1000) / 60);
    sec = Math.floor((diff / 1000) % 60);
    return "" + min + " min " + sec + " sec";
  };

  app.post('/', function(req, res) {
    var author, body, branch, build, data, diff, icon, pushInfo, repoUrl, text, time;
    body = req.body;
    repoUrl = body.gitlab_url;
    diff = diffLink(body, repoUrl);
    build = buildLink(body);
    branch = body.push_data.ref;
    author = "" + body.push_data.user_name;
    pushInfo = "" + body.project_name + "@" + branch + " by " + author;
    time = getTime(body);
    text = "Build " + build + " (" + diff + ") of " + pushInfo + " finished with " + body.build_status + " in " + time + ".";
    icon = body.build_status === 'success' ? ':ok:' : ':warning:';
    data = {
      text: text,
      icon_emoji: icon,
      username: username
    };
    return request.post({
      url: slackUrl,
      body: data,
      json: true
    });
  });

  app.listen(port);

}).call(this);
