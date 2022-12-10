terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.27"
    }
  }
  required_version = ">= 1.0.0"
}
provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

module "infra" {
  source                   = "../../modules/infra"
  vpc_name                 = "develop"
  IAM_Role_Name            = "develop"
  ecs_cluster_name         = "develop"
  security_group_from_port = 80
  security_group_to_port   = 80
}

module "ecr-01" {
  source          = "../../modules/ecr"
  name_repository = "lab-app-01"
}
output "ECR_URL_01" {
  value = module.ecr-01.ECR_Repository_URL
}

module "ecr-02" {
  source          = "../../modules/ecr"
  name_repository = "lab-app-02"
}
output "ECR_URL_02" {
  value = module.ecr-02.ECR_Repository_URL
}

module "ecr-03" {
  source          = "../../modules/ecr"
  name_repository = "lab-app-03"
}
output "ECR_URL_03" {
  value = module.ecr-03.ECR_Repository_URL
}

module "ecr-04" {
  source          = "../../modules/ecr"
  name_repository = "lab-app-04"
}
output "ECR_URL_04" {
  value = module.ecr-04.ECR_Repository_URL
}

module "ecr-05" {
  source          = "../../modules/ecr"
  name_repository = "lab-app-05"
}
output "ECR_URL_05" {
  value = module.ecr-05.ECR_Repository_URL
}

module "ecr-06" {
  source          = "../../modules/ecr"
  name_repository = "lab-app-06"
}
output "ECR_URL_06" {
  value = module.ecr-06.ECR_Repository_URL
}

module "fargate-tasks-01" {
  source                        = "../../modules/fargate-tasks"
  vpc_id                        = module.infra.VPC_ID
  private_subnets               = module.infra.PRIVATE_SUBNETS
  public_subnets                = module.infra.PUBLIC_SUBNETS
  container_name                = "lab-app-01"
  task_network_mode             = "awsvpc"
  task_role_arn                 = module.infra.task_role_arn
  task_cpu                      = 256
  task_memory                   = 512
  container_image               = "kubedevio/nginx-color:blue"
  container_cpu                 = 256
  container_memory              = 512
  container_port                = 80
  container_hostPort            = 80
  container_protocol            = "tcp"
  container_environment         = [ 
    { name = "COLOR",
      value = "blue" 
    },
    { name = "VERSION",
      value = "1.0.0" 
    }
  ]
  ecs_cluster_id                = module.infra.ecs_cluster_id
  service_desired_count         = 2
  service_assign_public_ip      = false
  service_security_groups       = [module.infra.private_security_group_id]
  #load_balancer_security_groups = [module.infra.lb_security_group_id]
}

module "fargate-tasks-02" {
  source                        = "../../modules/fargate-tasks"
  vpc_id                        = module.infra.VPC_ID
  private_subnets               = module.infra.PRIVATE_SUBNETS
  public_subnets                = module.infra.PUBLIC_SUBNETS
  container_name                = "lab-app-02"
  task_network_mode             = "awsvpc"
  task_role_arn                 = module.infra.task_role_arn
  task_cpu                      = 256
  task_memory                   = 512
  container_image               = "kubedevio/nginx-color:blue"
  container_cpu                 = 256
  container_memory              = 512
  container_port                = 80
  container_hostPort            = 80
  container_protocol            = "tcp"
  container_environment         = [ 
    { name = "COLOR",
      value = "blue" 
    },
    { name = "VERSION",
      value = "1.0.0" 
    }
  ]
  ecs_cluster_id                = module.infra.ecs_cluster_id
  service_desired_count         = 2
  service_assign_public_ip      = false
  service_security_groups       = [module.infra.private_security_group_id]
  #load_balancer_security_groups = [module.infra.lb_security_group_id]
}

module "fargate-tasks-03" {
  source                        = "../../modules/fargate-tasks-with-alb"
  vpc_id                        = module.infra.VPC_ID
  private_subnets               = module.infra.PRIVATE_SUBNETS
  public_subnets                = module.infra.PUBLIC_SUBNETS
  container_name                = "lab-app-03"
  task_network_mode             = "awsvpc"
  task_role_arn                 = module.infra.task_role_arn
  task_cpu                      = 256
  task_memory                   = 512
  container_image               = "kubedevio/nginx-color:green"
  container_cpu                 = 256
  container_memory              = 512
  container_port                = 80
  container_hostPort            = 80
  container_protocol            = "tcp"
  container_environment         = [ 
    { name = "COLOR",
      value = "green"
    },
    { name = "VERSION",
      value = "1.0.0" 
    }
  ]
  ecs_cluster_id                = module.infra.ecs_cluster_id
  service_desired_count         = 2
  service_assign_public_ip      = false
  service_security_groups       = [module.infra.private_security_group_id]
  load_balancer_security_groups = [module.infra.lb_security_group_id]
}

# # ### Outputs
# output "DNS_alb_app-01" {
#   value = module.fargate-tasks-01.DNS_LB
# }

# output "DNS_alb_app-02" {
#   value = module.fargate-tasks-02.DNS_LB
# }

output "DNS_alb_app-03" {
  value = module.fargate-tasks-03.DNS_LB
}