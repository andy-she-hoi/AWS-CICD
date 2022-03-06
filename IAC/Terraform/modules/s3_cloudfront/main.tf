resource "aws_s3_bucket" "s3_cloudfront" {
  bucket = "${var.bucket_name}"  
  force_destroy = true
}

resource "aws_s3_bucket_acl" "s3_cloudfront" {
  bucket = aws_s3_bucket.s3_cloudfront.id  
  acl    = "private"
}

resource "aws_s3_bucket_cors_configuration" "s3_cloudfront" {
  bucket = aws_s3_bucket.s3_cloudfront.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "HEAD"]
    allowed_origins = [join("", ["https://", "${var.bucket_name}"])]
    expose_headers  = ["ETag"]
    max_age_seconds = 3600
  }
}

resource "aws_s3_bucket_website_configuration" "s3_cloudfront" {
  bucket = aws_s3_bucket.s3_cloudfront.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_cloudfront" {
  bucket = aws_s3_bucket.s3_cloudfront.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


output "bucket_id" {
  value = aws_s3_bucket.s3_cloudfront.id
}

output "bucket_arn" {
  value = aws_s3_bucket.s3_cloudfront.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.s3_cloudfront.bucket_domain_name
}

output "hosted_zone_id" {
  value = aws_s3_bucket.s3_cloudfront.hosted_zone_id
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.s3_cloudfront.website_endpoint
}

output "website_domain" {
  value = aws_s3_bucket_website_configuration.s3_cloudfront.website_domain
}