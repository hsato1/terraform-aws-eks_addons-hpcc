provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = [local.config_path]
  shared_credentials_files = [local.creds_path]
  profile                  = local.profile
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.eks-cluster.id
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {

  kubernetes {
    host                   = aws_eks_cluster.eks-cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.this.token
  }

}

module "eks-kubeconfig" {
  source  = "hyperbadger/eks-kubeconfig/aws"
  version = "1.0.0"

  depends_on = [
    aws_eks_cluster.eks-cluster,
    aws_eks_node_group.node-ec2,
  module.aws_vpc]
  cluster_id = aws_eks_cluster.eks-cluster.id
}

resource "local_file" "kubeconfig" {
  content  = module.eks-kubeconfig.kubeconfig
  filename = "kubeconfig_eks-cluster"
}