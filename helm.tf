resource "helm_release" "hpcc" {
  # Doing this locally so this must be changed.
  name      = "hpcc"
  chart     = "/Users/satouhiroshiki/Desktop/HPCCSystemInternship/HPCC-Platform/helm/hpcc"
  namespace = var.namespace
  timeout   = 300
  #repository = "https://hpcc-systems.github.io/helm-chart/"
  version = "latest"
  values = [
    "${file("./example/values-retained-efs.yaml")}"
  ]
  depends_on = [
    kubernetes_persistent_volume_claim.pvc
  ]

}