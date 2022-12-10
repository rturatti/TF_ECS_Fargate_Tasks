resource "aws_ecs_task_definition" "this" {
  family                   = var.container_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = var.task_network_mode
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  task_role_arn            = var.task_role_arn
  container_definitions = jsonencode(
    [
      {
        "name"      = var.container_name
        "image"     = var.container_image
        "cpu"       = var.container_cpu
        "memory"    = var.container_memory
        "essential" = true
        "portMappings" = [
          {
            "containerPort" = var.container_port
            "hostPort"      = var.container_hostPort
            "protocol"      = var.container_protocol
          }
        ]
        "environment" = var.container_environment
      }
    ]
  )
}