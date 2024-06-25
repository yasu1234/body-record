resource "aws_ses_domain_identity" "ses" {
  domain = data.aws_ssm_parameter.mail-host.value
}
