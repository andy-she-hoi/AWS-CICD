resource "aws_s3_bucket" "s3_redirect" {
  bucket = "${var.bucket_name}"  
  force_destroy = true
}

resource "aws_s3_bucket_acl" "s3_redirect" {
  bucket = aws_s3_bucket.s3_redirect.id  
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "s3_redirect" {
  bucket = aws_s3_bucket.s3_redirect.bucket

  redirect_all_requests_to {
    host_name = var.host_name
    protocol  = "http"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_redirect" {
  bucket = aws_s3_bucket.s3_redirect.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


output "bucket_id" {
  value = aws_s3_bucket.s3_redirect.id
}

output "bucket_arn" {
  value = aws_s3_bucket.s3_redirect.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.s3_redirect.bucket_domain_name
}

output "hosted_zone_id" {
  value = aws_s3_bucket.s3_redirect.hosted_zone_id
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.s3_redirect.website_endpoint
}

output "website_domain" {
  value = aws_s3_bucket_website_configuration.s3_redirect.website_domain
}