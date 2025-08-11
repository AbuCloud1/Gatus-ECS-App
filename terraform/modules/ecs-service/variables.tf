variable "family" {
  description = "Family name for the ECS task definition"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "cluster_id" {
  description = "ECS cluster ID"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_image" {
  description = "Container image to use"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
}

variable "cpu" {
  description = "CPU units for the task"
  type        = number
}

variable "memory" {
  description = "Memory for the task in MiB"
  type        = number
}

variable "target_group_arn" {
  description = "Target group ARN for the load balancer"
  type        = string
}

variable "subnets" {
  description = "Subnets where ECS tasks will run"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where ECS tasks will run"
  type        = string
}

variable "alb_sg_id" {
  description = "ALB security group ID for ingress rules"
  type        = string
}

