terraform {
  backend "s3" {
    bucket  = "k8s-llm-serving-tfstate-euw1"
    key     = "envs/dev/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}
