resource "aws_cloudwatch_event_rule" "batch" {
  description         = null
  event_bus_name      = "default"
  event_pattern       = null
  force_destroy       = false
  name                = "body-record-batch-schedule"
  name_prefix         = null
  role_arn            = null
  schedule_expression = "cron(0 16 * * ? *)"
  state               = "ENABLED"
  tags                = {}
  tags_all            = {}
}
