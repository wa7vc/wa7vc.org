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
