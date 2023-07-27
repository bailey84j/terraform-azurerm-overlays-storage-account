# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Storage Account Network Rules Creation
#----------------------------------------------------------
resource "azurerm_storage_account_network_rules" "network_rules" {
  for_each = toset(var.network_rules != null && !var.nfsv3_enabled ? ["enabled"] : [])

  storage_account_id = azurerm_storage_account.storage.id

  default_action             = var.network_rules.default_firewall_action
  bypass                     = var.network_rules.bypass
  ip_rules                   = var.network_rules.ip_rules
  virtual_network_subnet_ids = var.network_rules.default_firewall_action == "Deny" ? var.network_rules.subnet_ids : []
}