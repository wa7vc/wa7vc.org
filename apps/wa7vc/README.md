# WA7VC
The WA7VC website frontend. 

It's a website. Not a lot to say. :-)

## Development
A simple `mix setup` should do the trick!

To start the server in development and be able to communicate with Marvin
the app must be launched from the apps/wa7vc directory passing the --name
flag to iex: `iex --name "wa7vc@127.0.0.1" -S mix phx.server`
Or, for convenience, just `./run_dev_server.sh`

## Deployment
Marvin and the WA7VC website are deployed as two unique OTP apps, allowing
Marvin to stay up and running and collecting stats while we easily redeploy
the website for updates.

To deploy the app you can use the Ansible task found in the root of the shared
repository, which is designed to deploy to a
[Daedalus Dreams appserver](https://gitlab.daedalusdreams.com/DaedalusDreams/infrastructure-via-ansible/-/tree/master/roles/app-server):
`ansible-playbook main.yml --tags wa7vc`

However you can also do it as a 2-stage process if you're not confident in your
build completing cleanly:
  * from apps/wa7vc: `./release.sh`
  * from repository root:
    `ansible-playbook main.yml --tags wa7vc --skip-tags build`

if you're deploying marvin somewhere else the steps are pretty easy:
  * Execute ./release.sh  
    This uses docker to build a release locally that matches the deployment
    environment. (So shared libs are all correct)
  * Copy the built release wa7vc.tar.gz from apps/wa7vc/tmp to the server
  * Extract the .tar.gz
  * Run the app, providing the necessary ENV variables:
    * LANG=en_US.UTF-8
    * PORT=49515
    * RELEASE_COOKIE=
    * SECRET_KEY_BASE=
    * LIVEVIEW_SECRET_SALT=
    * GITHUB_WEBHOOK_SECRET=
    * SENTRY_DSN=
    
    The application could run standalone on port 80, but is designed to run
    behind an SSL terminating proxy server, (nginx/traefik) and so the port
    should be the port that the proxy server uses to reach the application.
    Note that the cookie must be a shared cookie between the WA7VC webapp
    and the Marvin backend.  
    For production deployment the secrets that should populate these vars
    are kept in an ansible vault.  
    The ansible deployment task includes a systemd unit that runs the
    application, restarts it if necessary, and provides it the necessary ENV.

## External Setup Required
  * Github Webhooks:  
    In order to receive github webhooks for the repo, github must be set to
    send webhooks to https://wa7vc.org/webhooks/github  
    It should be set to "send me everything", and the correct/matching secret.

## Notes
  * In order to use the `./wa7vc remote` to access to remote console you will
    need to start it with the RELEASE_COOKIE  environment variable containing
    the production cookie.
