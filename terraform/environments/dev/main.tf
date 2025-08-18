module "vpcmodule" {
  source               = "../../modules/vpc"
  vpc_cidr_block       = var.vpc_cidr_block
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment          = var.environment
  vpc_name             = var.vpc_name
  subnet_name          = var.subnet_name
}

module "acm" {
  source      = "../../modules/acm"
  environment = var.environment
  domain_name = var.domain_name
  subject_alternative_names = ["tm.${var.domain_name}"]
  zone_id     = "Z01959163GDPGUAO1SV9L"
  force_recreation = true
}

module "albmodule" {
  source            = "../../modules/alb"
  vpc_id            = module.vpcmodule.vpc_id
  public_subnet_ids = module.vpcmodule.public_subnet_ids
  environment       = var.environment
  certificate_arn   = module.acm.certificate_arn
  target_port       = var.container_port
}

module "route53module" {
  source       = "../../modules/route53"
  domain_name  = var.domain_name
  record_name  = var.record_name
  alb_dns_name = module.albmodule.alb_dns_name
  alb_zone_id  = module.albmodule.alb_zone_id
  environment  = var.environment
}

module "ecsclustermodule" {
  source      = "../../modules/ecs-cluster"
  environment = var.environment
}

module "ecsservicemodule" {
  source           = "../../modules/ecs-service"
  family           = var.family
  environment      = var.environment
  cluster_id       = module.ecsclustermodule.cluster_id
  service_name     = var.service_name
  container_name   = var.container_name
  container_image  = var.container_image
  container_port   = var.container_port
  desired_count    = var.desired_count
  cpu              = var.cpu
  memory           = var.memory
  target_group_arn = module.albmodule.target_group_arn
  subnets          = module.vpcmodule.private_subnet_ids
  vpc_id           = module.vpcmodule.vpc_id
  alb_sg_id        = module.albmodule.alb_sg_id
}

module "dynamodbmodule" {
  source      = "../../modules/dynamodb"
  environment = var.environment
}



