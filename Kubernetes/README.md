# Kubernetes Module
---
This module instantiates:
- Kubernetes namespace
- Kubernetes storageclass
- Kubernetes persistent volume
- Kubernetes persistent volume claims

## Input
---

| Name | Description    | Type    | Default | 
| :---:   | :---: | :---: |:---:|
efs_id | identifier of the efs_file_system so that we can mount the persistent volume | string | known only after apply
aws_efs_access_point | access point object for the static storage configuration, this is needed for the creation of persistent volume | tuple(object) | known only after apply |
namespace | value for the kubernetes namespace | string | "hpcc"

## Output
---
