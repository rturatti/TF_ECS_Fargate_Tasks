module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.16.0"

  name            = "${var.vpc_name}-vpc"
  cidr            = "10.0.0.0/16"
  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = false
  tags = {
    Terraform = "true"
  }
}

output "VPC_ID" {
  value = module.vpc.vpc_id
}

output "VPC_NAME" {
  value = module.vpc.name
}

output "PUBLIC_SUBNETS" {
  value = module.vpc.public_subnets
}

output "PUBLIC_SUBNET_0" {
  value = module.vpc.public_subnets[0]
}

output "PUBLIC_SUBNET_1" {
  value = module.vpc.public_subnets[1]
}

output "PUBLIC_SUBNET_2" {
  value = module.vpc.public_subnets[2]
}

output "PRIVATE_SUBNETS" {
  value = module.vpc.private_subnets
}