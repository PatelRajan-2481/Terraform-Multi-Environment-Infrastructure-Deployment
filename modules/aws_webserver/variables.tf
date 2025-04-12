variable "env" {
  description = "Environment (nonprod/prod)"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key for EC2 instances"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for web servers"
  type        = string
}

variable "public_subnets" {
  description = "Public Subnets for Web Servers"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "Private Subnets for Database and App Servers"
  type        = list(string)
}

variable "bastion_sg_id" {
  description = "Bastion Host Security Group ID"
  type        = string
  default     = null
}

variable "db_sg_id" {
  description = "Database Security Group ID"
  type        = string
  default     = null
}

variable "app_sg_id" {
  description = "App Server Security Group ID"
  type        = string
  default     = null
}

variable "vm_sg_id" {
  description = "Security Group for VM5 & VM6 in prod environment"
  type        = string
  default     = null
}


variable "web_sg_id" {
  description = "Web Security Group ID (Only needed in Nonprod)"
  type        = string
  default     = null
}
