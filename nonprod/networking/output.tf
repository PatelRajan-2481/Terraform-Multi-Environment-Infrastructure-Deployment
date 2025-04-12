output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnets" {
  value = module.networking.public_subnets
}

output "private_subnets" {
  value = module.networking.private_subnets
}

output "bastion_public_ip" {
  value = module.networking.bastion_public_ip
}

output "bastion_sg_id" {
  value = module.networking.bastion_sg_id
}

output "db_sg_id" {
  description = "Database Security Group ID"
  value       = length(module.networking.db_sg_id) > 0 ? module.networking.db_sg_id : null
}

output "app_sg_id" {
  description = "Application Security Group ID"
  value       = length(module.networking.app_sg_id) > 0 ? module.networking.app_sg_id : null
}

output "web_sg_id" {
  value = module.networking.web_sg_id
}
