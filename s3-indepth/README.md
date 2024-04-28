

---

# Terraform AWS S3 Website Deployment

This Terraform configuration is designed to deploy a static website on AWS S3, making it publicly accessible. The infrastructure includes the creation of an S3 bucket, uploading website files, enabling static website hosting, setting access control lists (ACLs), and attaching a bucket policy to allow public access.

## Prerequisites

Before you begin, ensure you have:

- An AWS account with appropriate permissions to create and manage S3 resources.
- Installed Terraform locally. You can download it from [Terraform's official website](https://www.terraform.io/downloads.html) and follow the installation instructions.

## Configuration Overview

The `terraform.tf` file defines the Terraform configuration for deploying the AWS resources. Let's go through each section:

### Providers

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

This section specifies the AWS provider and sets the region to `ap-south-1`.

### Backend Configuration

```hcl
backend "s3" {
  bucket = "terraforms3bucket007"
  key    = "s3-indepth/terraform.tfstate"
  region = "ap-south-1"
}
```

Configures Terraform to store its state file in an S3 bucket named `terraforms3bucket007`.

### AWS S3 Bucket Creation

```hcl
resource "aws_s3_bucket" "website" {
  bucket = "my-webiste.com"
}
```

Creates an S3 bucket named `my-webiste.com` to host the static website.

### Public Access Configuration

```hcl
resource "aws_s3_bucket_public_access_block" "accessible" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```

Configures the S3 bucket to allow public access by disabling public access blocking settings.

### Website File Upload

```hcl
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "app/index.html"
  acl          = "public-read"
  content_type = "text/html"
}
```

Uploads the `index.html` file from the `app` directory to the S3 bucket and sets its ACL to `public-read`.

### Bucket Ownership Controls

```hcl
resource "aws_s3_bucket_ownership_controls" "acl-ownership" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
```

Enables bucket ownership controls to enforce object ownership settings.

### Bucket ACL Configuration

```hcl
resource "aws_s3_bucket_acl" "acl-Enabling" {
  depends_on = [
    aws_s3_bucket_ownership_controls.acl-ownership,
    aws_s3_bucket_public_access_block.accessible,
  ]

  bucket = aws_s3_bucket.website.id
  acl    = "public-read"
}
```

Sets the bucket ACL to `public-read` to allow public access to objects.

### Static Website Hosting Configuration

```hcl
resource "aws_s3_bucket_website_configuration" "hosting" {
  bucket = aws_s3_bucket.website.id
  index_document {
    suffix = "index.html"
  }
}
```

Enables static website hosting for the S3 bucket and specifies the index document.

### Bucket Policy Configuration

```hcl
resource "aws_s3_bucket_policy" "s3-policy" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.iam_policy.json
}
```

Attaches a bucket policy allowing public access to the S3 bucket.

### IAM Policy Document

```hcl
data "aws_iam_policy_document" "iam_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.website.arn,
      "${aws_s3_bucket.website.arn}/*",
    ]
  }
}
```

Defines an IAM policy document allowing specific actions on the S3 bucket.

### Output

```hcl
output "websiteendpoint" {
    value = aws_s3_bucket.website.website_endpoint
}
```

Outputs the website endpoint URL.

## Usage

1. Clone this repository to your local machine.
2. Initialize Terraform in the repository directory:
   ```
   terraform init
   ```
3. Review and apply the Terraform plan:
   ```
   terraform apply
   ```
4. Access the deployed website using the provided endpoint URL.


## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvement, please feel free to open an issue or submit a pull request.



---

