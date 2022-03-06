provider "aws" {
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "cloudfront_acm"
  region = "us-east-1"
}