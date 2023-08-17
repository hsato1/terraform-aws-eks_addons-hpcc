
locals {
  config_path = sensitive("${var.path}/conf")
  creds_path  = sensitive("${var.path}/credentials")
  profile     = sensitive(var.profile)
}

locals {
  access_points = {
    dali = {
      file_system_id = ""
      posix_user = {
        "uid" = 10000,
        "gid" = 10001
      }
      root_directory = {
        "path" : "/hpcc/dali",
        "creation_info" : {
          "owner_gid"   = 10001
          "owner_uid"   = 10000
          "permissions" = 777
        }
      }
      tags = {
        Name = "dali-ap"
      }
    }

    dll = {
      file_system_id = ""
      posix_user = {
        "uid" = 10000,
        "gid" = 10001
      }
      root_directory = {
        "path" : "/hpcc/dll",
        "creation_info" : {
          "owner_gid"   = 10001
          "owner_uid"   = 10000
          "permissions" = 777
        }
      }

      tags = {
        Name = "dll-ap"
      }
    }

    sasha = {

      file_system_id = ""

      posix_user = {
        "uid" = 10000,
        "gid" = 10001
      }

      root_directory = {
        "path" : "/hpcc/sasha",
        "creation_info" : {
          "owner_gid"   = 10001
          "owner_uid"   = 10000
          "permissions" = 777
        }
      }

      tags = {
        Name = "sasha-ap"
      }

    }

    data = {

      file_system_id = ""

      posix_user = {
        "uid" = 10000,
        "gid" = 10001
      }

      root_directory = {
        "path" : "/hpcc/data",
        "creation_info" : {
          "owner_gid"   = 10001
          "owner_uid"   = 10000
          "permissions" = 777
        }
      }

      tags = {
        Name = "data-ap"
      }

    }

    mydropzone = {

      file_system_id = ""

      posix_user = {
        "uid" = 10000,
        "gid" = 10001
      }

      root_directory = {
        "path" : "/hpcc/mydropzone"
        "creation_info" : {
          "owner_gid"   = 10001
          "owner_uid"   = 10000
          "permissions" = 777
        }
      }

      tags = {
        Name = "mydropzone-ap"
      }
    }
  }
}

locals {
  tags = merge(var.tags, { "owner" = var.admin.name, "owner_email" = var.admin.email })
}

locals {

  # commons = yamldecode(file("./example/values.yaml.tftpl"))["common"]
  planes = flatten(yamldecode(file("./example/values.yaml"))["planes"])
}