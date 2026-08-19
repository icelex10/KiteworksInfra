# KiteworksInfra

Terraform infrastructure for the Kiteworks application.

## Foundation pipeline

[`azure-pipelines.yml`](azure-pipelines.yml) is a manually triggered Azure DevOps
pipeline that validates and deploys the environment resource groups. It
uses the Azure Storage account `sakiteworkstfstate1` and the private `tfstate`
blob container as the Terraform remote state backend. The state key is
`resource-groups.terraform.tfstate`.

The Terraform configuration is in [`terraform`](terraform). It creates the
following long-lived foundation resource groups in `centralus` (Central US):

- `rg-kiteworks-dev`
- `rg-kiteworks-staging`
- `rg-kiteworks-prod`

The Azure region is configured in [`terraform/terraform.tfvars`](terraform/terraform.tfvars).

## Azure DevOps setup

1. Create an Azure Resource Manager service connection in Azure DevOps using
	the Azure subscription that owns the state storage account.
2. Grant the service principal or workload identity used by that connection:
	- `Storage Blob Data Contributor` on storage account
	  `sakiteworkstfstate1` (or on the `tfstate` container scope).
	- `Contributor` on the subscription or target resource-group scope so the
	  pipeline can create the resource group.
3. Replace `sc-kiteworks-azure` in `azure-pipelines.yml` with the service
	connection name.
4. Confirm that the `tfstate` blob container already exists and is private.
5. Run the pipeline manually from Azure DevOps.

The pipeline uses Azure CLI authentication and Entra ID authorization for the
backend. No storage account key or client secret is stored in the repository.

## Local validation

From the repository root:

```bash
cd terraform
terraform init -backend=false
terraform fmt -check -recursive
terraform validate
```

The pipeline performs the deployment with `terraform apply -auto-approve` after
the validation and plan steps succeed.
