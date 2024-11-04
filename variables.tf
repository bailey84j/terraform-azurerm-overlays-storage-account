# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
# Global Configuration   ##
###########################

variable "location" {
  description = "Azure region in which instance will be hosted"
  type        = string
}

variable "environment" {
  description = "The Terraform backend environment e.g. public or usgovernment"
  type        = string
}

variable "deploy_environment" {
  description = "Name of the workload's environnement"
  type        = string
}

variable "workload_name" {
  description = "Name of the workload_name"
  type        = string
}

variable "org_name" {
  description = "Name of the organization"
  type        = string
}

variable "disable_telemetry" {
  description = "If set to true, will disable the telemetry sent as part of the module."
  type        = string
  default     = false
}

#######################
# RG Configuration   ##
#######################

variable "create_storage_resource_group" {
  description = "Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is false."
  type        = bool
  default     = false
}

variable "use_location_short_name" {
  description = "Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored."
  type        = bool
  default     = true
}

variable "existing_resource_group_name" {
  description = "The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

#####################################
# Storage Account Configuration   ##
#####################################

variable "enable_advanced_threat_protection" {
  description = "Threat detection policy configuration, known in the API as Server Security Alerts Policy. Currently available only for the SQL API."
  default     = false
}

variable "sku_name" {
  description = "The SKUs supported by Microsoft Azure Storage. Valid options are Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, Standard_LRS, Standard_RAGRS, Standard_RAGZRS, Standard_ZRS"
  default     = "Standard_GRS"
  type        = string
}

variable "account_kind" {
  description = "Defines the Kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2`. Changing this forces a new resource to be created. Defaults to StorageV2."
  type        = string
  default     = "StorageV2"
}

variable "account_tier" {
  description = "Defines the Tier to use for this Storage Account. Valid options are `Standard` and `Premium`. For `BlockBlobStorage` and `FileStorage` accounts only `Premium` is valid. Changing this forces a new resource to be created."
  type        = string
  default     = "Standard"
}

variable "access_tier" {
  description = "Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`, defaults to `Hot`."
  type        = string
  default     = "Hot"
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this Storage Account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`."
  type        = string
  default     = "RAGRS"
}

variable "https_traffic_only_enabled" {
  description = "Boolean flag which forces HTTPS if enabled."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Whether the public network access is enabled? Defaults to true."
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the Storage Account. Possible values are `TLS1_0`, `TLS1_1`, and `TLS1_2`. "
  type        = string
  default     = "TLS1_2"
}

variable "public_nested_items_allowed" {
  description = "Allow or disallow nested items within this Account to opt into being public."
  type        = bool
  default     = false
}

variable "custom_domain_name" {
  description = "The Custom Domain Name to use for the Storage Account, which will be validated by Azure."
  type        = string
  default     = null
}

variable "use_subdomain" {
  description = "Should the Custom Domain Name be validated by using indirect CNAME validation?"
  type        = bool
  default     = false
}

variable "static_website_config" {
  description = "Static website configuration. Can only be set when the `account_kind` is set to `StorageV2` or `BlockBlobStorage`."
  type = object({
    index_document     = optional(string)
    error_404_document = optional(string)
  })
  default = null
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the Storage Account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD)."
  type        = bool
  default     = true
}

variable "nfsv3_enabled" {
  description = "Is NFSv3 protocol enabled? Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "sftp_enabled" {
  description = "Is SFTP enabled?"
  type        = bool
  default     = false
}

variable "hns_enabled" {
  description = "Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 and must be `true` if `nfsv3_enabled` or `sftp_enabled` is set to `true`. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

#############################################
# Storage Account Identity Configuration   ##
#############################################

variable "identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both)."
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account."
  type        = list(string)
  default     = null
}

####################################################
# Storage Account Data protection Configuration   ##
####################################################

variable "storage_blob_data_protection" {
  description = "Storage account blob Data protection parameters."
  type = object({
    change_feed_enabled                       = optional(bool, false)
    versioning_enabled                        = optional(bool, false)
    delete_retention_policy_in_days           = optional(number, 0)
    container_delete_retention_policy_in_days = optional(number, 0)
    container_point_in_time_restore           = optional(bool, false)
  })
  default = {}
}

variable "storage_blob_cors_rule" {
  description = "Storage Account blob CORS rule. Please refer to the [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#cors_rule) for more information."
  type = object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  })
  default = null
}

######################################################
# Storage Account Threat protection Configuration   ##
######################################################

variable "advanced_threat_protection_enabled" {
  description = "Boolean flag which controls if advanced threat protection is enabled, see [documentation](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information."
  type        = bool
  default     = false
}

############################################################
# Storage Account Data creation/bootstrap Configuration   ##
############################################################

variable "containers" {
  description = "List of objects to create some Blob containers in this Storage Account."
  type = list(object({
    name                  = string
    container_access_type = optional(string)
    metadata              = optional(map(string))
  }))
  default = []
}

variable "file_shares" {
  description = "List of objects to create some File Shares in this Storage Account."
  type = list(object({
    name             = string
    quota_in_gb      = number
    enabled_protocol = optional(string)
    metadata         = optional(map(string))
    acl = optional(list(object({
      id          = string
      permissions = string
      start       = optional(string)
      expiry      = optional(string)
    })))
  }))
  default = []
}

variable "tables" {
  description = "List of objects to create some Tables in this Storage Account."
  type = list(object({
    name = string
    acl = optional(list(object({
      id          = string
      permissions = string
      start       = optional(string)
      expiry      = optional(string)
    })))
  }))
  default = []
}

variable "queues" {
  description = "List of objects to create some Queues in this Storage Account."
  type = list(object({
    name     = string
    metadata = optional(map(string))
  }))
  default = []
}

variable "queue_properties_logging" {
  description = "Logging queue properties"
  type = object({
    delete                = optional(bool, true)
    read                  = optional(bool, true)
    write                 = optional(bool, true)
    version               = optional(string, "1.0")
    retention_policy_days = optional(number, 10)
  })
  default = {}
}

###############################################
# Storage Account Lifecycles Configuration   ##
###############################################

variable "lifecycles" {
  description = "Configure Azure Storage firewalls and virtual networks"
  type        = list(object({ prefix_match = set(string), tier_to_cool_after_days = number, tier_to_archive_after_days = number, delete_after_days = number, snapshot_delete_after_days = number }))
  default     = []
}
