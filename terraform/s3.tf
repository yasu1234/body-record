# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "body-record"
resource "aws_s3_bucket_cors_configuration" "backet-cors" {
  bucket                = "body-record"
  expected_bucket_owner = null
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT"]
    allowed_origins = ["https://backend.kumaydevelop.com"]
    expose_headers  = []
    id              = null
    max_age_seconds = 3600
  }
}

# __generated__ by Terraform from "body-record"
resource "aws_s3_bucket_acl" "backet-acl" {
  acl                   = null
  bucket                = "body-record"
  expected_bucket_owner = null
  access_control_policy {
    grant {
      permission = "FULL_CONTROL"
      grantee {
        email_address = null
        id            = "27132be94fe3e6f3f2765efdc8aa68f2833f7dafa5f9a5f8046b78ceea351d92"
        type          = "CanonicalUser"
        uri           = null
      }
    }
    owner {
      display_name = "yasuhiro79367s"
      id           = "27132be94fe3e6f3f2765efdc8aa68f2833f7dafa5f9a5f8046b78ceea351d92"
    }
  }
}

# __generated__ by Terraform from "body-record"
resource "aws_s3_bucket_server_side_encryption_configuration" "s3-encryption-configuration" {
  bucket                = "body-record"
  expected_bucket_owner = null
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = null
      sse_algorithm     = "AES256"
    }
  }
}

# __generated__ by Terraform from "body-record"
resource "aws_s3_bucket" "s3_bucket" {
  bucket              = "body-record"
  bucket_prefix       = null
  force_destroy       = null
  object_lock_enabled = false
  tags                = {}
  tags_all            = {}
}
