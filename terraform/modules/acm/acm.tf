resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names

  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name      = "acm-${var.environment}-${random_id.cert_suffix.hex}-${data.aws_caller_identity.current.account_id}"
    ManagedBy = "Terraform"
  }
}

resource "random_id" "cert_suffix" {
  byte_length = 4
}

data "aws_caller_identity" "current" {}

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

  lifecycle {
    ignore_changes = [records]
  }
}

resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  timeouts {
    create = "10m"
  }
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_route53_validation : record.fqdn]
}