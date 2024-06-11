# Safely Running Terraform Locally
Okay so terraform is incredibly powerful 



## Terraform Prerequisites




1. Need a Linode bucket created to store terraform state:  See [here](https://www.linode.com/docs/products/storage/object-storage/guides/manage-buckets/):
1. Need a Linode API key to use for writing the state information from Terraform. See [here](https://www.linode.com/docs/products/storage/object-storage/guides/access-keys/).  Note it will need read/write access.
1. Need a domain that can be used for deployments. It's DNS should be in edge DNS. 