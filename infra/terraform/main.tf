module "network" {
  source = "./modules/network"

  project_name          = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  app_subnet_cidrs      = var.app_subnet_cidrs
  data_subnet_cidrs     = var.data_subnet_cidrs
  nat_gateway_strategy = var.nat_gateway_strategy
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.network.vpc_id
  enable_https = var.acm_certificate_arn != null
}

module "application" {
  source = "./modules/application"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  app_subnet_ids        = module.network.app_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  app_security_group_id = module.security.app_security_group_id
  aws_region            = var.aws_region
  ecr_repository_arn    = module.release.repository_arn
  ecr_repository_url    = module.release.repository_url
  database_endpoint     = module.database.hostname
  database_secret_arn   = module.database.application_secret_arn
  certificate_arn       = var.acm_certificate_arn
  domain_name           = var.application_domain_name
  instance_type         = var.app_instance_type
  min_size              = var.app_min_size
  desired_capacity      = var.app_desired_capacity
  max_size              = var.app_max_size
}

module "database" {
  source = "./modules/database"

  project_name               = var.project_name
  environment                = var.environment
  subnet_ids                 = module.network.data_subnet_ids
  database_security_group_id = module.security.database_security_group_id
  instance_class             = var.database_instance_class
  master_username            = var.database_master_username
}

module "release" {
  source = "./modules/release"

  project_name      = var.project_name
  environment       = var.environment
  github_repository = var.github_repository
  github_branch     = var.github_branch
}
