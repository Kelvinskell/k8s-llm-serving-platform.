output "vpc_cni_version" {
  description = "VPC CNI add-on version."
  value       = aws_eks_addon.vpc_cni.addon_version
}

output "coredns_version" {
  description = "CoreDNS add-on version."
  value       = aws_eks_addon.coredns.addon_version
}

output "kube_proxy_version" {
  description = "kube-proxy add-on version."
  value       = aws_eks_addon.kube_proxy.addon_version
}

output "ebs_csi_driver_version" {
  description = "EBS CSI driver add-on version."
  value       = aws_eks_addon.ebs_csi_driver.addon_version
}
