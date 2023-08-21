resource "kubernetes_namespace" "NS"{
    metadata {
    annotations = {
      name = var.namespace
        }
        name = var.namespace
    }
    
}
resource "kubernetes_storage_class" "aws-sc" {

  metadata {
    name = "aws-efs-static"
  }

  storage_provisioner = "efs.csi.aws.com"

}

resource "kubernetes_persistent_volume" "persisten_volumes" {
  depends_on = [
    kubernetes_namespace.NS,
    kubernetes_storage_class.aws-sc
  ]

  count = length(local.planes)

  metadata {
    name = "${local.planes[count.index].name}-awsstorage-hpcc-efs-pv"
  }

  spec {
    capacity = {
      storage = local.planes[count.index].size
    }
    volume_mode                      = "Filesystem"
    access_modes                     = try(local.planes[count.index].rwmany, false) ? ["ReadWriteMany"] : ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = kubernetes_storage_class.aws-sc.metadata[0].name
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        #volume_handle = "${var.efs_id}::${aws_efs_access_point.ap[local.planes[count.index].name].id}"
        volume_handle = "${var.efs_id}::${var.aws_efs_access_point[local.planes[count.index].name].id}"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "pvc" {
  depends_on = [
    kubernetes_namespace.NS,
    kubernetes_storage_class.aws-sc,
    kubernetes_persistent_volume.persisten_volumes
  ]
  count = length(local.planes)
  metadata {
    name      = "${local.planes[count.index].name}-awsstorage-hpcc-efs-pvc"
    namespace = "hpcc"
  }
  spec {
    access_modes       = try(local.planes[count.index].rwmany, false) ? ["ReadWriteMany"] : ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class.aws-sc.metadata[0].name
    resources {
      requests = {
        storage = local.planes[count.index].size
      }
    }
    volume_name = "${local.planes[count.index].name}-awsstorage-hpcc-efs-pv"
  }
}


