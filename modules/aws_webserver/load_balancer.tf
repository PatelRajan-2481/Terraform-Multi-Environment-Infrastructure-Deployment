# Application Load Balancer (ALB)
resource "aws_lb" "web_alb" {
  count              = var.env == "nonprod" ? 1 : 0
  name               = "nonprod-web-alb"
  internal           = false
  load_balancer_type = "application"
  #security_groups    = var.web_sg_id != null ? [var.web_sg_id] : []  # Fix: Ensure a valid security group is attached
  security_groups    = length([var.web_sg_id]) > 0 ? [var.web_sg_id] : []

  subnets            = var.public_subnets  # ALB should be in public subnets
}

#Create Target Group for Web Servers
resource "aws_lb_target_group" "web_tg" {
  count    = var.env == "nonprod" ? 1 : 0
  name     = "nonprod-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

#Register VM1 & VM2 to Target Group
resource "aws_lb_target_group_attachment" "web_tg_attachment" {
  count            = var.env == "nonprod" ? 2 : 0
  target_group_arn = aws_lb_target_group.web_tg[0].arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}

#Create ALB Listener on Port 80
resource "aws_lb_listener" "web_listener" {
  count             = var.env == "nonprod" ? 1 : 0
  load_balancer_arn = aws_lb.web_alb[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg[0].arn
  }
}
