variable "app_name" {
  description = "the name of your app"
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
}

variable "public_subnets" {
  description = "a list of CIDRs for public subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
}

variable "private_subnets" {
  description = "a list of CIDRs for private subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
}

variable "nat_numbers" {
  description = "the number of NAT gateway that you want to create, please notice that one NAT gateway can be used for multiple subnets"
}