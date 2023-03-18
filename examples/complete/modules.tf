

module "hub_spoke_landing_zone" {
  source  = "azurenoops/overlays-hubspoke/azurerm"
  version = "~> 1.0.1"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  location           = "usgovvirginia"
  org_name           = "azurenoops"
  environment        = "usgovernment"
  deploy_environment = "dev"

  #############################
  ## Logging Configuration  ###
  #############################

  # (Optional) Enable Azure Sentinel
  enable_sentinel = true

  # (Required) To enable Azure Monitoring
  # Sku Name - Possible values are PerGB2018 and Free
  # Log Retention in days - Possible values range between 30 and 730
  log_analytics_workspace_sku          = "PerGB2018"
  log_analytics_logs_retention_in_days = 30

  ####################################
  # Network Artifacts Configuration ##
  ####################################

  # (Optional) Enable Network Artifacts for Operations
  # This will create Storage Account, and Key Vault for Network Operations
  # to store NetOps artifacts outside the Shared Services Tier 
  # Network Artifacts created in Operations Tier. 
  # enable_network_artifacts = true

  #########################
  ## Hub Configuration  ###
  #########################

  # (Required) Hub Subscription
  hub_subscription_id = "964c406a-1019-48d1-a927-9461123de233"

  # (Required)  Hub Virtual Network Parameters   
  hub_vnet_address_space = ["10.0.100.0/24"]

  # (Optional) Create DDOS Plan. Default is false
  create_ddos_plan = false

  # (Optional) Hub Network Watcher
  create_network_watcher = false

  # (Required) Hub Subnets 
  # Default Subnets, Service Endpoints
  # This is the default subnet with required configuration, check README.md for more details
  # First address ranges from VNet Address space reserved for Firewall Subnets. 
  # ex.: For 10.0.100.128/27 address space, usable address range start from 10.0.100.0/24 for all subnets.
  # default subnet name will be set as per Azure NoOps naming convention by defaut.
  hub_subnet_address_prefix = ["10.0.100.128/27"]
  hub_subnet_service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
  hub_private_endpoint_network_policies_enabled  = false
  hub_private_endpoint_service_endpoints_enabled = true

  # (Optional) Hub Network Security Group
  # This is default values, do not need this if keeping default values
  # NSG rules are not created by default for Azure NoOps Hub Subnet

  # To deactivate default deny all rule
  hub_deny_all_inbound = false

  ##############################
  ## Firewall Configuration  ###
  ##############################

  # Firewall Settings
  # By default, Azure NoOps will create Azure Firewall in Hub VNet. 
  # If you do not want to create Azure Firewall, 
  # set enable_firewall to false. This will allow different firewall products to be used (Example: F5).  
  enable_firewall = true

  # By default, forced tunneling is enabled for Azure Firewall.
  # If you do not want to enable forced tunneling, 
  # set enable_forced_tunneling to false.
  enable_forced_tunneling = true

  // Firewall Subnets
  fw_client_snet_address_prefix        = ["10.0.100.0/26"]
  fw_management_snet_address_prefix    = ["10.0.100.64/26"]
  fw_client_snet_service_endpoints     = []
  fw_management_snet_service_endpoints = []
  fw_supernet_IP_address               = "10.96.0.0/19"

  # Firewall Config
  # This is default values, do not need this if keeping default values
  fw_sku                      = "AZFW_VNet"
  fw_tier                     = "Premium"
  fw_intrusion_detection_mode = "Alert"

  # # (Optional) specify the Network rules for Azure Firewall l
  # This is default values, do not need this if keeping default values
  fw_policy_network_rule_collection = [
    {
      name     = "AllowAzureCloud"
      priority = "100"
      action   = "Allow"
      rules = [
        {
          name                  = "AzureCloud"
          protocols             = ["Any"]
          source_addresses      = ["*"]
          destination_addresses = ["AzureCloud"]
          destination_ports     = ["*"]
        }
      ]
    },
    {
      name     = "AllowTrafficBetweenSpokes"
      priority = "200"
      action   = "Allow"
      rules = [
        {
          name                  = "AllSpokeTraffic"
          protocols             = ["Any"]
          source_addresses      = ["10.96.0.0/19"]
          destination_addresses = ["*"]
          destination_ports     = ["*"]
        }
      ]
    }
  ]

  # (Optional) specify the application rules for Azure Firewall
  # This is default values, do not need this if keeping default values
  fw_policy_application_rule_collection = [
    {
      name     = "AzureAuth"
      priority = "110"
      action   = "Allow"
      rules = [
        {
          name              = "msftauth"
          source_addresses  = ["*"]
          destination_fqdns = ["aadcdn.msftauth.net", "aadcdn.msauth.net"]
          protocols = {
            type = "Https"
            port = 443
          }
        }
      ]
    }
  ]

  ################################
  ## Defender Configuration    ###
  ################################

  # Enable Security Center API Setting
  enable_security_center_setting = false
  security_center_setting_name   = "MCAS"

