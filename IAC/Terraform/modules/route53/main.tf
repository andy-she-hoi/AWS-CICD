# data "aws_route53_zone" "hosted_zone" {
#   name = var.domain_name
# }
variable zone_id {
  default = "Z023651229KFITP28W249"
}

resource "aws_route53_record" "record" {
  zone_id = var.zone_id # data.aws_route53_zone.hosted_zone.zone_id
  name    = var.record_name

  type    = "A"

  alias {
    name    = var.records_domain_name
    zone_id = var.alias_hosted_zone_id
    evaluate_target_health = true
  }
}

output "zone_id" {
  value = var.zone_id # data.aws_route53_zone.hosted_zone.zone_id
}
