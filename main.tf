terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "=2.46.0"
    }
  }
}

# Configuração do provedor Azure
provider "azurerm" {
  features { }
}

# Grupo de recursos
resource "azurerm_resource_group" "tests_group" {
  name     = "tests_group"
  location = "Brazil South"
}


# Azure Container Registry
resource "azurerm_container_registry" "felippegaede" {
  name                     = "felippegaede"
  resource_group_name      = azurerm_resource_group.tests_group.name
  location                 = azurerm_resource_group.tests_group.location
  sku                      = "Basic" #
  admin_enabled             = true
}


# Azure Web App com container
resource "azurerm_app_service_plan" "test" {
  name                = "service-plan-test"
  location            = azurerm_resource_group.tests_group.location
  resource_group_name = azurerm_resource_group.tests_group.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "golang-api-teste-felipe-gaede" {
  name                = "golang-api-teste-felipe-gaede"
  location            = azurerm_resource_group.tests_group.location
  resource_group_name = azurerm_resource_group.tests_group.name
  app_service_plan_id = azurerm_app_service_plan.test.id

  site_config {
    linux_fx_version = "DOCKER|fabricioveronez/api-conversao:v1"
  }
}