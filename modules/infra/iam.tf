resource "aws_iam_role" "iam_role_ecs" {
  name = "${var.IAM_Role_Name}_ecs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["ec2.amazonaws.com",
          "ecs-tasks.amazonaws.com"]
        }
      },
    ]
  })
}
resource "aws_iam_role_policy" "ecs_access_ecr" {
  name = "ecs_access_ecr"
  role = aws_iam_role.iam_role_ecs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "profile_ecs" {
  name = "${var.IAM_Role_Name}_perfil"
  role = aws_iam_role.iam_role_ecs.name
}

# outputs
output "task_role_arn" {
  value = aws_iam_role.iam_role_ecs.arn
}