# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Local configuration - Default (required). 
#------------------------------------------------------------
#---------------------------------
# Local declarations
#---------------------------------
resource "random_id" "uniqueString" {
  keepers = {
    # Generate a new id each time we change resourePrefix variable
    org_prefix = var.org_name
    subid      = var.workload_name
  }
  byte_length = 3
}

locals {
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules#ip_rules
  # > Small address ranges using "/31" or "/32" prefix sizes are not supported. These ranges should be configured using individual IP address rules without prefix specified.
  storage_ip_rules = toset(flatten([for cidr in var.allowed_cidrs : (length(regexall("/3.", cidr)) > 0 ? [cidrhost(cidr, 0), cidrhost(cidr, -1)] : [cidr])]))

  pitr_enabled = (
    alltrue([var.storage_blob_data_protection.change_feed_enabled, var.storage_blob_data_protection.versioning_enabled, var.storage_blob_data_protection.container_point_in_time_restore])
    && var.storage_blob_data_protection.delete_retention_policy_in_days > 0
    && var.storage_blob_data_protection.container_delete_retention_policy_in_days > 2
    && !var.nfsv3_enabled
  )
}

# Telemetry is collected by creating an empty ARM deployment with a specific name
# If you want to disable telemetry, you can set the disable_telemetry variable to true

# The following locals identify the module
locals {
  org_name          = var.org_name
  disable_telemetry = var.disable_telemetry

  # PUID identifies the module
  telem_workload_puid = "434fc92b-dbc0-4770-8642-f611851881bd5"
}

# The following `can()` is used for when disable_telemetry = true
locals {
  telem_random_hex = can(random_id.telem[0].hex) ? random_id.telem[0].hex : local.empty_string
}

# Here we create the ARM templates for the telemetry deployment
locals {
  telem_arm_subscription_template_content = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "variables": {},
  "resources": [],
  "outputs": {
    "telemetry": {
      "type": "String",
      "value": "For more information, see https://aka.ms/azurenoops/tf/telemetry"
    }
  }
}
TEMPLATE
}
