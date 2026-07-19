# Trust policy for the EBS CSI controller service account in kube-system.
# This scopes role assumption to ebs-csi-controller-sa via cluster OIDC.
data "aws_iam_policy_document" "ebs_csi_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
  }
}

# Dedicated IAM role used only by the EBS CSI controller add-on.
resource "aws_iam_role" "ebs_csi_driver" {
  name               = "${var.cluster_name}-ebs-csi-driver-role"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-ebs-csi-driver-role"
  })
}

# AWS-managed minimum policy for EBS CSI controller operations.
resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  role       = aws_iam_role.ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2"
}

# Trust policy for the aws-node service account used by the VPC CNI add-on.
# This scopes VPC networking permissions to kube-system/aws-node via IRSA.
data "aws_iam_policy_document" "vpc_cni_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }
  }
}

# Dedicated IAM role for the Amazon VPC CNI add-on.
resource "aws_iam_role" "vpc_cni" {
  name               = "${var.cluster_name}-vpc-cni-role"
  assume_role_policy = data.aws_iam_policy_document.vpc_cni_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-vpc-cni-role"
  })
}

# AWS-managed policy required by the VPC CNI add-on.
resource "aws_iam_role_policy_attachment" "vpc_cni" {
  role       = aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}