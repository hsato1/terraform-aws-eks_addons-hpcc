# aws_efs module

**This module requires two other modules to be created in advance: aws_vpc and aws_eks**

This module create:
- aws_efs_file_system
- aws_efs_mount_target
- aws_efs_access_point
- aws_security_group - relevant to aws_efs_mount_target

## Input

| Name | Description    | Type    | Default | 
| :---:   | :---: | :---: |:---:|
| efs_token | name for the efs_file_system | string | "main"|
| aws_vpc_id | the identifier of the VPC that is created by the aws_vpc module | string | known only after apply | 
| aws_vpc_public_subnets_id | public subnet id inside the VPC that is created | list(string) | known only after apply | 
| aws_vpc_private_subnets_id | private subnet id inside the VPC that is created | list(string) | known only after apply | 
| aws_vpc_security_groups_id | security identifier that is passed from the VPC | list(string) | known only after apply | 
| tags | tags for the resources | object | default value in root module | 
## Output
| Name | Description    | Type    |
| :---:   | :---: | :---: |
| access_points | access points object that is created as resource | tuple(object)
| efs_id | identifier of efs_file_system | string 



