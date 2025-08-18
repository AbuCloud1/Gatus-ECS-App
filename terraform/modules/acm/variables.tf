variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "Subject alternative names for the certificate"
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "Route53 zone ID for DNS validation"
  type        = string
}

variable "force_recreation" {
  description = "Force recreation of the certificate"
  type        = bool
  default     = true
}
