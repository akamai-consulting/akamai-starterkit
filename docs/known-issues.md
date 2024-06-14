# Outstanding issues
## Git Credentials
Currently ssh keys aren't forwarding from host to the dev-container guest.  That means a `git push` will work from host but not from inside devcontainer.Get the git credentials to forward from host
https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials

# Akamai TF Provider State Tracking
There is a known issue in the Akamai Terraform Provider [here](https://github.com/akamai/terraform-provider-akamai/issues/560).  It means that state is not always updated when doing`terraform apply`.  

## Add approval workflow for production deployments
## Setup production deployment using the actual production network.
## Test PRs
## Figure out if we can avoid needing a deployment.