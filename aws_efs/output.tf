output "access_point" {
    value = aws_efs_access_point.ap[*]
}

output "efs_id" {
    value = aws_efs_file_system.efs.id
}