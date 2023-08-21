variable "efs_token" {
  type    = string
  default = "main"
}
variable "aws_vpc_id" {
    type = string
    description = "VPC id"
}

variable "aws_vpc_private_subnets_id" {
    type = list(string)
    description = "VPC private subnet ids"
}

variable "aws_vpc_security_groups_id" {
    type = list(string)
    description = "aws_vpc_security_groupds_id"
}
variable "tags" {
  description = "Additional resource tags."
  type        = map(string)

  default = {
    "description" = "Testing"
  }
}