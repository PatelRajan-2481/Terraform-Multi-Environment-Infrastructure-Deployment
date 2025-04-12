output "vpc_id" {
  value = module.networking.vpc_id
}

output "private_subnets" {
  value = module.networking.private_subnets
}

output "public_subnets" {
  value = module.networking.public_subnets
}

output "bastion_sg_id" {
  value = module.networking.bastion_sg_id
}

output "db_sg_id" {
  value = module.networking.db_sg_id
}

output "app_sg_id" {
  value = module.networking.app_sg_id
}

output "vm_sg_id" {
  value = module.networking.vm_sg_id
}
