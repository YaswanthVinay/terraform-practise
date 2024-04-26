# Creating S3 bucket
resource "aws_s3_bucket" "bucket_name" {
  bucket = "yashwanth-terraform-aws-s3"
}

# Object ownership 
resource "aws_s3_bucket_ownership_controls" "object_ownership" {
  bucket = aws_s3_bucket.bucket_name.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Block public access for bucket
resource "aws_s3_bucket_public_access_block" "public-access" {
  bucket = aws_s3_bucket.bucket_name.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Managing ACL for bucket
resource "aws_s3_bucket_acl" "acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.object_ownership,
    aws_s3_bucket_public_access_block.public-access,
  ]

  bucket = aws_s3_bucket.bucket_name.id
  acl    = "public-read"
}

# Uploading files to the bucket
resource "aws_s3_object" "Object_Upload" {
  for_each = fileset("uploads/", "*")
  bucket   = aws_s3_bucket.bucket_name.id
  key      = each.value
  source   = "uploads/${each.value}"
}

# Enabling the bucket versioning feature
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket_name.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Creating S3 bucket policy for the user to access the objects
resource "aws_s3_bucket_policy" "allow_access_" {
  bucket = aws_s3_bucket.bucket_name.id
  policy = data.aws_iam_policy_document.object_access.json
}

