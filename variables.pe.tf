# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##########################################
# Blob Private Endpoint Configuration   ##
##########################################

variable "enable_blob_private_endpoint" {
  description = "Manages a Private Endpoint to Azure Storage Account for Blob"
  default     = false
}

variable "existing_private_dns_zone" {
  description = "Name of the existing private DNS zone"
  default     = null
}

variable "private_subnet_address_prefix" {
  description = "The name of the subnet for private endpoints"
  default     = null
}

variable "virtual_network_name" {
  description = "Name of the virtual network for the private endpoint"
  default     = null
}

variable "existing_vnet_id" {
  description = "ID of the existing virtual network for the private endpoint"
  default     = null
}

variable "existing_subnet_id" {
  description = "The resource id of existing subnet"
  default     = null
}

##########################################
# Table Private Endpoint Configuration  ##
##########################################

variable "enable_table_private_endpoint" {
  description = "Manages a Private Endpoint to Azure Storage Account for Tables"
  default     = false
}