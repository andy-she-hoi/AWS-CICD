resource "aws_s3_bucket" "s3_uat" {
  bucket        = "${var.bucket_name}"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "s3_uat" {
  bucket = aws_s3_bucket.s3_uat.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "s3_uat" {
  bucket = aws_s3_bucket.s3_uat.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "s3_uat" {
  bucket     = aws_s3_bucket.s3_uat.id
  policy     = data.aws_iam_policy_document.s3_public_read_policy.json
}

resource "aws_s3_bucket_cors_configuration" "s3_uat" {
  bucket = aws_s3_bucket.s3_uat.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

output "bucket_domain_name" {
  value = aws_s3_bucket.s3_uat.bucket_domain_name  
}

output "hosted_zone_id" {
  value = aws_s3_bucket.s3_uat.hosted_zone_id
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.s3_uat.website_endpoint
}

output "website_domain" {
  value = aws_s3_bucket_website_configuration.s3_uat.website_domain
}