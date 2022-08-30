terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
terraform {
  backend "azurerm" {
    resource_group_name  = "cloud-shell-storage-centralindia"
    storage_account_name = "csg10032002176a1b4f"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.rgname}"
  location = "${var.rglocation}"
}

resource "azurerm_virtual_network" "sc_vnet1" {
  name                = "sc_vnet"
  address_space       = ["192.168.0.0/16"]
  location            = "${var.rglocation}"
  resource_group_name = "${var.rgname}"
}

resource "azurerm_subnet" "sc_bastion_subnet" {
  name                 = "${var.azure_bastion_subnet}"
  resource_group_name  = "${var.rgname}"
  virtual_network_name = azurerm_virtual_network.sc_vnet1.name
  address_prefixes     = ["192.168.1.224/27"]
}

resource "azurerm_public_ip" "sc_pip" {
  name                = "${var.sc_pip}"
  location            = "${var.rglocation}"
  resource_group_name = "${var.rgname}"
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "${var.sc_bastion_host}"
  location            = "${var.rglocation}"
  resource_group_name = "${var.rgname}"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.sc_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.sc_pip.id
  }
}

resource "azurerm_application_insights" "sc_app_insights" {
  name                = "${var.app_insights_name}"
  location            = "${var.rglocation}"
  resource_group_name = "${var.rgname}"
  application_type    = "web"
}

resource "azurerm_monitor_diagnostic_setting" "diag" {
  name                        = "monitoring"
  target_resource_id          = azurerm_spring_cloud_service.sc.id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.sc_law.id

  log {
    category = "ApplicationConsole"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_log_analytics_workspace" "sc_law" {
  name                = "${var.law_name}"
  location            = "${var.rglocation}"
  resource_group_name = "${var.rgname}"
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_spring_cloud_service" "sc" {
  name                = "${var.sc_service_name}" 
  resource_group_name = "${var.rgname}"
  location            = "${var.rglocation}"
  
}

  

