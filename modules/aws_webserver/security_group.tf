#This code doesn't support modularility
# resource "aws_security_group" "web_sg" {
#   vpc_id = var.vpc_id 

# #Allow HTTP access from anywhere
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  
#   }

# # Only allow SSH from Bastion Host
#   ingress {
#     from_port       = 22
#     to_port         = 22
#     protocol        = "tcp"
#     security_groups = [var.bastion_sg_id]
#   }

#   #Fix so web server has internet access to install httpd
#     egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#     tags = {
#     Name = "${var.prefix}-web-sg"
#   }
# }


#Web Server Security Group (Only in Nonprod)
resource "aws_security_group" "web_sg" {
  count  = var.env == "nonprod" ? 1 : 0
  vpc_id = var.vpc_id

  #Allow HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow SSH only from the Bastion Host
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = var.bastion_sg_id != null ? [var.bastion_sg_id] : []
  }

  #Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "${var.prefix}-web-sg"
  }
}
