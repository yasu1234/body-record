resource "aws_route53_record" "body-record-zone-record" {
  allow_overwrite = null
  health_check_id = null
  name            = "backend.kumaydevelop.com"
  set_identifier  = null
  type            = "A"
  zone_id         = "Z003840626BROJDOT0S1D"

  alias {
    evaluate_target_health = true
    name                   = "dualstack.body-record-alb-344512122.us-east-1.elb.amazonaws.com"
    zone_id                = "Z35SXDOTRQ7X7K"
  }
}

resource "aws_route53_zone" "host-zone" {
  comment           = null
  delegation_set_id = null
  force_destroy     = null
  name              = "kumaydevelop.com"
  tags              = {}
  tags_all          = {}
}