  # Enable auto provision of log analytics agents on VM's if they doesn't exist. 
  enable_security_center_auto_provisioning = "Off"

  # Subscription Security Center contacts
  # One or more email addresses seperated by commas not supported by Azure proivider currently
  security_center_contacts = {
    email               = "johe.doe@microsoft.com" # must be a valid email address
    phone               = "5555555555"             # Optional
    alert_notifications = true
    alerts_to_admins    = true
  }


  ##################################################
  ## Operations Spoke Configuration   (Default)  ###
  ##################################################

  // Operations Subscription
  ops_subscription_id = "964c406a-1019-48d1-a927-9461123de233"

  # Name for the ops spoke. It defaults to ops-core.
  ops_spoke_name = "ops-core"

  # Indicates if the spoke is deployed to the same subscription as the hub. Default is true.
  is_ops_deployed_to_same_hub_subscription = true

  # Provide valid VNet Address space for spoke virtual network.  
  ops_virtual_network_address_space = ["10.0.110.0/26"]

  # Provide valid subnet address prefix for spoke virtual network. Subnet naming is based on default naming standard
  ops_subnet_address_prefix = ["10.0.110.0/27"]
  ops_subnet_service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
  ops_subnet_private_endpoint_network_policies_enabled     = false
  ops_subnet_private_link_service_network_policies_enabled = true

  # (Optional) Operations Network Security Group
  # This is default values, do not need this if keeping default values
  # NSG rules are not created by default for Azure NoOps Hub Subnet

  # To deactivate default deny all rule
  ops_deny_all_inbound = false

  # Network Security Group Rules to apply to the Operatioms Virtual Network
  ops_nsg_additional_rules = [
    {
      name                       = "Allow-Traffic-From-Spokes"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["22", "80", "443", "3389"]
      source_address_prefixes    = ["10.0.125.0/26"]
      destination_address_prefix = "10.0.110.0/26"
    },
  ]


  ################################################
  ## Identity Spoke Configuration (Optional)   ###
  ################################################

  # By default, this module will create a identity spoke, 
  # and set the argument to `enable_identity_spoke = false`, to disable the spoke.
  enable_identity_spoke = false
  id_subscription_id = "964c406a-1019-48d1-a927-9461123de233"

  ########################################################
  ## Shared Services Spoke Configuration  (Optional)   ###
  ########################################################

  # By default, this module will create a shared services spoke, 
  # and set the argument to `enable_shared_services_spoke  = false`, to disable the spoke.
  enable_shared_services_spoke = false
  svcs_subscription_id = "964c406a-1019-48d1-a927-9461123de233"

  #############################
  ## Bastion Configuration  ###
  #############################

  # By default, this module will create a bastion host, 
  # and set the argument to `enable_bastion_host = false`, to disable the bastion host.
  enable_bastion_host = false

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  //add_tags = {} # Tags to be applied to all resources
}

##########################################
### Workload Network Configuration     ###
##########################################

module "mod_wl_network" {
  depends_on = [
    module.hub_spoke_landing_zone
  ]
  source  = "azurenoops/overlays-hubspoke/azurerm//modules/virtual-network-spoke"
  version = "~> 1.0.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  location           = "usgovvirginia"
  org_name           = "azurenoops"
  environment        = "usgovernment"
  deploy_environment = "dev"
  workload_name      = "wl-core"

  #################################################
  ## Workload Spoke Configuration  (Optional)   ###
  #################################################

  # Indicates if the spoke is deployed to the same subscription as the hub. Default is true.
  is_spoke_deployed_to_same_hub_subscription = true

  # Provide valid VNet Address space for spoke virtual network.  
  virtual_network_address_space = ["10.0.125.0/26"]

  # Provide valid subnet address prefix for spoke virtual network. Subnet naming is based on default naming standard
  spoke_subnet_address_prefix = ["10.0.125.0/27"]
  spoke_subnet_service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
  spoke_private_endpoint_network_policies_enabled     = false
  spoke_private_link_service_network_policies_enabled = true

  # Hub Virtual Network ID
  hub_virtual_network_id = module.hub_spoke_landing_zone.hub_virtual_network_id

  # Firewall Private IP Address 
  hub_firewall_private_ip_address = module.hub_spoke_landing_zone.firewall_private_ip

  # (Optional) Workload Network Security Group
  # This is default values, do not need this if keeping default values
  # NSG rules are not created by default for Azure NoOps Hub Subnet

  # To deactivate default deny all rule
  deny_all_inbound = false

  # Network Security Group Rules to apply to the Workload Virtual Network
  nsg_additional_rules = [
    {
      name                       = "Allow-Traffic-From-Spokes"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["22", "80", "443", "3389"]
      source_address_prefixes    = ["10.0.110.0/26"]
      destination_address_prefix = "10.0.125.0/26"
    },
  ]

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {} # Tags to be applied to all resources
}


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
