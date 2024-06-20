resource "aws_iam_user" "ses" {
  force_destroy        = null
  name                 = "body-record-ses"
  path                 = "/"
  permissions_boundary = null
  tags                 = {}
  tags_all             = {}
}

resource "aws_iam_user_policy_attachment" "ses-attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
  user       = "body-record-ses"
}

resource "aws_iam_user" "s3" {
  force_destroy        = null
  name                 = "body-record-s3"
  path                 = "/"
  permissions_boundary = null
  tags                 = {}
  tags_all             = {}
}

resource "aws_iam_user_policy_attachment" "s3-attach" {
  policy_arn = "arn:aws:iam::110550326393:policy/rails-activestorage-s3-policy"
  user       = "body-record-s3"
}


resource "aws_iam_user" "ecs" {
  force_destroy        = null
  name                 = "inbody-record-admin"
  path                 = "/"
  permissions_boundary = null
  tags                 = {}
  tags_all             = {}
}

resource "aws_iam_user_policy_attachment" "ecs-attach" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  user       = "inbody-record-admin"
}
