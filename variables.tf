
variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "canadacentral"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "northstar"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}


variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Linux administrator username"
  type        = string
  default     = "azureadmin"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
}

variable "alert_email" {
  description = "Email address for Azure Monitor alert notifications"
  type        = string
}