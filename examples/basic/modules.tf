

module "storage_account" {
  source = "../.."
  //version = "~> 1.0.0"

  //Global Settings
  # Resource Group, location, VNet and Subnet details
  create_storage_resource_group = true
  location                      = var.location
  deploy_environment            = var.deploy_environment
  org_name                      = var.org_name
  environment                   = var.environment
  workload_name                 = var.workload_name

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
