
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "fv-live-deasfio"
    key    = "terraform/state.tfstate"
    region = "us-east-2"
  }


}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}



# this module is used to create a VPC with public and private subnets, NAT gateway, and VPN gateway. It also tags all resources with the provided project tags.
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.aws_vpc_name
  cidr = var.aws_vpc_cidr

  azs             = var.aws_vpc_azs
  private_subnets = var.aws_vpc_private_subnets
  public_subnets  = var.aws_vpc_public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true # 🔥 ESSENCIAL

  enable_vpn_gateway = true

  tags = merge(
    var.aws_project_tags,
    {
      "kubernetes.io/cluster/${var.aws_eks_name}" = "shared"
    }
  )

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.aws_eks_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.aws_eks_name}" = "shared"
  }
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.aws_eks_name
  kubernetes_version = var.aws_eks_version

  endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    general-purpose = {
      instance_types = var.aws_eks_managed_node_groups_instance_types

      min_size     = 1
      max_size     = 3
      desired_size = 2

      tags = var.aws_project_tags
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = var.aws_project_tags
}
