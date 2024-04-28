# creating the bucket

resource "aws_s3_bucket" "website" {
  bucket = "my-webiste.com"
}

# making our website publicly accessible

resource "aws_s3_bucket_public_access_block" "accessible" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# uploading the WEBSITE to the bucket

resource "aws_s3_object" "index" {

  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "app/index.html"
  acl          = "public-read"
  content_type = "text/html"
}
# Enabling the ACL in order to access the WEBSITE

resource "aws_s3_bucket_ownership_controls" "acl-ownership" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl-Enabling" {
  depends_on = [
    aws_s3_bucket_ownership_controls.acl-ownership,
    aws_s3_bucket_public_access_block.accessible,
  ]

  bucket = aws_s3_bucket.website.id

  acl = "public-read"
}

# Enabling the STATIC WEBSITE HOSTING  feature for our Bucket

resource "aws_s3_bucket_website_configuration" "hosting" {
  bucket = aws_s3_bucket.website.id
  index_document {
    suffix = "index.html" # Pointing the Index Document to our 'index.
  }

}

