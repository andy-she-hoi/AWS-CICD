domain_name        = "skipq.link"

hosted_zone_name   = "skipq.link"

subdomain_name     = "www.skipq.link"

alb_domain         = "alb.skipq.link"

app_name           = "skipq"

environment        = "prod"

# nat_numbers        = 2 # default 1 

cidr_block         = "10.0.0.0/16"

availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]

public_subnets     = ["10.0.1.0/24", "10.0.3.0/24"]

private_subnets    = ["10.0.2.0/24", "10.0.4.0/24"]

health_check_path  = "/api/health" # ask the dev team

container_cpu      = 0.25

container_memory   = 0.5

image_tag          = "latest"

container_port     = 8081

ecs_desired_count  = 2

assign_public_ip   = true

avg_cpu_target     = 80

avg_memory_target  = 80
