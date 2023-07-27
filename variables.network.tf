# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

############################
# Network Configuration   ##
############################

variable "network_rules" {
  description = "Network rules restricing access to the storage account."
  type        = object({ default_firewall_action = string, bypass = list(string), ip_rules = list(string), subnet_ids = list(string) })
  default     = null
}