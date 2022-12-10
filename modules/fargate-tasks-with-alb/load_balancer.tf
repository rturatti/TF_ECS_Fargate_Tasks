resource "aws_lb" "this" {
  name               = var.container_name
  load_balancer_type = "application"
  security_groups    = var.load_balancer_security_groups
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "this" {
  name        = var.container_name
  port        = var.container_hostPort
  protocol    = var.load_balancer_protocol
  target_type = var.load_balancer_target_type
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.container_hostPort
  protocol          = var.load_balancer_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

output "DNS_LB" {
  value = aws_lb.this.dns_name
}