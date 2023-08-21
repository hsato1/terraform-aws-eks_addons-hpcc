module "aws_vpc" {
  source          = "./aws_vpc"
  networking      = var.networking
  security_groups = var.security_groups
}

module "AWS_EKS" {
  source = "./aws_eks"
  aws_vpc_public_subnets_id = module.aws_vpc.public_subnets_id
  aws_vpc_private_subnets_id = module.aws_vpc.private_subnets_id
  aws_vpc_security_groups_id = module.aws_vpc.security_groups_id
  tags = local.tags
  depends_on = [module.aws_vpc]
}

module "aws_efs" {
  source = "./aws_efs"
  depends_on = [module.aws_vpc, module.AWS_EKS]
  efs_token = var.efs_token
  aws_vpc_id = module.aws_vpc.vpc_id
  aws_vpc_private_subnets_id = module.aws_vpc.private_subnets_id
  aws_vpc_security_groups_id = module.aws_vpc.security_groups_id
  tags = local.tags
}

module "kubernetes_storage" {
  depends_on = [
    module.aws_vpc,
    module.AWS_EKS,
    module.aws_efs,
    local_file.kubeconfig
    ]
    source = "./Kubernetes"
    efs_id = module.aws_efs.efs_id
    aws_efs_access_point = flatten(module.aws_efs.access_point)[0]
    namespace = var.namespace

} 

resource "helm_release" "hpcc" {
  # Doing this locally so this must be changed.
  name      = "hpcc"
  chart     = "/Users/satouhiroshiki/Desktop/HPCCSystemInternship/HPCC-Platform/helm/hpcc"
  namespace = "hpcc"
  timeout   = 300
  #repository = "https://hpcc-systems.github.io/helm-chart/"
  version = "latest"
  values = [
    "${file("./example/values-retained-efs.yaml")}"
  ]
  depends_on = [
    module.kubernetes_storage
  ]

}