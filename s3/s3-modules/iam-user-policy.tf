# Defining IAM user
resource "aws_iam_user" "user" {
  name = "MAHESH-USER"
}

# Creating IAM policy
resource "aws_iam_policy" "policy" {
  name   = "s3_list_policy"
  policy = data.aws_iam_policy_document.policy_document.json
}

# Defining IAM policy document for the bucket policy
data "aws_iam_policy_document" "object_access" {
  statement {
    sid = "1"
    actions = [
       "s3:GetObject",
    #   "s3:ListBucket",
    #   "s3:GetObjectAcl"
    ]
    resources = [
      aws_s3_bucket.bucket_name.arn,
      "${aws_s3_bucket.bucket_name.arn}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::647322883293:user/MAHESH-USER"]
    }
  }
}

# Defining IAM policy document for IAM user policy
data "aws_iam_policy_document" "policy_document" {
  statement {
    sid = "1"
    actions = [
      "s3:ListAllMyBuckets",
    #   "s3:GetBucketLocation",
    #   "s3:ListBucket",
       "s3:GetObject",
    #   "s3:GetObjectAcl"
    ]
    resources = [
      "arn:aws:s3:::*",
    ]
  }
}

# Attaching IAM policy to IAM user
resource "aws_iam_policy_attachment" "test-attach" {
  name       = "s3-bucket-policy-attachment"
  users      = [aws_iam_user.user.name]
  policy_arn = aws_iam_policy.policy.arn
}
