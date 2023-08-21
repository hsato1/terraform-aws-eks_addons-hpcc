locals {

  # commons = yamldecode(file("./example/values.yaml.tftpl"))["common"]
  planes = flatten(yamldecode(file("./example/values.yaml"))["planes"])
}