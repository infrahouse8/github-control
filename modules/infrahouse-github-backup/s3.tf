resource "aws_s3_bucket" "infrahouse-backup" {
  bucket_prefix = "infrahouse-backup-"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.infrahouse-backup.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "infrahouse-backup" {
  bucket = aws_s3_bucket.infrahouse-backup.id
  policy = data.aws_iam_policy_document.access_logs[count.index].json
}

data "aws_iam_policy_document" "access_logs" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::303467602807:role/aws-reserved/sso.amazonaws.com/us-west-1/AWSReservedSSO_AWSAdministratorAccess_422821c726d81c14"
      ]
    }
    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.infrahouse-backup.id}/*"
    ]
  }
}

resource "aws_s3_object" "check_file" {
  bucket       = aws_s3_bucket.infrahouse-backup.bucket
  key          = ".github"
  content      = ""
  content_type = "text/plain"
}
