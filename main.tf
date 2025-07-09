# Generate a random suffix for unique naming
resource "random_id" "suffix" {
  byte_length = 4
}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  
  tags = var.tags
}

# Create Application Insights
resource "azurerm_application_insights" "main" {
  name                = var.app_insights_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
  
  tags = var.tags
}

# Create App Service Plan
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
  
  tags = var.tags
}

# Create App Service
resource "azurerm_linux_web_app" "main" {
  name                = "${var.app_service_name}-${random_id.suffix.hex}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id
  
  site_config {
    always_on = false
    
    application_stack {
      node_version = "18-lts"
    }
  }
  
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.main.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.main.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "XDT_MicrosoftApplicationInsights_Mode" = "Recommended"
  }
  
  tags = var.tags
}

# Create a deployment slot (optional)
resource "azurerm_linux_web_app_slot" "staging" {
  count          = var.create_staging_slot ? 1 : 0
  name           = "staging"
  app_service_id = azurerm_linux_web_app.main.id
  
  site_config {
    always_on = false
    
    application_stack {
      node_version = "18-lts"
    }
  }
  
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.main.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.main.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "XDT_MicrosoftApplicationInsights_Mode" = "Recommended"
  }
  
  tags = var.tags
}