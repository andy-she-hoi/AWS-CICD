module "prod_s3" {
  count = terraform.workspace == "prod" ? 1 : 0

  source = "../../modules/s3_cloudfront"

  bucket_name = var.domain_name
}

module "prod_s3_redirect" {
  count = terraform.workspace == "prod" ? 1 : 0

  source = "../../modules/s3_redirect"

  bucket_name = var.subdomain_name
  host_name   = var.domain_name
}

module "prod_acm" {
  count = terraform.workspace == "prod" ? 1 : 0

  source = "../../modules/acm"

  providers = {
    aws = aws.cloudfront_acm
  }

  domain_name               = var.domain_name
  subject_alternative_names = var.subdomain_name
  zone_id                   = module.prod_cloudfront_route53_record[0].zone_id
}

module "prod_cloudfront" {
  count = terraform.workspace == "prod" ? 1 : 0

  source = "../../modules/cloudfront"

  bucket_name             = var.domain_name
  subdomain_name          = var.subdomain_name
  bucket_website_endpoint = module.prod_s3[0].website_endpoint
  bucket_arn              = module.prod_s3[0].bucket_arn
  bucket_id               = module.prod_s3[0].bucket_id
  bucket_domain_name      = module.prod_s3[0].bucket_domain_name
  domain_certificate_arn  = module.prod_acm[0].certificate_arn  
}

module "prod_cloudfront_route53_record" {
  count = terraform.workspace == "prod" ? 1 : 0

  source = "../../modules/route53"
  
  hosted_zone_name     = var.hosted_zone_name
  domain_name          = var.domain_name
  record_name          = var.domain_name
  records_domain_name  = module.prod_cloudfront[0].cloudfront_domain_name
  alias_hosted_zone_id = module.prod_cloudfront[0].cloudfront_hosted_zone_id
}

module "prod_redirect_route53_record" {
  count = terraform.workspace == "prod" ? 1 : 0

  source = "../../modules/route53"
  
  hosted_zone_name     = var.hosted_zone_name
  domain_name          = var.domain_name
  record_name          = var.subdomain_name
  records_domain_name  = module.prod_cloudfront[0].cloudfront_domain_name
  alias_hosted_zone_id = module.prod_cloudfront[0].cloudfront_hosted_zone_id
}
