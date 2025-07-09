# Terraform Azure App Service with Application Insights

This Terraform project provisions a complete Azure App Service infrastructure with Application Insights integration for monitoring and telemetry.

## What it Deploys

- **Azure Resource Group** - Container for all resources
- **Azure Application Insights** - Application monitoring and telemetry
- **Azure App Service Plan** - Hosting plan for the web application
- **Azure App Service** - Linux-based web app with Node.js runtime
- **Deployment Slot** (optional) - Staging environment for blue-green deployments

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Resource Group                           │
│                                                             │
│  ┌─────────────────────┐    ┌─────────────────────────────┐ │
│  │ Application Insights │    │      App Service Plan       │ │
│  │   (Monitoring)      │    │        (B1 SKU)            │ │
│  └─────────────────────┘    └─────────────────────────────┘ │
│             │                              │                │
│             │                              │                │
│             └──────────────┬───────────────┘                │
│                           │                                │
│                  ┌─────────────────────┐                    │
│                  │    App Service      │                    │
│                  │   (Linux/Node.js)   │                    │
│                  │                     │                    │
│                  │  ┌───────────────┐  │                    │
│                  │  │ Staging Slot  │  │                    │
│                  │  │  (Optional)   │  │                    │
│                  │  └───────────────┘  │                    │
│                  └─────────────────────┘                    │
└─────────────────────────────────────────────────────────────┘
```

## Files Structure

```
.
├── main.tf                     # Main infrastructure definitions
├── variables.tf                # Input variables
├── outputs.tf                  # Output values
├── versions.tf                 # Terraform and provider versions
├── providers.tf                # Provider configurations
├── backend.tf                  # Backend configuration options
├── backend.hcl.example         # Backend configuration template
├── setup-backend.sh            # Automated backend setup script
├── terraform.tfvars.example    # Example variable values
└── README.md                   # This file
```

## Prerequisites

Before using this Terraform configuration, ensure you have:

1. **Terraform** installed (version >= 1.3)
   ```bash
   terraform --version
   ```

2. **Azure CLI** installed and authenticated
   ```bash
   az --version
   az login
   ```

3. **Azure subscription** with appropriate permissions to create:
   - Resource Groups
   - App Services
   - Application Insights
   - App Service Plans
   - Storage Accounts (for remote state)

4. **Bash shell** (for backend setup script) - Windows users can use Git Bash or WSL

## Quick Start

### Option 1: With Remote State (Recommended for Production)

1. **Set up Azure backend** (one-time setup):
   ```bash
   chmod +x setup-backend.sh
   ./setup-backend.sh
   ```
   This creates the necessary Azure Storage resources for state management.

2. **Initialize Terraform with remote backend**:
   ```bash
   terraform init -backend-config=backend.hcl
   ```

3. **Review the plan**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```

### Option 2: With Local State (Development Only)

