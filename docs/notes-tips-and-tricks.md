# Notes 
## Action Behaviors
- Branches with the prefix `integration-*` will be treated as integration environments.  THey will get builds.  All other branches will not have any special treatment, they will just be normal development branches that do not receive automated builds unless they are PR'd.

## aarch64 vs amd64
In olden times everyone ran on x86_64 machines and everything worked fine.  Then the world changed. You laptop may be running ARM. Your cloud jobs may be working on x86_64.  The development.Dockerfile has been designed to work on both.  However, remember that you will need to rebuild the image for each architecture.  

## To test container changes locally
I have found that editing a container file, and then rebuilding your devcontainer isn't the greatest workflow.  It throws cryptic errors and its slow and tedious.  Its far more efficient to make your changes and first just see if the docker-file builds okay. 
run `podman image build -f development.Dockerfile --no-cache`

If it works here then move onto devcontainer.


## Connecting Cyberduck to Linode Bucket
Sometimes its useful to connect to your bucket to check on your TF state or in extremely rare occurences to manually delete it. These instructions are for Cyberduck but can be genralized for other S3 capable clients:
https://www.linode.com/docs/products/storage/object-storage/guides/cyberduck/

## Troubleshooting Remote State issues in Builds
If you are seeing issues with TF-state in your build sometime its easier to debug locally.  
1. You can override `workspace_key_prefix` in `terraform/providers.tf`.  
1. Set it to `terraform/ci/workspace`. 
1. From the CLI make sure that you are in the terraform directory
1. Run `tofu init`
1. run `tofu workspace set <your workspace>`
1. now you can run commands like `tofu output -raw akamai_property_id` to help debug the issue