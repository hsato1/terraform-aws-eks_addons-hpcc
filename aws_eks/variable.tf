# variable "admin" {
#   description = "Information for the user who administers the deployment."
#   type = object({
#     name  = string
#     email = string
#   })
#   validation {
#     condition = try(
#       regex("hpccdemo", var.admin.name) != "hpccdemo", true
#       ) && try(regex("hpccdemo", var.admin.email) != "hpccdemo", true
#     ) && try(regex("@example.com", var.admin.email) != "@example.com", true)
#     error_message = "Your name and email are required in the admin block and must not contain hpccdemo or @example.com."
#   }

# }
variable "cluster_name" {
  type    = string
  default = "eks-cluster"
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)

  default = {
    "description" = "Testing"
  }
}

variable "aws_vpc_public_subnets_id" {
    type = list(string)
    description = "VPC puublic subnet ids"
}

variable "aws_vpc_private_subnets_id" {
    type = list(string)
    description = "VPC private subnet ids"
}

variable "aws_vpc_security_groups_id" {
    type = list(string)
    description = "aws_vpc_security_groupds_id"
}

variable "ec2-node" {
  description = "variable for ec2 node group"
  type = object({
    node_group_name             = string
    scaling_config_desired_size = number
    scaling_config_max_size     = number
    scaling_config_min_size     = number
    ami_type                    = string
    instance_types              = list(string)
    capacity_type               = string
    disk_size                   = number
  })
  default = {
    node_group_name             = "default-node-group"
    scaling_config_desired_size = 6
    scaling_config_max_size     = 8
    scaling_config_min_size     = 4
    ami_type                    = "AL2_x86_64"
    instance_types              = ["t3.medium"]
    capacity_type               = "ON_DEMAND"
    disk_size                   = 20
  }
}