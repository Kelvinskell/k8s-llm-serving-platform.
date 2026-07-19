provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.terraform_execution_role_name}"
  }

  default_tags {
    tags = var.tags
  }
}
