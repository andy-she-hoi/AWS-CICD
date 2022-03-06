resource "aws_s3_bucket" "tf_remote_s3" {
  bucket = join("",[var.app_name, "-terraform-state"])
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "tf_remote_s3" {
  bucket = aws_s3_bucket.tf_remote_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_remote_s3" {
  bucket = aws_s3_bucket.tf_remote_s3.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "dynamodb_state_locking" {
  hash_key = "LockID"
  name     = join("",[var.app_name, "-terraform-state-locking"])
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}
