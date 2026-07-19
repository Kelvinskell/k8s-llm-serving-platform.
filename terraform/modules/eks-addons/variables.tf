variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version for add-on compatibility."
  type        = string
}

variable "tags" {
  description = "Tags applied to add-on resources."
  type        = map(string)
  default     = {}
}
