module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"  # ✅ Compatible with AWS provider ~> 5.0

  name   = "super-mario-vpc"
  cidr   = "10.0.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  map_public_ip_on_launch = true

  enable_nat_gateway = false
  single_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"  # ✅ Compatible with AWS provider ~> 5.0

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  subnet_ids = module.vpc.public_subnets
  vpc_id     = module.vpc.vpc_id

  eks_managed_node_groups = {
    free_tier_nodes = {
      desired_size   = 2
      max_size       = 2
      min_size       = 1

      instance_types = ["t2.micro"]
      capacity_type  = "ON_DEMAND"
    }
  }
  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = ["18.175.206.135/32"] # if the jenkins master closed and opened again its ip will be changed so you must  change it here also
}

