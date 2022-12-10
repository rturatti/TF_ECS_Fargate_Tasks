# AWS_IaC_TF_ECS_Fargate
### Descrição
Configuração para criação do ECS Fargate via módulo e módulos de Task Definition para vincular o cluster.

## Criando o Cluster
Acessar o diretório do ambiente desejado `(dev|hml|prod)` e executar o comando abaixo para inicializar o terraform: 
</br>
`terraform init`

Após a inicialização do terraform, executar o comando abaixo para realizar o planejamento da infraestrutura: 
</br>
`terraform plan`

Após o planejamento, executar o comando abaixo para realizar a criação da infraestrutura: 
</br>
`terraform apply` 

## Destruindo o Cluster
Acessar o diretório do ambiente desejado `(dev|hml|prod)` e executar o comando abaixo para destruir a infraestrutura: 
</br>
`terraform init`

Após a inicialização do terraform, executar o comando abaixo para realizar a destruição da infraestrutura: 
</br>
`terraform destroy`


### Módulo Infra
- VPC
- Subnets
- Security Group
- IAM Role
- NAT Gateway
- ECS Fargate Cluster
</br>

### Módulo ECR
- Elastic Container Registry
</br>

### Módulo Fargate-Tasks
- Tasks Definitions
- Services
</br>

### Módulo Fargate-Tasks-With-ALB (Em desenvolvimento)
- Tasks Definitions
- Load Balancer
- Services
</br>

### Exemplo - Módulo Infra
```hcl
module "infra" {
  source                   = "../../modules/infra"
  vpc_name                 = "develop"
  IAM_Role_Name            = "develop"
  ecs_cluster_name         = "develop"
  security_group_from_port = 80
  security_group_to_port   = 80
}
```

### Exemplo - Módulo ECR
```hcl
module "ecr-01" {
  source          = "../../modules/ecr"
  name_repository = "lab-app-01"
}

output "ECR_URL_01" {
  value = module.ecr-01.ECR_Repository_URL
}
```

### Exemplo - Módulo Fargate-Tasks
```hcl
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
  container_image               = "nginx:$version"
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
}
```

### Exemplo - Módulo Fargate-Tasks-With-ALB
```hcl
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
  container_image               = "nginx:$version"
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
```

## Inputs
### Common Variables
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| source | Diretório do módulo | string | `{}` | sim |

## Módulo Infra
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vpc\_name | Nome VPC | string | n/a | yes |
| cluster\_name | ECS cluster name | string | n/a | yes |
| IAM\_Role\_Name | Nome da regra do IAM a ser criada | string | n/a | yes |
| ecs\_cluster\_name | Nome do cluster ECS | string | n/a | yes |
| security\_group\_from\_port | Porta de origem para liberar ao LB | string | `80` | yes |
| security\_group\_to\_port | Porta de destino para liberar ao LB | number | `80` | no |

### Outputs
| Name | Description |
|------|-------------|
| VPC\_ID | ID da VPC |
| VPC\_NAME | Nome da VPC |
| PUBLIC\_SUBNETS | Lista das Subnets Públicas |
| PRIVATE\_SUBNETS | Lista das Subnets Privadas |
| lb\_security\_group\_id | ID do Security Group Load Balancer |
| private\_security\_group\_id | ID do Security Group Privado (Cluster) |
| task|_role\_arn | ARN da Role do IAM |
| ecs\_cluster\_id | ID do cluster ECS |
</br>
</br>

## Módulo ECR
### Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name\_repository | Nome do ECR | string | n/a | yes |

### Outputs
| Name | Description |
|------|-------------|
| ARN | ARN do ECR criado |
| ECR\_Name | Nome do ECR |
| ECR\_Repository\_URL | URL do ECR |
</br>

## Módulo Fargate-Tasks
### Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vpc\_id | ID da VPC a ser usada | string | n/a | yes |
| private\_subnets | Lista das Subnets Privadas | list | n/a | yes |
| public\_subnets | Lista das Subnets Públicas | list | n/a | yes |
| task\_network\_mode | Modo de rede da Task | string | `"awsvpc"` | no |
| task\_role\_arn | ARN da Role do IAM | string | n/a | yes |
| task\_cpu | CPU da Task | number | `256` | no |
| task\_memory | Memória da Task | number | `512` | no |
| container\_name | Nome do Container | string | n/a | yes |
| container\_image | Imagem do Container | string | n/a | yes |
| container\_cpu | CPU do Container | number | `256` | no |
| container\_memory | Memória do Container | number | `512` | no |
| container\_port | Porta do Container | string | n/a | yes |
| container\_host\_port | Porta do Host | string | n/a | yes |
| container\_protocol | Protocolo do Container | string | `"tcp"` | no |
| service\_desired\_count | Quantidade de Tasks | number | `1` | no |
| service\_assign\_public\_ip | Atribuir IP Público | string | `"false"` | no |
| service\_security\_groups | Lista de Security Groups | list | n/a | yes |
| load\_balancer\_target\_type | Tipo de Load Balancer | string | `"ip"` | no |
| load\_balancer\_name | Nome do Load Balancer | string | n/a | yes |
| load\_balancer\_protocol | Protocolo do Load Balancer | string | `"HTTP"` | no |

### Outputs
| Name | Description |
|------|-------------|
| DNS\_LB | DNS do Load Balancer |

[def]: docs/gifs/IaC_ECS_Fargate.gif