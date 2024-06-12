# Importing Existing Property
Okay we know that not everyone is starting from scratch with Akamai. In fact we hope that you've already got some experience and you're looking to expand your knowledge of Akamai's products. So let's import an existing property. We'll use the same one as before, but this time it will be imported into a new project.

## How can we export the configuration?
We have 2 different tools that we can leverage. One is acctually just a wrapper around the other.  So the Akamai terraform provider will allow you to export the current state of your property as terraform code.  Akamai CLI can wrap terraform to do the same thing. Luckily for you both are pre-installed in the devcontainer environment we are using in this repository.

You can find the instructions for the Akamai CLI tool [here](https://github.com/akamai/cli-terraform?tab=readme-ov-file#general-usage)

Assuming you have an $HOME/.edgerc file.  If you don't have one then please create it.

You can simply execute like so:  
 `akamai terraform export-property --rules-as-hcl "<property-name>"`
 Note if you have multiple accounts then you will need to specify which account
 `akamai --account-key "B-C-1ED34DK" terraform export-property --rules-as-hcl "<property-name>"`

 You can repeat for the various akamai products you want to manage with IaC:

- domain
- zone
- appsec
- clientlist
- property
- property-include
- cloudwrapper
- cloudlets-policy
- edgekv
- edgeworker
- iam
- imaging
- cps

## What do I do with the output?
In this repository you will see a `terraform` directory.  Most of the code is isolated to creating environments and attaching domains to them. 