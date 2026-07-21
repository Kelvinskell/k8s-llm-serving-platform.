variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version for add-on compatibility."
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL used for IRSA trust policies."
  type        = string
}

variable "cluster_oidc_provider_arn" {
  description = "IAM OIDC provider ARN used for IRSA trust policies."
  type        = string
}

variable "tags" {
  description = "Tags applied to add-on resources."
  type        = map(string)
  default     = {}
}
