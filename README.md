# What is this?
This is a demo and template for development teams working with Akamai.  This template gives you 3 things:
1. A fully configured IDE/local development environment via [VSCode DevContainer](https://code.visualstudio.com/docs/devcontainers/containers).  The environment can be extended by any team and provide standardized tools and consistent local development across your team.  

1. Templates to track Akamai configuration and infrastructure as code(IaC) via Terraform.  Yeah no more clicking buttons in a UI.  Every change can be tracked managed and seamlessly moved from environments. 

1. GitHub Actions for supporting a Github pull request based workflow.  The union of Terraform and GitHub actions unlocks complete on-demand Akamai environments.  Developers can test their code in a real environment before submitting it for a code review and merging to a shared environment. Want integration environments to support your preferred workflow?  No problem.  Prefix branch names corresponding to your environments with "integration-*"  

# Why should I care?
- Out of the box Akamai supports staging and production environments.  This template gives you the tools to create any code promotion process you want.  Do you want `dev` -> `uat` -> `staging` -> `prod`?  No problem.  
- Faster developer onboarding.  With a clearly paved path customer and new devs on customer teams can be productive with Akamai sooner. 
- Mitigate risk of merging code.  In the old days merging code to an integration envrionment for the first time often carried risk that the shared environment could be broken.  This workflow dramatically reduces this risk by `shifting left`.  If something goes horribly wrong it will only impact a single develope not an entire team!
- Faster development. If you don't need to fear taking down environments anytime you merge code or want to test changes you can be more agressive and move faster!
- Putting all these pieces together yourself takes time.  
- You can get your entire team working with identical local environments. As tools are added they can be merged centrally to the repo.  Devs can pull down the updates and rebuild the container locally to get the new changes. 
- Getting all this out of the way lets you spend more time innovating with Akamai products and delivering business value to your stakeholders.

# Resources to get started:
- [Getting Started Locally](docs/getting-started.md)
- [Akamai Prequisites](docs/akamai-prerequisites.md)
- [Safely Running Terraform Locally](docs/safely-running-terraform-locally.md)
- [Importing Existing Property](docs/importing-existing-property.md)

# Additional Resources
- [Terraform Basics](docs/terraform-basics.md): Just a superficial quick start.
- [Gotchas](docs/gotchas.md): There are things that burned us setting this up and we wanted to document them.
- [Known Issues](docs/known-issues.md):  We know there are some quirks to iron out. 
- [Notes Tips and Tricks](docs/notes/notes-tips-and-tricks.md): Few tricks that can come in handy!

# Existential Questions
Any solution implies new problems :)


## Farewell to managing IaC resources in the UI
Working with Infrastructure as Code(IaC) stored in version control(VCS) requires a mindshift change.  Akamai was traditionally managed via the web-ui portal. That was the system of record. When you switch from being UI centric to IaC you need to delineate which things are being managed by code and STOP editing them via the web.  The IaC is supposed to be the system of record. If you are making changes to the UI and then backporting them to the IaC you are doing it wrong!  Instead make the change to IaC and let an IaC deployment make the change for you.  

You may need to start to limit UI access as you embark on this journey to protect against this situation.

## Supporting IaC customers
Akamai personnel are traditionally granted access to customer accounts as their responsibilities dictate. Nothing is changing there.  However, when code starts being managed in IaC things get messier.  Akamai does not provide VCS systems.  The VCS where IaC is stored is owned by the customer.  Customers may in some cases provide accounts for Akamai support teams.  But this may not be universally true.  Some work arounds might be:
- Identifying a property that the customer requires support with and using Terraform/Akamai-CLI to export it as terraform which can then be tested again a new property following these instructions: [Importing Existing Property](docs/importing-existing-property.md)
- a dump of the customers code can be provided over a secure transfer.  Akamai personnel can then use that to do a test deployment against a new property.

# Glossary
- IaC: Infrastructure as code.  A pattern for managing infrastructure in a repeatable way that can be tracked, managed and deployed with ease
- Terraform: A leading tool for managing cloud resources using IaC patterns.
- Tofu/OpenTofu: A fork of Terraform made due to licensing changes in terraform.
- DevContainer: A standard for augmenting standard containers with developer centric tooling.  This standard is supported by VSCode and GitHub codespaces.  You can read more [ about the standard here](https://containers.dev/), [about devcontainers with vscode here](https://code.visualstudio.com/docs/devcontainers/containers), [about devcontainer support in github codespaces here](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers) 
- VCS: Version control system. These days various flavors of Git are univerally used: GitLab, GitHub, Bitbucket, etc.

# Terms
This project is unofficial and unsupported by Akamai Inc.  It represents an individual effort to make working with Akamai easier. 