1. **Comment out the backend configuration** in `backend.tf` (use local backend)

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Review the plan**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```

### Accessing Your Application

After deployment:
- The output will show the App Service URL (with unique suffix)
- Application Insights will be automatically configured
- If staging slot is enabled, it will also show the staging URL

## Configuration Options

### Backend Configuration

This project supports multiple backend options:

1. **Azure Storage Backend** (Recommended for production):
   - Secure remote state storage
   - State locking to prevent conflicts
   - Automatic versioning and soft delete
   - Use `setup-backend.sh` for automated setup

2. **Local Backend** (Development only):
   - State stored locally as `terraform.tfstate`
   - No additional setup required
   - Not suitable for team collaboration

3. **Terraform Cloud Backend**:
   - Hosted state management
   - Built-in CI/CD integration
   - Team collaboration features

### Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `resource_group_name` | Name of the resource group | `rg-webapp-demo` | No |
| `location` | Azure region | `East US` | No |
| `app_service_name` | Name of the App Service | `webapp-demo-app` | No |
| `app_service_plan_name` | Name of the App Service Plan | `asp-webapp-demo` | No |
| `app_service_plan_sku` | SKU for App Service Plan | `B1` | No |
| `app_insights_name` | Name of Application Insights | `ai-webapp-demo` | No |
| `create_staging_slot` | Create staging deployment slot | `false` | No |
| `tags` | Resource tags | See variables.tf | No |

### Customization

1. **Copy the example variables file**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit terraform.tfvars** with your desired values:
   ```hcl
   resource_group_name = "rg-myapp-prod"
   location = "West Europe"
   app_service_name = "myapp-webapp"  # Will get unique suffix automatically
   create_staging_slot = true
   ```

3. **For backend configuration** (if using Azure Storage):
   ```bash
   cp backend.hcl.example backend.hcl
   # Edit backend.hcl with your storage account details
   ```

### App Service Plan SKUs

The following SKUs are supported:

- **Basic**: B1, B2, B3
- **Standard**: S1, S2, S3  
- **Premium v2**: P1v2, P2v2, P3v2
- **Premium v3**: P1v3, P2v3, P3v3

## Application Insights Integration

The App Service is automatically configured with Application Insights through environment variables:

- `APPINSIGHTS_INSTRUMENTATIONKEY` - Legacy instrumentation key
- `APPLICATIONINSIGHTS_CONNECTION_STRING` - Modern connection string (recommended)
- `ApplicationInsightsAgent_EXTENSION_VERSION` - Agent version
- `XDT_MicrosoftApplicationInsights_Mode` - Monitoring mode

## Deployment Slots

When `create_staging_slot = true`, a staging slot is created with:
- Same configuration as production
- Separate Application Insights telemetry
- URL: `https://your-app-name.azurewebsites.net/slots/staging`

## Usage Examples

### Backend Setup (First Time)
```bash
# Set up Azure Storage backend
./setup-backend.sh

# Initialize with remote backend
terraform init -backend-config=backend.hcl
```

### Standard Deployment
```bash
# With remote backend
terraform init -backend-config=backend.hcl
terraform plan
terraform apply

# With local backend (development)
terraform init
terraform plan
terraform apply
```

### With Custom Configuration
```bash
terraform apply -var="app_service_name=myapp" -var="location=West Europe"
```

### Environment-Specific Deployments
```bash
# Production
terraform workspace new production
terraform init -backend-config=backend-prod.hcl
terraform apply -var-file="production.tfvars"

# Staging
terraform workspace new staging
terraform init -backend-config=backend-staging.hcl
terraform apply -var-file="staging.tfvars"
```

### Destroy Resources
```bash
terraform destroy
```

## Outputs

After deployment, Terraform provides:

- `app_service_url` - Main application URL
- `application_insights_name` - Monitoring resource name
- `staging_slot_url` - Staging environment URL (if enabled)
- Connection strings and keys (marked as sensitive)

## Monitoring and Telemetry

Application Insights automatically collects:

- **Request telemetry** - HTTP requests, response times, success rates
- **Dependency telemetry** - Database calls, HTTP calls to external services
- **Exception telemetry** - Unhandled exceptions and errors
- **Performance counters** - CPU, memory, disk usage
- **Custom telemetry** - Custom events and metrics (via SDK)

Access monitoring data through:
- Azure Portal → Application Insights
- Application Insights Analytics
- Azure Monitor dashboards

## Security Considerations

- **Remote State**: Application Insights keys are marked as sensitive outputs
- **Backend Security**: Use Azure AD authentication for backend access
- **Unique Naming**: App Service names include random suffix to prevent conflicts
- **HTTPS Only**: App Service configured for HTTPS-only traffic
- **Storage Security**: Backend storage account uses encryption and soft delete
- **Access Control**: Consider using Azure Key Vault for sensitive configuration
- **Authentication**: Review App Service authentication settings for production use

## Best Practices

### State Management
- Always use remote backend for production
- Enable state locking to prevent concurrent modifications
- Use separate state files for different environments
- Backup state files regularly
- Never commit backend configuration files to version control

