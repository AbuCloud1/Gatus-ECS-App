variable "domain_name" {
  description = "The primary domain name for the ACM certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "Optional subject alternative names for the certificate"
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "The Route 53 hosted zone ID used for DNS validation records"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod) used for tagging"
  type        = string
}
