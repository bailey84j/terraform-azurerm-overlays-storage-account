data "azurenoopsutils_resource_name" "sa" {
  name          = var.workload_name
  resource_type = "azurerm_storage_account"
  prefixes      = [var.org_name, module.mod_azregions.location_short]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.environment, local.name_suffix, var.use_naming ? "" : "sa"])
  use_slug      = var.use_naming
  random_seed   = 8
  clean_input   = true
  separator     = "-"
}