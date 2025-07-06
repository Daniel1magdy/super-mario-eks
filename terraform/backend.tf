terraform {
  backend "s3" {
    bucket         = "super-mario-tf-state"
    key            = "eks/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-lock"
  }
}
