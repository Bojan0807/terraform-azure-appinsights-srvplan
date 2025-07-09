# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    # Configure provider features
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
    
    app_service {
      # Enable App Service logs retention
      # This helps with debugging and monitoring
    }
    
    application_insights {
      disable_generated_rule = false
    }
  }
  
  # Optional: Configure specific Azure subscription
  # subscription_id = var.subscription_id
  # tenant_id       = var.tenant_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  
  # Optional: Configure default tags for all resources
  # default_tags {
  #   tags = {
  #     Environment = var.environment
  #     Project     = var.project_name
  #     ManagedBy   = "terraform"
  #   }
  # }
}

# Optional: Configure Azure AD Provider for advanced scenarios
# provider "azuread" {
#   tenant_id = var.tenant_id
# }

# Optional: Configure Random Provider for generating unique names
provider "random" {
  # No configuration needed
}

# Optional: Configure Time Provider for time-based resources
provider "time" {
  # No configuration needed
}