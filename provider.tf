terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = [local.config_path]
  shared_credentials_files = [local.creds_path]
  profile                  = local.profile
}

data "aws_eks_cluster_auth" "this" {
  name = module.AWS_EKS.cluster_id
}

provider "kubernetes" {
  host                   = module.AWS_EKS.endpoint
  cluster_ca_certificate = base64decode(module.AWS_EKS.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  # load_config_file       = false
}

# provider "kubectl" {
#   host                   =module.AWS_EKS.endpoint
#   cluster_ca_certificate = base64decode(module.AWS_EKS.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.this.token
#   load_config_file       = false
# }

provider "helm" {

  kubernetes {
   host                   =module.AWS_EKS.endpoint
  cluster_ca_certificate = base64decode(module.AWS_EKS.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  }

}


module "eks-kubeconfig" {
  source  = "hyperbadger/eks-kubeconfig/aws"
  version = "1.0.0"

  depends_on = [
    module.AWS_EKS,
    module.aws_vpc
    ]
  cluster_id = module.AWS_EKS.cluster_id
}

resource "local_file" "kubeconfig" {
  content  = module.eks-kubeconfig.kubeconfig
  filename = "kubeconfig_eks-cluster"
}

