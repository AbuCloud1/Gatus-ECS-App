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

data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

module "acm" {
  source      = "../../modules/acm"
  environment = var.environment
  domain_name = var.domain_name
  zone_id     = data.aws_route53_zone.selected.zone_id
}

module "albmodule" {
  source            = "../../modules/alb"
  vpc_id            = module.vpcmodule.vpc_id
  public_subnet_ids = module.vpcmodule.public_subnet_ids
  environment       = var.environment
  certificate_arn   = module.acm.certificate_arn
}

module "route53module" {
  source      = "../../modules/route53"
  domain_name = var.domain_name
  record_name = var.record_name
  alb_dns_name = module.albmodule.alb_dns_name
  alb_zone_id = module.albmodule.alb_zone_id
  environment = var.environment
}

module "ecs_cluster" {
  source      = "../../modules/ecs-cluster"
  environment = var.environment
}

module "ecs_service" {
  source           = "../../modules/ecs-service"
  family           = var.family
  cluster_id       = module.ecs_cluster.cluster_id
  service_name     = var.service_name
  vpc_id           = module.vpcmodule.vpc_id
  subnets          = module.vpcmodule.private_subnet_ids
  target_group_arn = module.albmodule.target_group_arn
  environment      = var.environment
  container_image  = var.container_image
  container_name   = var.container_name
  container_port   = var.container_port
  desired_count    = var.desired_count
  cpu              = var.cpu
  memory           = var.memory
  alb_sg_id        = module.albmodule.alb_sg_id
}