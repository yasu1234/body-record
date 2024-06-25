resource "aws_lb_target_group" "backend" {
  connection_termination             = null
  deregistration_delay               = jsonencode(300)
  ip_address_type                    = "ipv4"
  lambda_multi_value_headers_enabled = null
  load_balancing_algorithm_type      = "round_robin"
  load_balancing_anomaly_mitigation  = "off"
  load_balancing_cross_zone_enabled  = "use_load_balancer_configuration"
  name                               = "body-record-group"
  name_prefix                        = null
  port                               = 80
  preserve_client_ip                 = null
  protocol                           = "HTTP"
  protocol_version                   = "HTTP1"
  proxy_protocol_v2                  = null
  slow_start                         = 0
  tags                               = {}
  tags_all                           = {}
  target_type                        = "ip"
  vpc_id                             = "vpc-0a5d8dd2f75850a61"
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = jsonencode(200)
    path                = "/okcomputer"
    port                = jsonencode(3000)
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  stickiness {
    cookie_duration = 86400
    cookie_name     = null
    enabled         = false
    type            = "lb_cookie"
  }
}

resource "aws_lb" "body-record-alb" {
  client_keep_alive                                            = 3600
  customer_owned_ipv4_pool                                     = null
  desync_mitigation_mode                                       = "defensive"
  dns_record_client_routing_policy                             = null
  drop_invalid_header_fields                                   = false
  enable_cross_zone_load_balancing                             = true
  enable_deletion_protection                                   = false
  enable_http2                                                 = true
  enable_tls_version_and_cipher_suite_headers                  = false
  enable_waf_fail_open                                         = false
  enable_xff_client_port                                       = false
  enforce_security_group_inbound_rules_on_private_link_traffic = null
  idle_timeout                                                 = 60
  internal                                                     = false
  ip_address_type                                              = "ipv4"
  load_balancer_type                                           = "application"
  name                                                         = "body-record-alb"
  name_prefix                                                  = null
  preserve_host_header                                         = false
  security_groups                                              = ["sg-05ff7c881fb8582b0"]
  tags                                                         = {}
  tags_all                                                     = {}
  xff_header_processing_mode                                   = "append"
  access_logs {
    bucket  = ""
    enabled = false
    prefix  = null
  }
  connection_logs {
    bucket  = ""
    enabled = false
    prefix  = null
  }
  subnet_mapping {
    allocation_id        = null
    ipv6_address         = null
    private_ipv4_address = null
    subnet_id            = "subnet-0373469010862d2de"
  }
  subnet_mapping {
    allocation_id        = null
    ipv6_address         = null
    private_ipv4_address = null
    subnet_id            = "subnet-0a753077dc7206d99"
  }
}

resource "aws_lb_listener" "listener-http" {
  alpn_policy       = null
  certificate_arn   = null
  load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:110550326393:loadbalancer/app/body-record-alb/7a7526fbbef7a7e6"
  port              = 80
  protocol          = "HTTP"
  ssl_policy        = null
  tags              = {}
  tags_all          = {}
  default_action {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:110550326393:targetgroup/body-record-group/0e079d458796b3c5"
    type             = "forward"
  }
}

resource "aws_lb_listener" "listener-https" {
  alpn_policy       = null
  certificate_arn   = "arn:aws:acm:us-east-1:110550326393:certificate/56a85841-d3b8-4cf6-aa43-802f6ec2e9b4"
  load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:110550326393:loadbalancer/app/body-record-alb/7a7526fbbef7a7e6"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  tags              = {}
  tags_all          = {}
  default_action {
    type = "forward"
    forward {
      stickiness {
        duration = 3600
        enabled  = false
      }
      target_group {
        arn    = "arn:aws:elasticloadbalancing:us-east-1:110550326393:targetgroup/body-record-group/0e079d458796b3c5"
        weight = 1
      }
    }
  }
  mutual_authentication {
    ignore_client_certificate_expiry = false
    mode                             = "off"
    trust_store_arn                  = null
  }
}
