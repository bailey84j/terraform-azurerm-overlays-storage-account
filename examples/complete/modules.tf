

module "storage_account" {
  source = "../.."
  //version = "~> 1.0.0"

  //Global Settings
  resource_group_name = module.mod_wl_network.resource_group_name
  location           = "usgovvirginia"
  org_name           = "azurenoops"
  environment        = "usgovernment"
  deploy_environment = "dev"
  workload_name       = "strg"

  # Storage account replication (Optional)
  account_replication_type = "LRS"

  # To enable advanced threat protection set argument to `true`
  enable_advanced_threat_protection = true

  storage_blob_data_protection = {
    change_feed_enabled                       = true
    versioning_enabled                        = true
    delete_retention_policy_in_days           = 42
    container_delete_retention_policy_in_days = 42
    container_point_in_time_restore           = true
  }

  # disabled by default
  storage_blob_cors_rule = {
    allowed_headers    = ["*"]
    allowed_methods    = ["GET", "HEAD"]
    allowed_origins    = ["https://example.com"]
    exposed_headers    = ["*"]
    max_age_in_seconds = 3600
  }

  # Container lists with access_type to create
  containers = [
    { name = "mystore250", container_access_type = "private" },
    { name = "blobstore251", container_access_type = "blob" },
    { name = "containter252", container_access_type = "container" }
  ]

  # SMB file share with quota (GB) to create
  file_shares = [
    { name = "smbfileshare1", quota_in_gb = 50 },
    { name = "smbfileshare2", quota_in_gb = 50 }
  ]

  file_share_authentication = {
    directory_type = "AADDS"
  }

  # Storage tables
  tables = [
    { name = "table1" },
    { name = "table2" },
    { name = "table3" }
  ]

  # Storage queues
  queues = [
    { name = "queue1" },
    { name = "queue2" }
  ]

  # Configure managed identities to access Azure Storage (Optional)
  # Possible types are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`.
  identity_type = "SystemAssigned"
  //identity_ids  = [for k in azurerm_user_assigned_identity.example : k.id]

  # Enable private endpoint for storage account (Optional)
  enable_blob_private_endpoint  = true
  enable_table_private_endpoint = true
  existing_subnet_id            = "subnet_id"

  # Lifecycle management for storage account.
  # Must specify the value to each argument and default is `0` 
  lifecycles = [
    {
      prefix_match               = ["mystore250/folder_path"]
      tier_to_cool_after_days    = 0
      tier_to_archive_after_days = 50
      delete_after_days          = 100
      snapshot_delete_after_days = 30
    },
    {
      prefix_match               = ["blobstore251/another_path"]
      tier_to_cool_after_days    = 0
      tier_to_archive_after_days = 30
      delete_after_days          = 75
      snapshot_delete_after_days = 30
    }
  ]

  # Locks
  enable_resource_locks = false

  # Tags
  # Adding TAG's to your Azure resources (Required)
  # Org Name and Env are already declared above, to use them here, create a varible. 
  add_tags = merge({}, {
    DeployedBy  = format("AzureNoOpsTF [%s]", terraform.workspace)
    Organizaion = "AzureNoOps"
    Environment = "dev"
    Workload    = "storage"
  }) # Tags to be applied to all resources
}
