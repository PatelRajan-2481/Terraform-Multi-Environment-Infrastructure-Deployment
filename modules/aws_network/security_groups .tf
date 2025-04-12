# Bastion Host Security Group 
resource "aws_security_group" "bastion_sg" {
  count  = var.env == "nonprod" ? 1 : 0  
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips # Only allow SSH from trusted IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# Web Server Security Group 
resource "aws_security_group" "web_sg" {
  count  = var.env == "nonprod" ? 1 : 0  
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = aws_security_group.bastion_sg[*].id
  }
  
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# Database Security Group 
resource "aws_security_group" "db_sg" {
  count  = var.env == "nonprod" ? 1 : 0  
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = aws_security_group.web_sg[*].id
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = aws_security_group.bastion_sg[*].id
  }
  
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = aws_security_group.web_sg[*].id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

# App Server Security Group 
resource "aws_security_group" "app_sg" {
  count  = var.env == "nonprod" ? 1 : 0  
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = aws_security_group.bastion_sg[*].id
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = aws_security_group.web_sg[*].id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg"
  }
}

# Security Group for VM5 & VM6 
resource "aws_security_group" "vm_sg" {
  count  = var.env == "prod" ? 1 : 0  
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = aws_security_group.bastion_sg[*].id
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = aws_security_group.app_sg[*].id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vm-sg"
  }
}


#Before fixing to provide support for both env
# # Bastion Host Security Group (Allows SSH from Trusted IPs)
# resource "aws_security_group" "bastion_sg" {
# count  = var.env == "nonprod" ? 1 : 0
#   vpc_id = aws_vpc.main.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = var.allowed_ips # Only allow SSH from trusted IPs
#   }
  
#   #Fix for SSH and connectivity issue
#     egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Web Server Security Group (Allows HTTP, Restricts SSH)
# resource "aws_security_group" "web_sg" {
#   vpc_id = aws_vpc.main.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
#   }

#   ingress {
#     from_port       = 22
#     to_port         = 22
#     protocol        = "tcp"
#     security_groups = [aws_security_group.bastion_sg.id] # Only allow SSH from Bastion Host
#   }
# }

# # Database Security Group (Only Accessible by Web Servers)
# resource "aws_security_group" "db_sg" {
# count  = var.env == "nonprod" ? 1 : 0 
#   vpc_id = aws_vpc.main.id

#   ingress {
#     from_port       = 5432
#     to_port         = 5432
#     protocol        = "tcp"
#     security_groups = [aws_security_group.web_sg.id] # Only allow access from Web Servers
#   }
  
#   #Allow SSH (Port 22) from Bastion Host for administrative access
#     ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     security_groups = [aws_security_group.bastion_sg.id]  # Allow SSH from Bastion
#   }
  
#   # Allow SSH (Port 22) from Web Servers
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     security_groups = [aws_security_group.web_sg.id]  # Allow SSH from Web Servers
#   }
  
#   #Allow database responses back to Web Servers
#     egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Allow SSH from Bastion & Web Servers to App Server(VM4)
# resource "aws_security_group" "app_sg" {
#   vpc_id = aws_vpc.main.id

#   # Allow SSH (Port 22) from Bastion Host
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     security_groups = [aws_security_group.bastion_sg.id]  # Allow SSH from Bastion
#   }

#   # Allow SSH from Web Servers
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     security_groups = [aws_security_group.web_sg.id]  # Allow SSH from Web Servers
#   }

#   # Allow outbound traffic
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "app-sg"
#   }
# }
