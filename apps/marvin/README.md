# Marvin
The poor depressed robot.
He's so bored, constantly monitoring details that the puny humans seem to think
are important, but he does his job, with only minimal complaint.

Visit Marvin [here](https://wa7vc.org/marvin) to see what he's up to.

## Development
Prepping for development is simple. In the marvin directory run:
  * mix deps.get


To start the server in development and let marvin and the website frontend work
together marvin must be launched from from the apps/marvin directory passing
the --name flag to iex: `iex --name "marvin@127.0.0.1" -S mix`
Or, for convenience, just `./run_dev_server.sh`

If multiple developers are developing on Marvin at the same time there will be
collisions in the IRC channel as they try to use the same name. Developers can
customize their Marvin's name in config/dev.exs

## Deployment
Marvin and the WA7VC website are deployed as unique applications as unique OTP
nodes. This allows Marvin to stay up and running and really build up those
"how many times have I done this" count while the webapp gets redeployed
regularly to update content and such.

To deploy the app you can use the Ansible task found in the root of the shared
repository, which is designed to deploy to a 
[Daedalus Dreams appserver](https://gitlab.daedalusdreams.com/DaedalusDreams/infrastructure-via-ansible/-/tree/master/roles/app-server):
`ansible-playbook main.yml --tags marvin`

However you can also do it as a 2-stage process if you're not confident in your
build completing cleanly:
  * from apps/marvin: `./build_release.sh`
  * from repository root:
    `ansible-playbook main.yml --tags marvin --skip-tags build`

if you're deploying marvin somewhere else the steps are pretty easy:
  * Execute ./release.sh  
    This uses docker to build a release locally that matches the deployment
    environment. (So shared libs are all correct)
  * Copy the built release marvin.tar.gz from apps/marvin/tmp to the server
  * Extract the .tar.gz
  * Run the app, providing the necessary ENV variables:
    * LANG=en_US.UTF-8
    * RELEASE_COOKIE=YOUR_SECRET_COOKIE
    * MARVIN_IRC_PASSWORD=YOUR_IRC_PASSWORD
    
    Both the secret cookie and irc password for the WA7VC deployment are stored
    in an ansible vault. Note that the cookie must be a shared cookie between
    Marvin and the WA7VC website app.  
    The ansible deployment task includes a systemd unit that runs the
    application, restarts it if necessary, and provides it the necessary ENV.

## Notes
  * In order to use the `./marvin remote` to access to remote console you will
    need to start it with the RELEASE_COOKIE env variable containing the cookie
  * Have had trouble with IRC bot staying connected on occasion.  
    Can execute the following manually via remote console to fix:
    ```
    > GenServer.cast(Marvin.IrcRobot.get_pid(), {:reconnect})
    ```
