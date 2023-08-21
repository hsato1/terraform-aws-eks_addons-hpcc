variable  "aws_efs_access_point" {
    type = any
}

variable "efs_id" {
    type = string
}

variable "namespace" {
    type = string
    default = "hpcc"
}