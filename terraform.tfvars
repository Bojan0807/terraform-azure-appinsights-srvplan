# Example terraform.tfvars file
# Copy this file to terraform.tfvars and customize the values

resource_group_name     = "rg-myapp-prod"
location               = "East US"
app_service_name       = "myapp-webapp-prod"
app_service_plan_name  = "asp-myapp-prod"
app_service_plan_sku   = "B1"
app_insights_name      = "ai-myapp-prod"
create_staging_slot    = true

tags = {
  Environment = "production"
  Project     = "myapp"
  Owner       = "devops-team"
  ManagedBy   = "terraform"
}