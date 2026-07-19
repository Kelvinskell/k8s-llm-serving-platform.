# Core cluster identity and placement inputs
variable "name_prefix" {
  description = "Prefix used for naming node group resources."
  type        = string
}

variable "environment" {
  description = "Environment suffix used in resource names (for example: dev, stage)."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name where managed node groups are created."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs used by the managed node groups."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 1
    error_message = "subnet_ids must contain at least 1 subnet ID."
  }
}

# CPU node group sizing and instance selection
variable "cpu_desired_size" {
  description = "Desired number of nodes in the CPU node group."
  type        = number
  default     = 2
}

variable "cpu_min_size" {
  description = "Minimum number of nodes in the CPU node group."
  type        = number
  default     = 1
}

variable "cpu_max_size" {
  description = "Maximum number of nodes in the CPU node group."
  type        = number
  default     = 3
}

variable "cpu_instance_types" {
  description = "EC2 instance types used by the CPU node group."
  type        = list(string)
}

# GPU node group sizing and instance selection
variable "gpu_desired_size" {
  description = "Desired number of nodes in the GPU node group."
  type        = number
  default     = 1
}

variable "gpu_min_size" {
  description = "Minimum number of nodes in the GPU node group."
  type        = number
  default     = 0
}

variable "gpu_max_size" {
  description = "Maximum number of nodes in the GPU node group."
  type        = number
  default     = 2
}

variable "gpu_instance_types" {
  description = "EC2 instance types used by the GPU node group."
  type        = list(string)
}

# Shared metadata
variable "tags" {
  description = "Additional tags applied to all node group resources."
  type        = map(string)
  default     = {}
}