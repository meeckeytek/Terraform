provider "azurerm" {
  features {}
}


locals {
  resource_group="app-grp"
  location="North Europe"
}


resource "azurerm_resource_group" "app_grp"{
  name=local.resource_group
  location=local.location
}

resource "azurerm_storage_account" "functionstore_089889" {
  name                     = "functionstore089889"
  resource_group_name      = azurerm_resource_group.app_grp.name
  location                 = azurerm_resource_group.app_grp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "function_app_plan" {
  name                = "function-app-plan"
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name
  kind = "Linux"
  reserved = true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "functionapp_1234000" {
  name                       = "testtestfunc1412"
  location                   = azurerm_resource_group.app_grp.location
  resource_group_name        = azurerm_resource_group.app_grp.name
  app_service_plan_id        = azurerm_app_service_plan.function_app_plan.id
  storage_account_name       = azurerm_storage_account.functionstore_089889.name
  storage_account_access_key = azurerm_storage_account.functionstore_089889.primary_access_key
  version                    = "~4"
  site_config {
    dotnet_framework_version = "v6.0"
    ftps_state        = "FtpsOnly" #Todisableplainftp
    always_on         = true       #Enablethistoavoidthecoldstarttimeofcompute
    health_check_path = "/"        #EnableFunctionApphealthcheck
    cors {
    allowed_origins = ["https://portal.azure.com"]
    }
  }
}