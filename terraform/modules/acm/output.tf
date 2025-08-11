output "certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.acm_certificate.arn
}

output "domain_name" {
  description = "The primary domain name for the certificate"
  value       = aws_acm_certificate.acm_certificate.domain_name
}

