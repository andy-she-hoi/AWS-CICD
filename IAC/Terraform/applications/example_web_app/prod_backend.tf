module "prod_ecr" {
  count = terraform.workspace == "prod" ? 1 : 0

  source = "../../modules/ecr"
  
  repository_name = var.app_name
}

module "prod_networking" {

  source = "../../modules/networking"
  
  app_name           = var.app_name
  environment        = var.environment
  cidr_block         = var.cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  nat_numbers        = var.nat_numbers
}

module "prod_alb_acm" {
  count = terraform.workspace == "prod" ? 1 : 0

  source = "../../modules/acm"

  providers = {
    aws = aws
  }

  domain_name               = var.domain_name
  subject_alternative_names = var.alb_domain
  zone_id                   = module.prod_alb_route53_record[0].zone_id
}

module "prod_alb" {
  count = terraform.workspace == "prod" ? 1 : 0

  source = "../../modules/alb"

  app_name           = var.app_name
  environment        = var.environment
  health_check_path  = var.health_check_path
  vpc_id             = module.prod_networking.vpc_id
  public_subnets_ids = module.prod_networking.public_subnets_ids
  alb_tls_cert_arn   = module.prod_alb_acm[0].certificate_arn
}

module "prod_alb_route53_record" {
  count = terraform.workspace == "prod" ? 1 : 0

  source = "../../modules/route53"
  
  hosted_zone_name     = var.hosted_zone_name
  domain_name          = var.domain_name
  record_name          = var.alb_domain
  records_domain_name  = module.prod_alb[0].alb_dns_name
  alias_hosted_zone_id = module.prod_alb[0].alb_hosted_zone_id
}

module "prod_ecs" {
    source                      = "../../modules/ecs"

    app_name                    = var.app_name
    environment                 = var.environment
    vpc_id                      = module.prod_networking.vpc_id
    subnets_ids                 = module.prod_networking.private_subnets_ids
    alb_security_group_id       = module.prod_alb[0].alb_security_group_id
    alb_target_group_arn        = module.prod_alb[0].alb_target_group_arn
    container_port              = var.container_port
    container_cpu               = var.container_cpu
    container_memory            = var.container_memory
    ecs_desired_count           = var.ecs_desired_count
    container_image             = join("/", [module.prod_ecr[0].repository_url, var.image_tag])
    assign_public_ip            = var.assign_public_ip
    avg_cpu_target              = var.avg_cpu_target
    avg_memory_target           = var.avg_memory_target
}