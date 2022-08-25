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

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.rgname}-${lower(terraform.workspace)}"
  location = "${var.rglocation}"
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
  log_analytics_workspace_id  = "${var.law_id}"

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
  
  network {
    app_subnet_id                               = "${var.app_subnet_id}"
    service_runtime_subnet_id                   = "${var.service_runtime_subnet_id}"
    cidr_ranges                                 = "${var.sc_cidr}"
    app_network_resource_group                  = "${var.sc_service_name}-apps-rg"
    service_runtime_network_resource_group      = "${var.sc_service_name}-runtime-rg"
  }
  
  timeouts {
      create = "60m"
      delete = "2h"
  }

  trace {
    connection_string   = azurerm_application_insights.sc_app_insights.connection_string
  }
  
}







