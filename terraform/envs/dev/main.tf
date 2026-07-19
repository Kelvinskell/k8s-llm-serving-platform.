# Create networking module
module "networking" {
  source = "../../modules/networking"

  name_prefix          = var.name_prefix
  cluster_name         = var.cluster_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  az_count             = var.az_count
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  nat_gateway_mode     = var.nat_gateway_mode
  tags                 = var.tags
}

# Create EKS control plane
module "eks" {
  source = "../../modules/eks"

  name_prefix          = var.name_prefix
  cluster_name         = var.cluster_name
  environment          = var.environment
  kubernetes_version   = var.kubernetes_version
  vpc_id               = module.networking.vpc_id
  vpc_cidr             = var.vpc_cidr
  private_subnet_ids   = module.networking.private_subnet_ids
  endpoint_access_mode = var.endpoint_access_mode
  tags                 = var.tags
}

# Deploy EKS add-ons 
module "eks_addons" {
  source = "../../modules/eks-addons"

  cluster_name              = module.eks.cluster_name
  cluster_version           = var.kubernetes_version
  cluster_oidc_issuer_url   = module.eks.cluster_oidc_issuer_url
  cluster_oidc_provider_arn = module.eks.cluster_oidc_provider_arn
  tags                      = var.tags

  depends_on = [module.eks]
}

# Create CPU and GPU worker node groups
module "nodegroups" {
  source = "../../modules/nodegroups"

  name_prefix        = var.name_prefix
  environment        = var.environment
  cluster_name       = module.eks.cluster_name
  subnet_ids         = module.networking.private_subnet_ids
  cpu_instance_types = var.cpu_instance_types
  gpu_instance_types = var.gpu_instance_types
  tags               = var.tags

  depends_on = [module.eks_addons]
}