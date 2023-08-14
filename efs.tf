resource "aws_efs_file_system" "efs" {
  creation_token = var.efs_token
  tags           = local.tags
}
resource "aws_efs_mount_target" "efs_target" {
  depends_on = [
    module.aws_vpc,
    aws_security_group.efs,
    aws_efs_file_system.efs
  ]
  file_system_id = aws_efs_file_system.efs.id
  for_each       = try(toset(flatten(module.aws_vpc.private_subnets_id)), [])
  subnet_id      = each.key
  #subnet_id       = module.aws_vpc.private_subnets_id[0][0]
  security_groups = flatten([aws_security_group.efs.id, module.aws_vpc.security_groups_id])

}

resource "aws_security_group" "efs" {
  name   = "efs-security-group"
  vpc_id = module.aws_vpc.vpc_id
  ingress {
    description = "efs"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "efs"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_access_point" "ap" {

  for_each       = local.access_points
  file_system_id = aws_efs_file_system.efs.id
  posix_user {
    gid = each.value.posix_user.gid
    uid = each.value.posix_user.uid
  }
  #posix_user = each.value.posix_user
  root_directory {
    path = each.value.root_directory.path
    creation_info {
      owner_gid   = each.value.root_directory.creation_info.owner_gid
      owner_uid   = each.value.root_directory.creation_info.owner_uid
      permissions = each.value.root_directory.creation_info.permissions
    }
  }
  #root_directory = each.value.root_directory
  tags = each.value.tags
  depends_on = [
    aws_efs_mount_target.efs_target,
    aws_efs_file_system.efs
  ]
}

resource "kubernetes_storage_class" "aws-sc" {
  metadata {
    name = "awsstorage"
  }
  storage_provisioner = "efs.csi.aws.com"

  # parameters = {
  #   provisioningMode = "efs-ap",
  #   fileSystemId     = aws_efs_file_system.efs.id
  #   directoryPerms   = "777"
  # }
  depends_on = [
    aws_efs_mount_target.efs_target,
    aws_efs_access_point.ap
    ]
}

resource "kubernetes_persistent_volume" "wordpress" {
  metadata {
    name = "efs-pv"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    volume_mode = "Filesystem"
    access_modes = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "aws-efs-static"
    persistent_volume_source {
      csi {
        driver = "efs.csi.aws.com"
        volume_handle = aws_efs_file_system.efs.id
      }
    }
  }
  depends_on = [ 
    kubernetes_storage_class.aws-sc
     ]
}

resource "kubernetes_persistent_volume" "persisten_volumes" {
  depends_on = [kubernetes_storage_class.aws-sc]
  for_each = {
    for plane in local.planes : plane.name => plane
  }
  #for_each =  local.planes
  metadata{
    name = "${each.value.name}-${kubernetes_storage_class.aws-sc.metadata[0].name}-hpcc-efs-pv"
  }
  
  spec {
    capacity = {
      storage = each.value.size
    }
    volume_mode = "Filesystem"
    access_modes = try(each.value.rwmany, false) ? ["ReadWriteMany"] : ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = kubernetes_storage_class.aws-sc.metadata[0].name
    persistent_volume_source {
      csi {
        driver = "efs.csi.aws.com"
        volume_handle = aws_efs_file_system.efs.id
      }
    }
  }
}


resource "kubernetes_persistent_volume_claim" "pvc" {
  for_each = {
    for plane in local.planes : plane.name => plane
  }
  metadata {
    name = "${each.value.name}-${kubernetes_storage_class.aws-sc.metadata[0].name}-hpcc-efs-pvc"
    namespace = "hpcc"
  }
  spec {
    access_modes = try(each.value.rwmany, false) ? ["ReadWriteMany"] : ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class.aws-sc.metadata[0].name
    resources {
      requests = {
        storage = each.value.size
      }
    }
    volume_name = "${each.value.name}-${kubernetes_storage_class.aws-sc.metadata[0].name}-hpcc-efs-pv"
  }
  depends_on = [kubernetes_persistent_volume.persisten_volumes]
}





# resource "kubernetes_persistent_volume" "dali" {
#   metadata {
#     name = "dali-pv"
#   }
#   spec {
#     capacity = {
#       storage = "1Gi"
#     }
#     volume_mode = "Filesystem"
#     access_modes = ["ReadWriteMany"]
#     persistent_volume_reclaim_policy = "Retain"
#     storage_class_name = "aws-efs-auto"
#     persistent_volume_source {
#       csi {
#         driver = "efs.csi.aws.com"
#         volume_handle = aws_efs_file_system.efs.id
#       }
#     }
#   }
#   depends_on = [ kubernetes_storage_class.aws-sc ]
# }

# resource "kubernetes_persistent_volume_claim" "wordpress" {
#   metadata {
#     name = "wordpress-pvc"
#     #namespace = "staging"
#   }
#   spec {
#     access_modes = ["ReadWriteMany"]
#     storage_class_name = kubernetes_storage_class.aws-sc.metadata[0].name
#     resources {
#       requests = {
#         storage = "5Gi"
#       }
#     }
    
#   }
#   depends_on = [ kubernetes_persistent_volume.wordpress ]
# }

# resource "kubernetes_persistent_volume_claim" "dali" {
#   metadata {
#     name = "dali-aws-efs-auto-pvc"
#   }
#   spec {
#     access_modes= ["ReadWriteMany"]
#     storage_class_name = kubernetes_storage_class.aws-sc.metadata[0].name
#     resources {
#       requests = {
#         storage = "1Gi"
#       }
#     }
#     volume_name = "${kubernetes_persistent_volume.dali.metadata.0.name}"
#   }
#   depends_on = [kubernetes_persistent_volume.wordpress]
# }