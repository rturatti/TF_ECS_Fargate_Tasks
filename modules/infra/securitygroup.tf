resource "aws_security_group" "alb_sg" {
  name        = "alb_ECS-sg"
  description = "Allow inbound traffic in ECS"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "tcp_alb_sgr" {
  type              = "ingress"
  from_port         = var.security_group_from_port
  to_port           = var.security_group_to_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "allow_out_alb_sgr" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group" "private_sg" {
  name        = "private_ECS-sg"
  description = "Allow inbound traffic in ECS"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "in_ecs_sgr" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.private_sg.id
}

resource "aws_security_group_rule" "allow_out_ecs_sgr" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private_sg.id
}

#Output
output "lb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "private_security_group_id" {
  value = aws_security_group.private_sg.id
}