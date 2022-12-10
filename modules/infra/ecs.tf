module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.1"

  cluster_name = "${var.ecs_cluster_name}-ecs"
  tags = {
    Terraform = "True"
    Project   = "Ecs"
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 1
        base   = 0
      }
    }
  }

}

output "ecs_cluster_id" {
  value = module.ecs.cluster_id
}