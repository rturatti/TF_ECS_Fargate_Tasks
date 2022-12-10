variable "vpc_name" {
  description = "The VPC name"
  type        = string
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region"
}

variable "IAM_Role_Name" {
  type        = string
  description = "IAM role for ecs"
}

variable "ecs_cluster_name" {
  type = string
}

variable "security_group_from_port" {
  type    = number
  default = 80
}

variable "security_group_to_port" {
  type    = number
  default = 80
}
