terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.22"
    }
    azurenoopsutils = {
      source  = "azurenoops/azurenoopsutils"
      version = "1.0.4"
    }
  }
}

provider "azurerm" {
  subscription_id = "964c406a-1019-48d1-a927-9461123de233"
  environment     = "usgovernment"
  metadata_host   = "management.usgovcloudapi.net"
  features {}
}
