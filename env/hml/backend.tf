terraform {
  backend "s3" {
    bucket = "terraform-tfstate"
    key    = "HML/fargate-terraform.tfstate"
    region = "us-west-1"
  }
}