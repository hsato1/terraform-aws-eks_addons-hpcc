# /*
# resource "kubernetes_namespace" "namespace" {
#   metadata {
#     name = var.namespace
#     labels = "wordpress"
#   }
#   depends_on = [ var.namespace_depends_on ]
# }
# */
# variable "labels" {
#  type = string
#  default = "wordpress"
# }

# variable "db_address" {
#   default = "127.0.0.1"
# }
# variable "db_user" {
# default = "test"
# }
# variable "db_pass" {
#   default = "db_pass"
# }
# variable "db_name" {
#  default = "wordpress"
# }
# resource "kubernetes_deployment" "deploy" {
#   metadata {
#     name = "wordpress"
#     namespace = "default"
#     labels = {
#          app = "wordpress"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#        app = "wordpress"
#      }
#     }

#     template {
#       metadata {
#          labels = { 
#            app = "wordpress"
#         }
#      }

#       spec {
#         container {
#           image = "wordpress"
#           name  = "wordpress"
#           port   {
#               name = "wordpress"
#               container_port = 80
#           }
#           volume_mount  {
#               name = "wordpress-persistent-storage"
#               mount_path = "/var/www/html"
#           }
#           env {
#             name = "WORDPRESS_DB_HOST"
#             value = var.db_address
#           }
#           env { 
#             name = "WORDPRESS_DB_USER"
#             value = var.db_user
#           }
#           env { 
#             name = "WORDPRESS_DB_PASSWORD"
#             value = var.db_pass 
#           } 
#           env {
#             name = "WORDPRESS_DB_NAME"
#             value = var.db_name
#           }
#         }
#         volume  {
#           name = "wordpress-persistent-storage"
#           persistent_volume_claim { 
#               claim_name = kubernetes_persistent_volume_claim.wordpress.metadata[0].name
#           }
#         }
#       }
#     }
#   }
# }
