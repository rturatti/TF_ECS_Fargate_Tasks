terraform {
    backend "s3" {
        bucket = "terraform-tfstate-rt"
        key    = "PROD/fargate-terraform.tfstate"
        region = "sa-east-1"
    }
}