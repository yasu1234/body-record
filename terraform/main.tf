terraform {
  required_version = ">= 1.8.5"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ssm_parameter" "db_username" {
  name = "/rds/username"
}
data "aws_ssm_parameter" "db_password" {
  name = "/rds/password"
}