### Security
- Use Azure AD authentication instead of access keys
- Enable soft delete on storage accounts
- Use managed identities where possible
- Implement proper RBAC controls
- Regular security audits of deployed resources

### Development Workflow
- Use workspaces for environment separation
- Implement proper CI/CD pipelines
- Use consistent naming conventions
- Tag all resources appropriately
- Document infrastructure changes

## Troubleshooting

### Common Issues

1. **Backend initialization failures**:
   ```bash
   # Check if storage account exists
   az storage account show --name <storage-account> --resource-group <rg>
   
   # Verify permissions
   az role assignment list --assignee $(az account show --query user.name -o tsv)
   ```

2. **Resource name conflicts**:
   - App Service names are now automatically unique with random suffix
   - If conflicts persist, modify the `app_service_name` variable

3. **Insufficient permissions**:
   ```bash
   # Check current Azure context
   az account show
   
   # Verify required permissions
   az provider show --namespace Microsoft.Web
   ```

4. **State locking issues**:
   ```bash
   # Force unlock if needed (use with caution)
   terraform force-unlock <lock-id>
   ```

5. **Backend configuration errors**:
   ```bash
   # Re-initialize backend
   terraform init -reconfigure -backend-config=backend.hcl
   ```

### Useful Commands

```bash
# Check current Azure context
az account show

# List available locations
az account list-locations --output table

# View App Service logs
az webapp log tail --name <app-name> --resource-group <rg-name>

# Check backend state
terraform show

# List workspaces
terraform workspace list

# Backend storage account info
az storage account show --name <storage-account> --resource-group <rg>
```

### Debugging Steps

1. **Verify Azure CLI authentication**:
   ```bash
   az account show
   az account list
   ```

2. **Check Terraform configuration**:
   ```bash
   terraform validate
   terraform fmt -check
   ```

3. **Review state file**:
   ```bash
   terraform state list
   terraform state show <resource>
   ```

4. **Backend troubleshooting**:
   ```bash
   # Check backend configuration
   terraform init -backend=false
   terraform init -reconfigure
   ```

## Advanced Usage

### Multi-Environment Setup

Create separate backend configurations for different environments:

```bash
# Production backend
cat > backend-prod.hcl << EOF
resource_group_name  = "rg-terraform-state-prod"
storage_account_name = "tfstateprod12345"
container_name       = "tfstate"
key                  = "webapp/production/terraform.tfstate"
EOF

# Staging backend
cat > backend-staging.hcl << EOF
resource_group_name  = "rg-terraform-state-staging"
storage_account_name = "tfstatestaging12345"
container_name       = "tfstate"
key                  = "webapp/staging/terraform.tfstate"
EOF
```

### Custom Provider Configuration

For advanced scenarios, modify `providers.tf`:

```hcl
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  
  # Use managed identity in Azure DevOps
  use_msi = true
}
```

### Terraform Cloud Integration

To use Terraform Cloud backend:

1. Uncomment the remote backend in `backend.tf`
2. Configure your organization and workspace
3. Set up environment variables in Terraform Cloud

## Maintenance

### Regular Tasks

1. **Update providers**:
   ```bash
   terraform init -upgrade
   ```

2. **State cleanup**:
   ```bash
   terraform refresh
   terraform state pull
   ```

3. **Security updates**:
   ```bash
   # Check for security advisories
   terraform providers schema -json | jq '.provider_schemas'
   ```

### Backup Strategy

1. **State backups**: Azure Storage automatically versions state files
2. **Configuration backups**: Keep all `.tf` files in version control
3. **Regular exports**: Export resource configurations periodically

### Monitoring

1. **Application Insights**: Monitor application performance and errors
2. **Azure Monitor**: Track resource health and metrics
3. **Cost monitoring**: Use Azure Cost Management for spend tracking

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Check Azure documentation
- Review Terraform Azure provider docs
- Open an issue in this repository
