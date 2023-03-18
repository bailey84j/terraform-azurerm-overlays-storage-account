module "mod_rg" {
  source  = "azurenoops/overlays-resource-group/azurerm"
  version = "~> 1.0.1"

  location      = module.azure_region.location
  org_name      = var.org_name
  environment   = var.environment
  workload_name = var.workload_name
}

module "mod_storage_account" {
  source  = "azurenoops/overlays-storage-account/azurerm"
  version = "~> 1.0.0"

  # Global Settings
  resource_group_name = module.mod_rg.resource_group_name
  location            = var.location  
  org_name            = var.org_name
  environment         = var.environment
  workload_name       = var.workload_name

  # To enable advanced threat protection set argument to `true`
  enable_advanced_threat_protection = true

  # Container lists with access_type to create
  containers_list = [
    { name = "store250", access_type = "private" },
    { name = "blobstore251", access_type = "blob" },
    { name = "containter252", access_type = "container" }
  ]

  # To enable resouce locks set argument to `true`
  enable_resource_locks = true
  lock_level            = var.lock_level

  # Adding TAG's to your Azure resources (Required)
  # Org Name and Env are already declared above, to use them here, create a varible. 
  add_tags = merge(var.tags, {
    DeployedBy = format("AzureNoOpsTF [%s]", terraform.workspace)
    Organizaion = var.org_name
    Environment = var.environment
    Workload = var.workload_name
  }) # Tags to be applied to all resources
}
