resource "kubectl_manifest" "NS" {
  yaml_body = <<-EOF
kind: Namespace
apiVersion: v1
metadata:
 name: hpcc
EOF
}

# resource "kubectl_manifest" "SC" {
#     depends_on = [aws_efs_file_system.efs]
# yaml_body = <<-EOF
# kind: StorageClass
# apiVersion: storage.k8s.io/v1
# metadata:
#   name: aws-efs-static
# provisioner: efs.csi.aws.com
# EOF
# }
/*

resource "kubectl_manifest" "PV" {
    depends_on = [
        aws_efs_file_system.efs,
        aws_efs_access_point.ap,
        kubectl_manifest.SC,
        kubectl_manifest.NS
    ]
    count = length(local.planes)

    yaml_body = <<-EOF
    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: ${local.planes[count.index].name}-awsstorage-hpcc-efs-pv
    spec:
      accessModes:
      - "${try(local.planes[count.index].rwmany, false) ? "ReadWriteMany" : "ReadWriteOnce"}"
      capacity:
        storage: "${local.planes[count.index].size}"
      csi:
        driver: efs.csi.aws.com
        volumeHandle: "${aws_efs_file_system.efs.id}::${aws_efs_access_point.ap[local.planes[count.index].name].id}"
      persistentVolumeReclaimPolicy: Retain
      storageClassName: aws-efs-static
      volumeMode: Filesystem
    EOF
}



resource "kubectl_manifest" "PVC" {
    depends_on = [
        kubectl_manifest.PV
        ]

    count = length()
    yaml_body = <<-EOF
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: "${each.value}"-awsstorage-hpcc-efs-pvc
    spec:
      volumeName: "${each.value}"-awsstorage-hpcc-efs-pv
      volumeMode: Filesystem
      accessModes:
      - "${try(each.value.rwmany, false) ? "ReadWriteMany" : "ReadWriteOnce"}"
      storageClassName: aws-efs-static
      resources:
        requests:
          storage: "${each.value.size}"
    EOF
}

*/
# resource "kubectl_manifest" "PV" {

#     yaml_body = <<-EOF
#     apiVersion: v1
#     kind: PersistentVolume
#     metadata:
#       name: 
#     EOF
# }