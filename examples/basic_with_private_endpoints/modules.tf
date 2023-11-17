

module "storage_account" {
  source = "../.."
  //version = "~> 1.0.0"

  depends_on = [ azurerm_resource_group.storage-rg, azurerm_virtual_network.storage-vnet ]

  //Global Settings
  # Resource Group, location, VNet and Subnet details
  existing_resource_group_name = azurerm_resource_group.storage-rg.name
  location                     = var.location
  deploy_environment           = var.deploy_environment
  org_name                     = var.org_name
  environment                  = var.environment
  workload_name                = var.workload_name

  # To enable advanced threat protection set argument to `true`
  enable_advanced_threat_protection = true
  
  # Enable private endpoint for storage account (Optional)
  enable_blob_private_endpoint  = true
  virtual_network_name         = azurerm_virtual_network.storage-vnet.name
  existing_private_subnet_name = azurerm_subnet.storage-snet.name

  # Locks
  enable_resource_locks = false

  # Tags
  # Adding TAG's to your Azure resources (Required)
  # Org Name and Env are already declared above, to use them here, create a variable. 
  add_tags = merge({}, {
    Example     = "basic"
    Organization = "AzureNoOps"
    Environment = "dev"
    Workload    = "storage"
  }) # Tags to be applied to all resources
}
