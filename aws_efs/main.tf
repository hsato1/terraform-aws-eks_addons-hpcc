resource "aws_efs_file_system" "efs" {
  creation_token = var.efs_token
  tags           = var.tags
}
resource "aws_efs_mount_target" "efs_target" {
  depends_on = [
    aws_security_group.efs,
    aws_efs_file_system.efs
  ]
  file_system_id = aws_efs_file_system.efs.id
  for_each       = try(toset(flatten(var.aws_vpc_private_subnets_id)), [])
  subnet_id      = each.key
  #subnet_id       = module.aws_vpc.private_subnets_id[0][0]
  security_groups = flatten([aws_security_group.efs.id, var.aws_vpc_security_groups_id])

}

resource "aws_security_group" "efs" {
  name   = "efs-security-group"
  vpc_id = var.aws_vpc_id
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

