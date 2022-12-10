resource "aws_ecs_service" "service_ecs" {
  name            = var.container_name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.service_desired_count

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = var.service_security_groups
    assign_public_ip = var.service_assign_public_ip
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    # base = 0
  }
}