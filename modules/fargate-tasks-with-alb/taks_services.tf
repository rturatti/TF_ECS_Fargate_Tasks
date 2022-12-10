resource "aws_ecs_service" "service_ecs" {
  depends_on = [
    aws_lb_target_group.this,
    aws_lb_listener.this,
    aws_lb.this
  ]
  name            = var.container_name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.service_desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.container_name
    container_port   = var.container_hostPort
  }

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