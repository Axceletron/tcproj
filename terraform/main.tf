provider "aws" { 
  region= "us-east-1"
  secret_key = var.sec_key
  access_key = var.acc_key
}

data "aws_availability_zones" "example" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
locals {
  cidrs= cidrsubnets("10.0.0.0/16",8,8)
}
locals {
  cidr_blk_pub =cidrsubnets(local.cidrs[0],2,2,2)
  cidr_blk_pvt=cidrsubnets(local.cidrs[1],2,2,2)
  azone = [for i in range(3): data.aws_availability_zones.example.names[i]]
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = local.azone
  private_subnets = local.cidr_blk_pvt
  public_subnets  = local.cidr_blk_pub
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/Practise" = "shared"
    "kubernetes.io/role/elb" = 1
  }
  enable_nat_gateway = true
  enable_vpn_gateway = true
  create_flow_log_cloudwatch_iam_role = true
  flow_log_destination_type = "cloud-watch-logs"
  create_flow_log_cloudwatch_log_group = true
  single_nat_gateway = true
  enable_flow_log = true
  tags = {
     Name = "${var.project-name}-VPC" 
    Environment = var.env
    Project = var.project-name
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}
/*
module "my-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.18"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  cluster_enabled_log_types = ["api"]
  cluster_endpoint_private_access = true

  tags = {
     Name = "${var.project-name}-EKS" 
    Environment = var.env
    Project = var.project-name
  }
  worker_groups = [
    {
      instance_type = "t3.small"
      asg_max_size  = 1
    }
  ]
  map_users = var.map_user

}

output "cl_ep" {
  value = module.my-cluster.cluster_endpoint
}

output "config" {
  value = module.my-cluster.kubeconfig
}
*/