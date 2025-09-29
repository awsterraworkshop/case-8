module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "demo-eks-cluster"
  kubernetes_version = "1.32"

  # Optional
    endpoint_public_access = true 
  endpoint_private_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    demo-eks-nodes = {
        ami_type = "AL2_x86_64" # Amazon Linux 2
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_types = ["t3.medium"]

      disk_size = 20

      key_name = "awsdev" # Replace with your actual key pair name

      additional_tags = {
        Name = "demo-eks-node"
      }
    }
  }
  addons = {
    vpc-cni = {
      most_recent = true
      configuration_values = jsonencode({
        "WARM_PREFIX_TARGET" = "1"
        "ENABLE_PREFIX_DELEGATION" = true
      })
    }
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    aws_load_balancer_controller = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

