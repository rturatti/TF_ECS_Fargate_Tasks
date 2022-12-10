terraform {
  backend "s3" {
    bucket = "terraform-tfstate"
    key    = "DEV/fargate-terraform.tfstate"
    region = "us-east-1"
  }
}