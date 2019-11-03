locals {
  subnet_max = 4
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.17.0"

  name = var.vpc_name
  cidr = var.cidr
  azs  = slice(data.aws_availability_zones.this.names, 0, var.az_count)

  // Take all even /21 blocks for each AZ and split it up into two /22's for the public and spare subnets
  public_subnets = [for id in range(var.az_count) : cidrsubnet(var.cidr, 4, local.subnet_max * id)]
  // Use all odd /21 blocks for private subnets
  private_subnets = [for id in range(var.az_count) : cidrsubnet(var.cidr, 3, 2 * id + 1)]

  private_subnet_tags = var.private_subnet_tags
  public_subnet_tags  = var.public_subnet_tags

  enable_nat_gateway     = true
  single_nat_gateway     = ! var.production
  one_nat_gateway_per_az = var.production

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  vpc_tags = var.vpc_tags

  tags = {
    terraform = true
  }
}

module "eks" {
  source = "github.com/terraform-aws-modules/terraform-aws-eks?ref=v6.0.2"

  config_output_path = "./.terraform/locals/"

  cluster_name    = var.cluster_name
  cluster_version = "1.14"

  vpc_id = module.vpc.vpc_id

  subnets = module.vpc.private_subnet_arns

  worker_groups = [
    {
      name          = "blue"
      instance_type = "t3.small"
      ami_id        = data.aws_ami.eks_worker_1_14.id

      asg_desired_capacity = 1
    },
    {
      name          = "green"
      instance_type = "t3.small"
      ami_id        = data.aws_ami.eks_worker_1_14.id

      asg_desired_capacity = 0
    },
  ]

  tags = {
    terraform   = true
    environment = "nonprod"
  }
}