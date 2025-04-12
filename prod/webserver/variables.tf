variable "env" {
  type        = string
  description = "Environment (nonprod/prod)"
}

variable "prefix" {
  type        = string
  description = "Prefix for resource naming"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for web servers"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of Private Subnets"
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key for EC2 instances"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public Subnets for Web Servers"
  default     = [] # Avoids issue in `prod`
}

variable "bastion_sg_id" {
  type        = string
  description = "Bastion Security Group ID"
  default     = null # Ensures `prod` does not require it
}

variable "db_sg_id" {
  type        = string
  description = "Database Security Group ID"
  default     = null # Ensures `prod` does not require it
}

variable "app_sg_id" {
  type        = string
  description = "App Security Group ID"
  default     = null # Ensures `prod` does not require it
}

variable "vm_sg_id" {
  type        = string
  description = "Security Group for VM5 & VM6 in prod environment"
  default     = null #  Ensures `nonprod` does not require it
}

variable "web_sg_id" {
  description = "Web Security Group ID (Only needed in Nonprod)"
  type        = string
  default     = null #  Ensures `prod` does not require it
}
