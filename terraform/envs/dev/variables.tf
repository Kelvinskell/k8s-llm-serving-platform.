variable "aws_region" {
  description = "AWS region for this environment."
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID where infrastructure is provisioned."
  type        = string
}

variable "terraform_execution_role_name" {
  description = "IAM role name assumed by Terraform."
  type        = string
  default     = "k8s-llm-serving-terraform-role"
}

variable "name_prefix" {
  description = "Prefix used to name infrastructure resources."
  type        = string
  default     = "k8s-llm-serving-dev"
}

variable "cluster_name" {
  description = "EKS cluster name used for Kubernetes discovery tags."
  type        = string
  default     = "k8s-llm-serving-dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR for this environment."
  type        = string
  default     = "10.20.0.0/16"
}

variable "az_count" {
  description = "Number of AZs to use."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2
    error_message = "az_count should be at least 2 for EKS environments."
  }
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs. Must match az_count."
  type        = list(string)
  default     = ["10.20.0.0/24", "10.20.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs. Must match az_count."
  type        = list(string)
  default     = ["10.20.10.0/24", "10.20.11.0/24"]
}

variable "nat_gateway_mode" {
  description = "NAT gateway mode for private subnet egress: single or ha."
  type        = string
  default     = "single"

  validation {
    condition     = contains(["single", "ha"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be either 'single' or 'ha'."
  }
}

variable "tags" {
  description = "Environment-wide default tags."
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "k8s-llm-serving-platform"
  }
}
