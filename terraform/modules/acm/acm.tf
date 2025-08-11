resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names

  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name      = "acm-${var.environment}"
    ManagedBy = "Terraform"
  }
}

resource "aws_route53_record" "acm_route53_validation" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  timeouts {
    create = "5m"
  }
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_route53_validation : record.fqdn]
}