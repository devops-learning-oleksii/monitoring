resource "aws_kms_key" "admin-s3-key" {
  description             = "KMS key for Admin user to access S3 terraform state bucket"
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.kms_exclusive_policy.json

  bypass_policy_lockout_safety_check = false

  enable_key_rotation = true
}

resource "aws_kms_alias" "admin-s3-key" {
  name          = "alias/admin-s3-key"
  target_key_id = aws_kms_key.admin-s3-key.key_id
}