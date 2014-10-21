# gitlab-ci-slack

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
