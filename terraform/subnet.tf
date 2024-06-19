# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_subnet" "subnet-rds-1" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "us-east-1a"
  cidr_block                                     = "10.0.128.0/20"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_cidr_block                                = null
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    Name = "プロジェクト-subnet-private1-us-east-1a"
  }
  tags_all = {
    Name = "プロジェクト-subnet-private1-us-east-1a"
  }
  vpc_id = "vpc-0a5d8dd2f75850a61"
}

# __generated__ by Terraform
resource "aws_subnet" "subnet-rds-2" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "us-east-1b"
  cidr_block                                     = "10.0.144.0/20"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_cidr_block                                = null
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  outpost_arn                                    = null
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    Name = "プロジェクト-subnet-private2-us-east-1b"
  }
  tags_all = {
    Name = "プロジェクト-subnet-private2-us-east-1b"
  }
  vpc_id = "vpc-0a5d8dd2f75850a61"
}

# __generated__ by Terraform
resource "aws_subnet" "subnet-2" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "us-east-1a"
  cidr_block                                     = "10.0.0.0/20"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_cidr_block                                = null
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    Name = "プロジェクト-subnet-public1-us-east-1a"
  }
  tags_all = {
    Name = "プロジェクト-subnet-public1-us-east-1a"
  }
  vpc_id = "vpc-0a5d8dd2f75850a61"
}

# __generated__ by Terraform
resource "aws_subnet" "subnet-1" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "us-east-1b"
  cidr_block                                     = "10.0.16.0/20"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_cidr_block                                = null
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    Name = "プロジェクト-subnet-public2-us-east-1b"
  }
  tags_all = {
    Name = "プロジェクト-subnet-public2-us-east-1b"
  }
  vpc_id = "vpc-0a5d8dd2f75850a61"
}
