resource "aws_vpc_security_group_ingress_rule" "security-group-ecs-ingress-rule-1" {
  cidr_ipv4                    = "0.0.0.0/0"
  cidr_ipv6                    = null
  description                  = null
  from_port                    = 3000
  ip_protocol                  = "tcp"
  prefix_list_id               = null
  referenced_security_group_id = null
  security_group_id            = "sg-0f6aa001f35ffcb6a"
  tags                         = null
  to_port                      = 3000
}

resource "aws_vpc_security_group_ingress_rule" "security-group-ecs-ingress-rule-2" {
  cidr_ipv4                    = null
  cidr_ipv6                    = null
  description                  = null
  from_port                    = 80
  ip_protocol                  = "tcp"
  prefix_list_id               = null
  referenced_security_group_id = "sg-05ff7c881fb8582b0"
  security_group_id            = "sg-0f6aa001f35ffcb6a"
  tags                         = null
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "security-group-ecs-engress-rule" {
  cidr_ipv4                    = "0.0.0.0/0"
  cidr_ipv6                    = null
  description                  = null
  from_port                    = null
  ip_protocol                  = jsonencode(-1)
  prefix_list_id               = null
  referenced_security_group_id = null
  security_group_id            = "sg-0f6aa001f35ffcb6a"
  tags                         = null
  to_port                      = null
}

resource "aws_vpc_security_group_ingress_rule" "security-group-rds-ingress-rule" {
  cidr_ipv4                    = null
  cidr_ipv6                    = null
  description                  = null
  from_port                    = 5432
  ip_protocol                  = "tcp"
  prefix_list_id               = null
  referenced_security_group_id = "sg-0f6aa001f35ffcb6a"
  security_group_id            = "sg-05f85a822bf4fef78"
  tags                         = null
  to_port                      = 5432
}


resource "aws_vpc_security_group_egress_rule" "security-group-rds-engress-rule" {
  cidr_ipv4                    = "0.0.0.0/0"
  cidr_ipv6                    = null
  description                  = null
  from_port                    = null
  ip_protocol                  = jsonencode(-1)
  prefix_list_id               = null
  referenced_security_group_id = null
  security_group_id            = "sg-05f85a822bf4fef78"
  tags                         = null
  to_port                      = null
}

