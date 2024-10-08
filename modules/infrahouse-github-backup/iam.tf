data "aws_iam_policy_document" "permissions" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.infrahouse-backup.id}/*"
    ]
  }
}

data "aws_iam_policy_document" "trust" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.infrahouse-backup.id}/*"
    ]
  }
}

data "aws_iam_policy_document" "infrahouse-backup-trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = local.infrahouse_roles
    }
  }
}

data "aws_iam_policy_document" "infrahouse-backup" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.infrahouse-backup.id}/*"
    ]
  }
  statement {
    actions = ["s3:ListBucket"]
    resources = [
      aws_s3_bucket.infrahouse-backup.arn
    ]
  }
}

resource "aws_iam_policy" "infrahouse-backup" {
  name_prefix = "infrahouse-backup-"
  policy      = data.aws_iam_policy_document.infrahouse-backup.json
}

resource "aws_iam_role" "infrahouse-backup" {
  name_prefix        = "infrahouse-backup-"
  description        = "Role for InfraHouse to backup GitHub"
  assume_role_policy = data.aws_iam_policy_document.infrahouse-backup-trust.json
}

resource "aws_iam_role_policy_attachment" "infrahouse-backup" {
  policy_arn = aws_iam_policy.infrahouse-backup.arn
  role       = aws_iam_role.infrahouse-backup.name
}
