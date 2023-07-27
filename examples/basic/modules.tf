

module "storage_account" {
  source = "../.."
  //version = "~> 1.0.0"

  //Global Settings
  # Resource Group, location, VNet and Subnet details
  existing_resource_group_name = azurerm_resource_group.storage-rg.name
  location                     = var.location
  deploy_environment           = var.deploy_environment
  org_name                     = var.org_name
  workload_name                = var.workload_name

  # To enable advanced threat protection set argument to `true`
  enable_advanced_threat_protection = true

  # Configure managed identities to access Azure Storage (Optional)
  # Possible types are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`.
  identity_type = "SystemAssigned"
  //identity_ids  = [for k in azurerm_user_assigned_identity.example : k.id]

  # Enable private endpoint for storage account (Optional)
  enable_blob_private_endpoint  = true
  enable_table_private_endpoint = false
  existing_subnet_id            = azurerm_subnet.storage-snet.id

  # Locks
  enable_resource_locks = false

  # Tags
  # Adding TAG's to your Azure resources (Required)
  # Org Name and Env are already declared above, to use them here, create a varible. 
  add_tags = merge({}, {
    Example  = "basic"
    Organizaion = "AzureNoOps"
    Environment = "dev"
    Workload    = "storage"
  }) # Tags to be applied to all resources
}
