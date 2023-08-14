# resource "helm_release" "awsstorage" {
#   chart = "/Users/satouhiroshiki/Desktop/aws-eks/hpcc-efs-static-pv"
#   #chart = "/Users/satouhiroshiki/Desktop/HPCCSystemInternship/HPCC-Platform/helm/examples/efs/hpcc-efs-static-pv"
#   name = "awsstorage"
#   #repository = ""
#   depends_on = [
#     aws_eks_cluster.eks-cluster,
#     module.aws_vpc,
#     aws_efs_access_point.ap,
#     kubernetes_storage_class.aws-sc

#   ]
# }

resource "helm_release" "hpcc" {
  # Doing this locally so this must be changed.
  name = "hpcc-1"
  chart      = "/Users/satouhiroshiki/Desktop/HPCCSystemInternship/HPCC-Platform/helm/hpcc"
  namespace = "hpcc"
  timeout = 180
  #repository = ""
  #version    = "9.2.10"
  values = [
    "${file("./values-retained-efs.yaml")}"
  ]
  depends_on = [
    kubernetes_persistent_volume_claim.pvc
  ]
#   depends_on = [
#     module.eks,
#     module.aws_vpc,
#     helm_release.awsstorage,
#     helm_release.aws-efs-csi-driver
#   ]
}