provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "functionstore_089889" {
  name                     = "functionstore089889"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "example" {
  name                = "example-app-service-plan"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  kind = "Linux"
  reserved = true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "example" {
  name                = "functestfuncapp142321"
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id
  location            = azurerm_resource_group.example.location

  storage_account_name       = azurerm_storage_account.functionstore_089889.name
  storage_account_access_key = azurerm_storage_account.functionstore_089889.primary_access_key
  version                    = "~4"
  # os_type                    = "linux"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "dotnet"
    TESTING_KEY              = "TESTING_VALUE"
  }

  site_config {
    dotnet_framework_version = "v6.0"
    ftps_state        = "FtpsOnly" #Todisableplainftp
    always_on         = true       #Enablethistoavoidthecoldstarttimeofcompute
    #health_check_path = "/"        #EnableFunctionApphealthcheck
    cors {
    allowed_origins = ["https://portal.azure.com"]
    }
  }
}