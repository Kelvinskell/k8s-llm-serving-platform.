# IAM role assumed by EC2 instances in the managed node groups.
resource "aws_iam_role" "eks_node_role" {
  name = "${var.name_prefix}-node-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-node-role-${var.environment}"
  })
}

# Allow nodes to join and operate in the EKS cluster.
resource "aws_iam_role_policy_attachment" "worker_nodes" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Allow nodes to pull container images from Amazon ECR.
resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}