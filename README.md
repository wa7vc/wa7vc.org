# Wa7vc
An umbrella app containing the WA7VC.org website, and Marvin, our depressed robot assistant.

## Development
ASDF is used to ensure the correct versions of needed software, so either use ASDF or consult .tool-versions to ensure you have the right versions on your development system.


## Deployment

### Secret Files
There are several config files that will need to be created:
./apps/marvin/config/prod.secret.exs
```
use Mix.Config

config :marvin, Marvin.Robot,
  password: "IRC User Password Goes Here"

config :marvin, Marvin.Hooker,
  github_webhook_secret: "The Github Webhook Secret (salt) Goes Here"
```

./apps/wa7vc_web/config/prod.secret.exs
```
use Mix.Config

config :wa7vc_web, Wa7vcWeb.Endpoint,
  secret_key_base: "App Secret Key Goes Here"
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
Now you should be able to use scripts/build-release.sh to build the release
