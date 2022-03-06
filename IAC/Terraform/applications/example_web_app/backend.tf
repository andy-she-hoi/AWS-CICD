terraform {
  backend "s3" {
    encrypt              = true
    region               = "ap-southeast-2"
    bucket               = "APP_NAME-terraform-state"
    workspace_key_prefix = "APP_NAME"
    key                  = "APP_NAME.tfstate"
    dynamodb_table       = "APP_NAME-terraform-state-locking" 
    profile              = "default"
  }
}
