output "cluster_id" {
    value = aws_eks_cluster.eks-cluster.id
}

output "cluster_name" {
    value = aws_eks_cluster.eks-cluster.name
}

output "certificate_authority" {
    value = aws_eks_cluster.eks-cluster.certificate_authority
}

output "endpoint" {
    value = aws_eks_cluster.eks-cluster.endpoint
}