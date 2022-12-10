variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "The private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "The public subnets"
  type        = list(string)
}

variable "task_network_mode" {
  description = "The network mode to use for the containers in the task"
  type        = string
  default     = "awsvpc"
}

variable "task_role_arn" {
  description = "value of the task role arn"
  type        = string
}

variable "task_cpu" {
  description = "The number of cpu units used by the task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "The amount of memory (in MiB) used by the task"
  type        = number
  default     = 512
}

variable "container_name" {
  description = "The name of the container"
  type        = string
}

variable "container_image" {
  description = "The image used to start the container"
  type        = string
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  type        = number
  default     = "256"
}

variable "container_memory" {
  description = "The amount of memory (in MiB) used by the task"
  type        = number
  default     = "512"
}

variable "container_port" {
  description = "The port number on the container that is bound to the user-specified or automatically assigned host port"
  type        = number
}
variable "container_hostPort" {
  description = "The port number on the container instance to reserve for your container"
  type        = number
}

variable "container_protocol" {
  description = "The protocol used for the port mapping"
  type        = string
  default     = "tcp"
}

variable "container_environment" {
  description = "The container definitions"
  type = list(map(string))
  default = []
  }

## Task Services Variables
variable "ecs_cluster_id" {
  description = "The cluster id"
  type        = string
}

variable "service_desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  type        = string
  default     = 1
}

variable "service_assign_public_ip" {
  description = "Assign a public IP address to the ENI (Fargate launch type only)"
  type        = bool
  default     = false
}

variable "service_security_groups" {
  description = "A list of security group IDs to assign to the ENI (Fargate launch type only)"
  type        = list(string)
}