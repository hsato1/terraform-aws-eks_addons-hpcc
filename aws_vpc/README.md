### AWS_VPC Module
---
This module creates AWS VPC with following resources
- VPC
- Public, Private subnet
- internet gateway
- nat gateway
- route
- routetable
<br> 
***This module needs to be created first before any other modules***

### Input
---
#### ```Networking Block```
| Name | Description    | Type    | Default | Required |
| :---:   | :---: | :---: |:---:|:---:|
| cidr_block | cidr_blocks specification for vpc to be deployed | string | "10.0.0.0/16"| no
| region | aws region in which the resources will be deployed| string | "us-east-1" | no
| vpc_name | name of vpc | string | "custom_vpc" | no
| azs | availability zones | list(string) | ["us-east-1a", "us-east-1b"] | no
| public_subnets| subnet masks for the public subnet to be deployed. | list(string) | ["10.0.1.0/24", "10.0.2.0/24"] | no
| private_subnets | subnet masks for the private subnet to be deployed. | list(string) | ["10.0.3.0/24", "10.0.4.0/24"]| no

The example usage looks as follows:

```
networking = {
    cidr_block      = "10.0.0.0/16"
    region          = "us-east-1"
    vpc_name        = "custom-vpc"
    azs             = ["us-east-1a", "us-east-1b"]
    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
    nat_gateways    = true
  }
```


#### ```security_groups``` Block ```List of Objects```

VPC is associated with a set of security groups, and this module supports varied definiton of security groups. 
Arguments are:
| Name | Description    | Type    | Required |
| :---:   | :---: | :---: |:---:|
| name | name of security group | string | no
| description | description of the security group| string | no
| ingress | configuration block for ingress rule| list(object)| no 
| egress | configuration block for egress rule | list(object) | no

The example usage looks as follows:

```
security_groups = [{
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
```
### Output
---
This module generate output listed below that are used to configure with different resources
| Name | Description    | Type    |
| :---:   | :---: | :---: |
| pulic_subnets_id| subnet ids for public subnets that are generated. | list(string)| 
| private_subnet_id | subnet ids for private subnets that are generated. | list(string)
| security_groups_id | list of security group ids that are generated. | list(string) |
| vpc_id | a unique identification number allocated to the vpc. | list(string) | 



