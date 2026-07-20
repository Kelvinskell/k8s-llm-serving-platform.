variable "enabled" {
  description = "Whether to install the NVIDIA device plugin."
  type        = bool
  default     = true
}

variable "namespace" {
  description = "Namespace for NVIDIA device plugin."
  type        = string
  default     = "kube-system"
}

variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "nvidia-device-plugin"
}

variable "repository" {
  description = "Helm repository URL."
  type        = string
  default     = "https://nvidia.github.io/k8s-device-plugin"
}

variable "chart" {
  description = "Helm chart name."
  type        = string
  default     = "nvidia-device-plugin"
}

variable "node_selector_gpu" {
  description = "GPU nodeSelector value for key gpu."
  type        = string
  default     = "true"
}

variable "taint_key" {
  description = "GPU taint key."
  type        = string
  default     = "nvidia.com/gpu"
}

variable "taint_operator" {
  description = "GPU taint operator."
  type        = string
  default     = "Equal"
}

variable "taint_value" {
  description = "GPU taint value."
  type        = string
  default     = "true"
}

variable "taint_effect" {
  description = "GPU taint effect."
  type        = string
  default     = "NoSchedule"
}

variable "gfd_enabled" {
  description = "Enable Node Feature Discovery integration."
  type        = bool
  default     = false
}

variable "time_slicing_enabled" {
  description = "Enable GPU time-slicing."
  type        = bool
}

variable "time_slicing_replicas" {
  description = "Number of slices per GPU."
  type        = number
}