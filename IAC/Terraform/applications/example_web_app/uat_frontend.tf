module "uat_s3" {
  count = terraform.workspace == "uat" ? 1 : 0

  source = "../../modules/s3_public"

  bucket_name = var.domain_name
}

module "uat_s3_route53_record" {
  count = terraform.workspace == "uat" ? 1 : 0

  source = "../../modules/route53"

  hosted_zone_name = var.hosted_zone_name
  domain_name      = var.domain_name
  record_name      = var.domain_name
  records_domain_name  = module.uat_s3[0].website_domain
  alias_hosted_zone_id    = module.uat_s3[0].hosted_zone_id
}
