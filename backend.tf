# Terraform Backend Configuration
# This file configures where Terraform stores its state file

# Option 1: Azure Storage Backend (Recommended for production)
# Uncomment and configure the following block to use Azure Storage for state management
terraform {
  backend "azurerm" {
    # Storage account details - these should be provided via backend config file
    # or environment variables for security
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateXXXXX"  # Must be globally unique
    container_name       = "tfstate"
    key                  = "webapp/terraform.tfstate"
    
    # Optional: Enable encryption
    # use_azuread_auth = true
    # use_msi         = true
  }
}

# Option 2: Local Backend (Default - for development only)
# This is the default behavior if no backend is specified
# The state file will be stored locally as terraform.tfstate
# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }

# Option 3: Remote Backend using Terraform Cloud
# terraform {
#   backend "remote" {
#     hostname     = "app.terraform.io"
#     organization = "your-org-name"
#     
#     workspaces {
#       name = "azure-webapp-production"
#     }
#   }
# }

# Option 4: S3 Backend (if using AWS for state storage)
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "azure-webapp/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-state-lock"
#   }
# }

# Backend Configuration Notes:
# 1. For production, always use a remote backend
# 2. Enable state locking to prevent concurrent modifications
# 3. Use encryption for sensitive data
# 4. Consider using separate state files for different environments
# 5. Backup your state files regularly