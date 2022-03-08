data "aws_route53_zone" "hosted_zone" {
  name = join("", [${var.domain}, "."])
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.record_name

  type    = "A"

  alias {
    name    = var.records_domain_name
    zone_id = var.alias_hosted_zone_id
    evaluate_target_health = true
  }
}

output "zone_id" {
  value = data.aws_route53_zone.hosted_zone.zone_id
}
