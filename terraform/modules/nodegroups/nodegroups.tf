# CPU node group for core services and non-GPU workloads.
resource "aws_eks_node_group" "cpu" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.name_prefix}-cpu-${var.environment}"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.cpu_desired_size
    min_size     = var.cpu_min_size
    max_size     = var.cpu_max_size
  }

  instance_types = var.cpu_instance_types
  capacity_type  = "ON_DEMAND"

  labels = {
    workload = "general"
  }

  tags = merge(var.tags, {
    Name     = "${var.name_prefix}-cpu-${var.environment}"
    Workload = "general"
  })

  depends_on = [
    aws_iam_role_policy_attachment.worker_nodes,
    aws_iam_role_policy_attachment.ecr_read_only
  ]
}

# GPU node group dedicated to inference workloads.
resource "aws_eks_node_group" "gpu" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.name_prefix}-gpu-${var.environment}"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.gpu_desired_size
    min_size     = var.gpu_min_size
    max_size     = var.gpu_max_size
  }

  instance_types = var.gpu_instance_types
  capacity_type  = "ON_DEMAND"

  labels = {
    gpu      = "true"
    workload = "inference"
  }

  taint {
    key    = "nvidia.com/gpu"
    value  = "true"
    effect = "NO_SCHEDULE"
  }

  tags = merge(var.tags, {
    Name     = "${var.name_prefix}-gpu-${var.environment}"
    Workload = "inference"
  })

  depends_on = [
    aws_iam_role_policy_attachment.worker_nodes,
    aws_iam_role_policy_attachment.ecr_read_only
  ]
}