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

variable "existing_private_subnet_name" {
  description = "Name of the existing private subnet for the private endpoint"
  default     = null
}

variable "virtual_network_name" {
  description = "The name of the virtual network for private endpoints"
  default     = null
}

##########################################
# Table Private Endpoint Configuration  ##
##########################################

variable "enable_table_private_endpoint" {
  description = "Manages a Private Endpoint to Azure Storage Account for Tables"
  default     = false
}