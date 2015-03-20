# gitlab-ci-slack

[DEPRECATED] This functionality is now [built-in Gitlab CI](https://gitlab.com/gitlab-org/gitlab-ci/commit/a40989d27ea8a1c5d23dfd5b82f25e09527b2c80) and this repository is therefore obsolete.

Tiny web server to get Travis-like Slack notifications
with Gitlab CI.

## Configure

First, set the following environment variables.

```javascript
port     = process.env['PORT'] || 5000
ciUrl    = process.env['CI_SERVER_URL']
slackUrl = process.env['SLACK_URL']
username = process.env['CI_SLACK_USERNAME'] || 'Gitlab CI'
```

* `PORT` is the port the webapp will be listening to
* `CI_SERVER_URL` is your Gitlab CI url
* `SLACK_URL` is Slack webhooks URL
* `CI_SLACK_USERNAME` is the username to be used when posting

## Running

Just run

```sh
$ npm install
$ npm start
```

and add a Gitlab CI webhook to point to the server.

## Deploying

The app works perfectly on a free heroku dyno, if you have an account it's as simple as pressing the button below and setting the relevant config variables in the web admin console.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

