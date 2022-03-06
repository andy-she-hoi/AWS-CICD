data "aws_iam_policy_document" "s3_public_read_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    
    actions   = ["s3:GetObject"]
    
    resources = [
      "${aws_s3_bucket.s3_uat.arn}/*"
    ]
  }
}