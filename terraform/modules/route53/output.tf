output "zone_id" {
  description = "The ID of the created Route53 hosted zone"
  value       = aws_route53_zone.main.zone_id
}

output "nameservers" {
  description = "Nameservers for the hosted zone"
  value       = aws_route53_zone.main.name_servers
}

output "domain_name" {
  description = "The domain name for the hosted zone"
  value       = var.domain_name
}

output "record_fqdn" {
  description = "FQDN of the created record"
  value       = aws_route53_record.route53.fqdn
}

output "app_url" {
  description = "The URL where your application will be accessible"
  value       = "https://${var.record_name}.${var.domain_name}"
}
