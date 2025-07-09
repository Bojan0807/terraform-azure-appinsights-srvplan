variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-webapp-demo"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "app_service_name" {
  description = "Name of the App Service"
  type        = string
  default     = "webapp-demo-app"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "asp-webapp-demo"
}

variable "app_service_plan_sku" {
  description = "SKU for the App Service Plan"
  type        = string
  default     = "B1"
  
  validation {
    condition = contains([
      "B1", "B2", "B3",
      "S1", "S2", "S3",
      "P1v2", "P2v2", "P3v2",
      "P1v3", "P2v3", "P3v3"
    ], var.app_service_plan_sku)
    error_message = "The app_service_plan_sku must be a valid Azure App Service Plan SKU."
  }
}

variable "app_insights_name" {
  description = "Name of the Application Insights resource"
  type        = string
  default     = "ai-webapp-demo"
}

variable "create_staging_slot" {
  description = "Whether to create a staging deployment slot"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "demo"
    Project     = "terraform-webapp"
    ManagedBy   = "terraform"
  }
}