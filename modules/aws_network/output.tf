#Code before fixing support for both env
# output "vpc_id" {
#   value = aws_vpc.main.id
# }

# output "public_subnets" {
#   value = aws_subnet.public_subnet[*].id
# }

# output "private_subnets" {
#   description = "List of Private Subnet IDs"
#   value       = aws_subnet.private_subnet[*].id
# }

# # output "bastion_public_ip" {
# #   description = "Public IP of the Bastion Host"
# #   value       = aws_instance.bastion.public_ip
# # }

# # output "bastion_sg_id" {
# #   value       = aws_security_group.bastion_sg.id
# # }

# output "db_sg_id" {
#   value = aws_security_group.db_sg.id
#   description = "Database Security Group ID"
# }



output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = length(aws_subnet.public_subnet) > 0 ? aws_subnet.public_subnet[*].id : []
}

output "private_subnets" {
  description = "List of Private Subnet IDs"
  value       = aws_subnet.private_subnet[*].id
}

output "db_sg_id" {
  value       = length(aws_security_group.db_sg) > 0 ? aws_security_group.db_sg[0].id : null
  description = "Database Security Group ID"
}

output "bastion_sg_id" {
  value = length(aws_security_group.bastion_sg) > 0 ? aws_security_group.bastion_sg[0].id : null
}

output "bastion_public_ip" {
  value = length(aws_instance.bastion) > 0 ? aws_instance.bastion[0].public_ip : null
}

output "vm_sg_id" {
  value       = length(aws_security_group.vm_sg) > 0 ? aws_security_group.vm_sg[0].id : null
  description = "Security Group ID for VM5 & VM6 (Only in Prod)"
}

output "app_sg_id" {
  value       = length(aws_security_group.app_sg) > 0 ? aws_security_group.app_sg[0].id : null
  description = "App Security Group ID"
}

output "web_sg_id" {
  value       = length(aws_security_group.web_sg) > 0 ? aws_security_group.web_sg[0].id : null
  description = "Web Security Group ID"
}
