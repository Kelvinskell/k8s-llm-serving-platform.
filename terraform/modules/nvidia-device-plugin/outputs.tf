output "release_name" {
  description = "Helm release name for NVIDIA device plugin."
  value       = try(helm_release.nvidia_device_plugin[0].name, null)
}