# WA7VC.org
The website of the WA7VC Ham Radio club.

The website is made up of two unique Elixir OTP applications:
  * apps/wa7vc - a web frontend using Phoenix 
  * apps/marvin - a depressed robot assistant as a backend service

Deployment is handled via an ansible task found in the project root, and is
designed to be deployed to a DaedalusDreams AppServer system, but could easily
be adapted to deploy elsewhere.

Specific instructions for each application lie in the README files in their
respective folders in apps/.

## Development
To begin development:
  * clone the repo and CD into the directory
  * create the .ansible_vault_pass file containing the correct ansible vault password
  * `asdf install` to install the correct erlang/elixir/nodejs versions using ASDF`
then follow the instructions for each app in the apps/ directory.

## Deployment
The ansible playbook will do a couple of useful steps besides simply running the compile and deploying the result.  
In order to prevent compiling in un-comitted code, the playbook will ensure that the repo is in a sane state, with a app@version tag as the most recent commit, and no un-comitted code.  
It will also run the test suite and ensure that it passes before attempting to compile.

The `--generic` tag sets up the NGINX config, which is specific to the way DaedalusDreams app servers are configured. This provides us our error pages and SSL cert setup.

Build and deploy *only* the WA7VC web app, leaving Marvin running with:  
`ansible-playbook main.yml --tags build,deploy --skip-tags marvin`  
(--skip-tags wa7vc to do the inverse of course)  

Fresh server? Use the `--tags initial-deploy` tag. 

Systemd problems after a server upgrade? `--tags systemd` will install and run the systemd unit files to start and run the apps.
