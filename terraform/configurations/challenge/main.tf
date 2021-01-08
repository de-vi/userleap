module "networking" {
  source               = "../../modules/networking"
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  region               = var.region
  availability_zones   = var.availability_zones
}

module "application" {
  source              = "../../modules/application"
  environment         = var.environment
  service_name        = var.service_name
  vpc_id              = module.networking.vpc_id
  public_subnet_ids   = module.networking.public_subnet_ids
  private_subnet_ids  = module.networking.private_subnet_ids
}
