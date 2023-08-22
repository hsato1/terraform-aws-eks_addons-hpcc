# AWS_EKS Module
---
This module create
- EKS cluster
- EKS ec2 node group
- AWS EKS addons
> - DNS addon
> - EFS CSI driver
- Necessary IAM role policies and role
- Kubernetes Service account
### Input
--- 

| Name | Description    | Type    | Default | 
| :---:   | :---: | :---: |:---:|
| aws_public_subnets_id | list of public subnet ids of VPC | list(string) | only known after apply | 
| aws_private_subnets_id | list of private subnet ids of VPC | list(string) | only known after apply | 
| cluster_name  | name of the cluster generated | string | eks-cluster | 
| aws_vpc_security_groups_id | vpc security groups id that is generated in VPC creation | list(string) | only known after apply |


#### ```ec2-node``` block ```Object```

| Name | Description    | Type    | Default | 
| :---:   | :---: | :---: |:---:|
node_group_name | name of the node group | string | "default-node-group"
scaling_config_desired_size | number of desired nodes in the group | number | 6
scaling_config_max_size | maximum number of nodes in the group | number | 8
scaling_config_min_size | minimum number of nodes in the group | number | 4
ami_type | type of the amazon machine images to be used | string | "AL2_x86_64"
instance_types | type of instances to be created inside the node | list(string) | ["t3.medium"]
capacity_type | specifying that how we will be managing the resource and as a result how we will be chared. | string | "ON_DEMAND| 
disk_size | specifying root device disk size for the node group instance | number | 20

### Output

| Name | Description    | Type    |
| :---:   | :---: | :---: |
cluster_id | unique identifier for the cluster that is generated at the creation of cluster| string
cluster_name | name of the cluster | string 
certificate_authority | data that are needed for authenticating with Kubernetes | object 
endpoint | point of communcation between cluster and outside resources such as Kubernetes|





