# Cloudfront distribution for main s3 site. 
resource "aws_cloudfront_origin_access_identity" "cloudfront_oai" {
  comment = "Cloudfront_origin_access_identity_${var.bucket_name}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.bucket_domain_name
    origin_id   = "S3-.${var.bucket_name}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["${var.bucket_name}", "${var.subdomain_name}"]

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }
  
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["HEAD", "GET", "OPTIONS"]
    target_origin_id = "S3-.${var.bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.domain_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

}

resource "aws_s3_bucket_policy" "s3_cloudfront_bucket" {
  bucket     = "${var.bucket_id}"
  policy     = data.aws_iam_policy_document.s3_cloudfront_read_policy.json
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}