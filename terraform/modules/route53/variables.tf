variable "domain_name" {
  description = "Domain name for the hosted zone"
  type        = string
}

variable "record_name" {
  description = "Record name to create (relative or FQDN)"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS name used for the alias target"
  type        = string
}

variable "alb_zone_id" {
  description = "ALB hosted zone ID used for the alias target"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}