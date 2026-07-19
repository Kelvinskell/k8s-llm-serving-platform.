output "vpc_id" {
  description = "VPC ID for the dev environment."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs for the dev environment."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs for the dev environment."
  value       = module.networking.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "NAT gateway IDs for the dev environment."
  value       = module.networking.nat_gateway_ids
}
