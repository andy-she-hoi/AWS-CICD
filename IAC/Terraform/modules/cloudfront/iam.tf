data "aws_iam_policy_document" "s3_cloudfront_read_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn]
    }
  }
  
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${var.bucket_arn}"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn]
    }
  }
}