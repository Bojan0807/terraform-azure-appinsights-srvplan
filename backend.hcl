# Example backend configuration file
# Copy this file to backend.hcl and customize for your environment
# Usage: terraform init -backend-config=backend.hcl

# Azure Storage Backend Configuration
resource_group_name  = "rg-terraform-state-prod"
storage_account_name = "tfstateprod12345"
container_name       = "tfstate"
key                  = "webapp/production/terraform.tfstate"

# Optional: Use Azure AD authentication
# use_azuread_auth = true
# use_msi         = true

# Optional: Specify subscription if different from default
# subscription_id = "00000000-0000-0000-0000-000000000000"

# Optional: Access key (not recommended - use Azure AD instead)
# access_key = "your-storage-account-access-key"