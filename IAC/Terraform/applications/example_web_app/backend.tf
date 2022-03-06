terraform {
  backend "s3" {
    encrypt              = true
    region               = "ap-southeast-2"
    bucket               = "skipq-terraform-state"
    workspace_key_prefix = "skipq"
    key                  = "skipq.tfstate"
    dynamodb_table       = "skipq-terraform-state-locking" 
    profile              = "default"
  }
}
