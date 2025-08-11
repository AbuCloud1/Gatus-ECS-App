output "target_group_arn" {
  value = aws_lb_target_group.alb_target_group.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "The zone ID of the Application Load Balancer"
  value       = aws_lb.alb.zone_id
}

output "alb_sg_id" {
  description = "Security group ID used by the ALB"
  value       = aws_security_group.aws-sg-load-balancer.id
}