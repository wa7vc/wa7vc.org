# Wa7vc
An umbrella app containing the WA7VC.org website, and Marvin, our depressed robot assistant.

## Development
ASDF is used to ensure the correct versions of needed software, so either use ASDF or consult
.tool-versions to ensure you have the right versions on your development system.

New versions to deploy to production are tagged in git following typical SemVer style.

### Development Notes
  - Phoenix 1.3>1.4 upgrade was done following [this gist](https://gist.github.com/chrismccord/bb1f8b136f5a9e4abc0bfc07b832257e), however the "replace brunch with webpack" step was not followed, nor the ecto upgrade (no ecto active at th etime).

## Deployment
While anything Elixir can compile to will work as a server, by default we're using an Ubuntu 18 VM.

An important point is that both the production server and the build server should be on the same distro,
otherwise the builds may not work. Deploying on Ubuntu 18? Build on Ubuntu 18.

SSH Aliases are used by the deploy script, so you will need to have the correct servers set up in your
~/.ssh/config for the following aliases:
  - wa7vc_ed_build
  - wa7vc_ed_prod1

Deployment builds are build by [distillery](https://github.com/bitwalker/distillery) and deployment is
done using [edeliver](https://github.com/edeliver/edeliver). This allows us to do zero-downtime upgrades.
As long as you have an SSH key with access to the production servers the following commands can be used
to deploy an ugrade:
  - `mix edeliver build upgrade --from=x.x.x --to=y.y.y` (Where x.x.x is the tagged version currently on the prod server, and y.y.y is the tagged version to upgrade to)
  - `mix edeliver deploy upgrade to production`

(Initial deployment to a clean server uses "release" instead of "upgrade")

Other relevant edeliver commands:
```
mix edeliver ping production                # shows which nodes are up and running
mix edeliver version production             # shows the release version running on the nodes
mix edeliver show migrations on production  # shows pending database migrations
mix edeliver migrate production             # run database migrations
mix edeliver restart production             # or start or stop
```

### Ubuntu Server Setup
```
# Install necessary packages.
sudo apt-get install git libssl-dev make automake autoconf libncurses5-dev gcc unzip

# Install ASDF
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

# Install ASDF Plugins
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf plugin-install nodejs
asdf plugin-install erlang
asdf plugin-install elixir
```

### Systemd Service
Production servers will need to have a systemd service created at /etc/systemd/system/wa7vc_umbrella.service

This file will contain some of the "secrets" for the app, which will need to be filled into the Environment
variables. Putting these inside the systemd service itself seems to work better than using an EnviromentFile
directive.

```
[Unit]
Description=WA7VC Website and Services
After=local-fs.target network.target

[Service]
User=wa7vc
Group=wa7vc
Restart=on-failure
RemainAfterExit=yes
LimitNOFILE=65536
WorkingDirectory=/home/wa7vc/production/wa7vc_web
Environment=MIX_ENV=prod
Environment=HOME=/home/wa7vc/production/wa7vc_web
Environment=PORT=49515
# Note that if your passwords have any %s in them you need to convert them to %% in order to keep systemd happy.
Environment=MARVIN_IRC_PASSWORD=
Environment=GITHUB_WEBHOOK_SECRET=
Environment=SECRET_KEY_BASE=
Environment=SENTRY_DSN=
Environment=REPLACE_OS_VARS=true
ExecStart=/home/wa7vc/production/wa7vc_web/bin/wa7vc_web start
ExecStop=/home/wa7vc/production/wa7vc_web/bin/wa7vc_web stop

[Install]
WantedBy=multi-user.target
```

Once the initial release is deployed to the server this service should be enabled and started.
