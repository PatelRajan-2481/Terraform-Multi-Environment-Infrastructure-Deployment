variable "env" {
  description = "Environment (nonprod/prod)"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key for EC2 instances"
  type        = string
  default     = "key1"
}

variable "vpc_id" {
  description = "VPC ID for web servers"
  type        = string
  default     = ""
}

variable "public_subnets" {
  description = "Public Subnets for Web Servers"
  type        = list(string)
  default     = []
}

variable "bastion_sg_id" {
  description = "Bastion Host Security Group ID"
  type        = string
  default     = ""
}

variable "private_subnets" {
  description = "Private Subnets for Database and App Servers"
  type        = list(string)
}

variable "db_sg_id" {
  description = "Database Security Group ID"
  type        = string
}

variable "app_sg_id" {
  description = "Application Security Group ID"
  type        = string
}

variable "web_sg_id" {
  description = "Web Security Group ID"
  type        = string
}
