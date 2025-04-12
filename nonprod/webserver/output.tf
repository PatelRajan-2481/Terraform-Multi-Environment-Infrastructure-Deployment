output "webserver_public_ips" {
  value = module.webserver.webserver_public_ips
}

output "webserver_private_ips" {
  value = module.webserver.webserver_private_ips
}

output "alb_dns_name" {
  value = module.webserver.alb_dns_name
}
