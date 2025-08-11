# Create Route53 hosted zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
  
  tags = {
    Name      = "${var.environment}-${var.domain_name}-zone"
    ManagedBy = "Terraform"
  }
}

# Create A record pointing to ALB
resource "aws_route53_record" "route53" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}