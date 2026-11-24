data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "kms_exclusive_policy" {
  statement {
    sid    = "AllowOnlyAdmin"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.arn]
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "enforce_https" {
  statement {
    sid    = "EnforceHTTPSRequestsOnly"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.state.arn,
      "${aws_s3_bucket.state.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}