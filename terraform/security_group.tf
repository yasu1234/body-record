resource "aws_security_group" "security-group-rds" {
  description            = "RDS-SG"
  name                   = "RDS-SG"
  name_prefix            = null
  revoke_rules_on_delete = null
  tags                   = {}
  tags_all               = {}
  vpc_id                 = "vpc-0a5d8dd2f75850a61"
}

resource "aws_security_group" "security-group-ecs" {
  description            = "ECS-SG"
  name                   = "ECS-SG"
  name_prefix            = null
  revoke_rules_on_delete = null
  tags                   = {}
  tags_all               = {}
  vpc_id                 = "vpc-0a5d8dd2f75850a61"
}
