environment                         = "challenge"
region                              = "us-west-1"

availability_zones                  = ["us-west-1a", "us-west-1c"]
vpc_cidr                            = "10.0.0.0/16"
private_subnets_cidr                = ["10.0.10.0/24", "10.0.20.0/24"]
public_subnets_cidr                 = ["10.0.1.0/24", "10.0.2.0/24"]

service_name                        = "woogie-bucket"