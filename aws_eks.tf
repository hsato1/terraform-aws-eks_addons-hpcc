resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.EKSClusterRole.arn
  version  = "1.25"
  vpc_config {
    subnet_ids         = flatten([module.aws_vpc.public_subnets_id, module.aws_vpc.private_subnets_id])
    security_group_ids = flatten(module.aws_vpc.security_groups_id)
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy
  ]
}


resource "aws_eks_addon" "efs-csi-driver" {
  addon_name   = "aws-efs-csi-driver"
  cluster_name = aws_eks_cluster.eks-cluster.name
  tags         = local.tags
}
resource "aws_eks_addon" "coredns" {

  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "coredns"
  tags         = local.tags

}

resource "aws_eks_node_group" "node-ec2" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = var.ec2-node.node_group_name
  node_role_arn   = aws_iam_role.NodeGroupRole.arn
  subnet_ids      = flatten(module.aws_vpc.private_subnets_id)

  scaling_config {
    desired_size = var.ec2-node.scaling_config_desired_size
    max_size     = var.ec2-node.scaling_config_max_size
    min_size     = var.ec2-node.scaling_config_min_size
  }


  ami_type       = var.ec2-node.ami_type
  instance_types = var.ec2-node.instance_types
  capacity_type  = var.ec2-node.capacity_type
  disk_size      = var.ec2-node.disk_size

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
  ]
}