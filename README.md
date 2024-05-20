# What is this?
This is a demo of modern dev-ops enabled project.  It makes local development a snap by leveraging [DevContainer](https://code.visualstudio.com/docs/devcontainers/containers) and github actions for a CI/CD workflow 

At the highest level it will 
- create a new EdgeWorker per branch or pull request
- deploy code to it
- deploy that to Akamai staging
- Set up default routing to expose the PR EW
- Run automated test against that PR EW

This example will use terraform, github, github actions to deploy.  

If you don't use GitHub Actions don't worry. The example actions can easily be adapted to most CI/CD systems.

# Development Environment.  
This is an integrated local development environment that runs on your computer inside a container. The purpose of this approach is to provide different projects and members on those projects identical development environments: including the tools installed in that container and the VSCode  extensions used by all project developers.

It also allows the developer to interact with the identical container being using in CI to more easily debug CI issues.

# Getting Started Locally Windows:
1. Install Podman Desktop [https://podman-desktop.io/downloads](https://podman-desktop.io/downloads)
1. Install VSCode: [https://code.visualstudio.com/download](https://code.visualstudio.com/download)
1. Open the VSCode project folder in a terminal window using the command `code .`
1. It will prompt you to install some extensions, just click on "Install" for all of them.
1. It will prompt you to reopen the project in a devcontainer.  Do so. 

# Getting Started Locally Mac
All you need to get started for:
1. Install Brew `https://brew.sh/`
1. Install VSCode `brew cask install vscode`
1. Install Podman and Podman desktop  `brew cask install podman-desktop`
1. Open the VSCode project folder in a terminal window using the command `code .`
1. It will prompt you to install some extensions, just click on "Install" for all of them.
1. It will prompt you to reopen the project in a devcontainer.  Do so. 

Thats it. Now VSCode is running inside a container and your local development environment should be identical across all projects that use this approach.  The Terminal inside VS code is attached to the container.  OOTB things like `terraform` `tofu` or `akamai` will just work.  Want to add something else to the mix?  Edit [development.Dockerfile] and rebuild your local devcontainer.

## Terraform Prerequisites
1. Need an Akamai API key created with the following permissions:
    1. CPS (@todo Can probably remove this now)
    1. Diagnostic Tools
    1. DNS—Zone Record Management 
    1. Edge Diagnostics 
    1. Edge Hostnames API (hapi)  (@todo Can probably remove this now)
    1. EdgeKV
    1. EdgeWorkers
    1. Property Manager (PAPI)

    You can go [here](https://control.akamai.com/apps/identity-management/#/tabs/users/list) to make one.  NOTE do NOT select all API's it will cause errors later. Select only the API's you need.  We reccomend making one API key for CI and another for each dev who wishes to run this locally. 
    https://techdocs.akamai.com/developer/docs/set-up-authentication-credentials

1. Need a Linode bucket created to store terraform state:  See [here](https://www.linode.com/docs/products/storage/object-storage/guides/manage-buckets/):
1. Need a Linode API key to use for writing the state information from Terraform. See [here](https://www.linode.com/docs/products/storage/object-storage/guides/access-keys/).  Note it will need read/write access.
1. Need a domain that can be used for deployments. It's DNS should be in edge DNS. 


## Setting up CI-CD
This worker expects several secrets to be set in order to run:

Terraform Keys
- `GROUP_ID`: The group in akamai where new properties will be created.
- `CONTRACT_ID`: The contract for Akamai 
- `EDGERC`: Akamai API key needed by terraform to make changes on the Akamai infrastructue. 
- `BASE_URL`: The name of the URL under edgedns control.

State Bucket Keys:
- `LINODE_ACCESS_KEY`: Keys for using Linode for storing terraform state. 
- `LINODE_SECRET_KEY`: Keys for using Linode for storing terraform state.
- `TF_BACKEND_BUCKET_NAME`: The name of the bucket used for storing TF-state


Note for local development each of these Terraform Keys can be stored in a `/terraform/local-dev.tfvars file.  That TF vars file may be used when invoking TF commands like so:  `tofu plan -var-file=local-dev.tfvars -out tf.plan`. 

The State Bucket Keys are a little different.  You can set them as the ENV variables:  
`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.  Even though they say AWS this will work for linode.  I know it's confusing! 

When you first invoke terraform init you will be prompted for the bucket. 

## To get github actions to write to the registry you need to 
- go to repository settings
- Select actions -> general
- Workflow permissions select "Read and Write Permissions"
- Don't forget to click save!

# Notes 
## Action Behaviors
- Branches with the prefix `integration-*` will be treated as integration environments.  THey will get builds.  All other branches will not have any special treatment, they will just be normal development branches that do not receive automated builds unless they are PR'd.

## aarch64 vs amd64
In olden times everyone ran on x86_64 machines and everything worked fine.  Then the world changed. You laptop may be running ARM. Your cloud jobs may be working on x86_64.  The development.Dockerfile has been designed to work on both.  However, remember that you will need to rebuild the image for each architecture.  

## To test container changes locally
run `podman image build -f development.Dockerfile --no-cache`

## Parser for Edge Worker bundles is finicky
If you are building a tgz for edge workers know that the parser will error if the archive has any enclosing directory info wrapping the bundle.json and main.js.  You MUST run the command from inside the directory.
The following will work:
- `tar -czvf ../terraform/edge-worker-bundle.tgz *`
- `tar -czvf ../terraform/edge-worker-bundle.tgz bundle.json main.js`

However the following will NOT work:
- `tar -czvf filename2.tgz edge-worker/bundle.json edge-worker/main.js`
- `tar -czvf foo.tar.gz -C edge-worker .`

TLDR if you run `tar -tzvf foo.tar.gz` and see any leading `./` or other leading directories the edgeworker validator will fail.  

## Connecting Cyberduck to Linode Bucket
Sometimes its useful to connect to your bucket to check on your TF state or in extremely rare occurences to manually delete it. These instructions are for Cyberduck but can be genralized for other S3 capable clients.
1. Install Cyberducks
1. Go to `Settings` -> `Connection Profiles`
1. Search for linode
1. Select the correct region for your bucket.
1. Save
1. Reopen the connection window and select it.  Will be towards the bottom of the drop down.

# Outstanding issues
## Git Credentials
Get the git credentials to forward from host
https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials

## Add approval workflow for production deployments
## Setup production deployment using the actual production network.
## Test PRs
## Figure out if we can avoid needing a deployment. 