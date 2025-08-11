variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener (optional). If empty, HTTPS listener is not created."
  type        = string
  default     = ""
}

variable "target_port" {
  description = "Port for the target group (container port)"
  type        = number
  default     = 80
}