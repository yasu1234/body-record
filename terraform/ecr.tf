resource "aws_ecr_repository" "body-record-repository" {
  force_delete         = null
  image_tag_mutability = "MUTABLE"
  name                 = "body-record-rails"
  tags                 = {}
  tags_all             = {}
  encryption_configuration {
    encryption_type = "AES256"
    kms_key         = null
  }
  image_scanning_configuration {
    scan_on_push = false
  }
}
