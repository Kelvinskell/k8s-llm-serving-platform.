# EKS control plane (managed Kubernetes)
resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.kubernetes_version

  enabled_cluster_log_types = var.cluster_log_types

  # Control plane networking: private subnets, security group, endpoint access
  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
    endpoint_private_access = local.endpoint_private_access
    endpoint_public_access  = local.endpoint_public_access
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-eks-${var.environment}"
  })
}
