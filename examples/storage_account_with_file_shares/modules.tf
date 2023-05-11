module "rg" {
  source  = "azurenoops/overlays-resource-group/azurerm"
  version = "~> 1.0.1"

  location      = module.azure_region.location
  org_name      = var.org_name
  environment   = var.environment
  workload_name = var.workload_name
}

module "storage_account" {
  source  = "azurenoops/overlays-storage-account/azurerm"
  version = "~> 0.1.0"

  //Global Settings
  resource_group_name = module.rg.resource_group_name
  location            = var.location  
  org_name            = var.org_name
  environment         = var.environment
  workload_name       = var.workload_name

  //Storage Account Settings
  account_replication_type = var.account_replication_type

  // Locks
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  // Tags
  add_tags = merge(var.tags, {
    DeployedBy = format("AzureNoOpsTF [%s]", terraform.workspace)
  }) # Tags to be applied to all resources
}
