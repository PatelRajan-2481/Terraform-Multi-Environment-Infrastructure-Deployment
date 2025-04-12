output "webserver_public_ips" {
  value = aws_instance.web[*].public_ip
}

output "webserver_private_ips" {
  value       = aws_instance.web[*].private_ip
  
}

output "alb_dns_name" {
  value = var.env == "nonprod" ? aws_lb.web_alb[0].dns_name : null # Fix:Use index [0] since `count` is set
}
