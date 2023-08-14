variable "path" {
  type    = string
  default = "/Users/satouhiroshiki/.aws"
}

variable "profile" {
  type    = string
  default = "ida-cloud-ops"
}


variable "admin" {
  description = "Information for the user who administers the deployment."
  type = object({
    name  = string
    email = string
  })
  validation {
    condition = try(
      regex("hpccdemo", var.admin.name) != "hpccdemo", true
      ) && try(regex("hpccdemo", var.admin.email) != "hpccdemo", true
    ) && try(regex("@example.com", var.admin.email) != "@example.com", true)
    error_message = "Your name and email are required in the admin block and must not contain hpccdemo or @example.com."
  }

}
variable "tags" {
  description = "Additional resource tags."
  type        = map(string)

  default = {
    "description" = "Testing"
  }
}


variable "kubeconfig_name" {
  type    = string
  default = "cluster-name"
}
variable "cluster_name" {
  type    = string
  default = "eks-cluster"
}
variable "region" {
  type    = string
  default = "us-east-1"
}
variable "networking" {
  type = object({
    cidr_block      = string
    region          = string
    vpc_name        = string
    azs             = list(string)
    public_subnets  = list(string)
    private_subnets = list(string)
    nat_gateways    = bool
  })
  default = {
    cidr_block      = "10.0.0.0/16"
    region          = "us-east-1"
    vpc_name        = "custom-vpc"
    azs             = ["us-east-1a", "us-east-1b"]
    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
    nat_gateways    = true
  }
}

variable "security_groups" {
  type = list(object({
    name        = string
    description = string
    ingress = list(object({
      description      = string
      protocol         = string
      from_port        = number
      to_port          = number
      cidr_blocks      = list(string)
      ipv6_cidr_blocks = list(string)
    }))
    egress = list(object({
      description      = string
      protocol         = string
      from_port        = number
      to_port          = number
      cidr_blocks      = list(string)
      ipv6_cidr_blocks = list(string)
    }))
  }))
  default = [{
    name        = "default-security-group"
    description = "Inbound & Outbound traffic for custom-security-group"
    ingress = [
      {
        description      = "Allow HTTPS"
        protocol         = "tcp"
        from_port        = 443
        to_port          = 443
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = null
      },
      {
        description      = "Allow HTTP"
        protocol         = "tcp"
        from_port        = 80
        to_port          = 80
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = null
      },
    ]
    egress = [
      {
        description      = "Allow all outbound traffic"
        protocol         = "-1"
        from_port        = 0
        to_port          = 0
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }
    ]
  }]
}



### EFS related variables
variable "efs_token" {
  type    = string
  default = "main"
}