resource "aws_iam_role" "EKSClusterRole" {
  name = "EKSClusterRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role" "NodeGroupRole" {
  name = "EKSNodeGroupRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}




# resource "aws_iam_role" "EFSRole" {
#   name = "EFSRole"
#   assume_role_policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "eks:*"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": "iam:PassRole",
#             "Resource": "*",
#             "Condition": {
#                 "StringEquals": {
#                     "iam:PassedToService": "eks.amazonaws.com"
#                 }
#             }
#         }
#     ]
# })
# }

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.EKSClusterRole.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.NodeGroupRole.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.NodeGroupRole.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.NodeGroupRole.name
}


# resource "aws_iam_role_policy_attachment" ""
# resource "aws_iam_role_policy_attachment" "FileSystemFullAccess" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
#   role       = aws_iam_role.EFSRole.name
# }

# resource "aws_iam_role_policy_attachment" "FileSystemFullAccess" {
#   policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
#   role       = aws_iam_role.EFSRole.name
# }


# resource "aws_iam_role_policy_attachment" "FileSystemFullAccess" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
#   role       = aws_iam_role.EFSRole.name
# }



# resource "aws_iam_policy" "node_efs_policy" {
#   name = "EFS-policy"
#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Effect" : "Allow",
#           "Action" : [
#             "elasticfilesystem:DescribeAccessPoints",
#             "elasticfilesystem:DescribeFileSystems",
#             "elasticfilesystem:DescribeMountTargets",
#             "ec2:DescribeAvailabilityZones"
#           ],
#           "Resource" : "*"
#         },
#         {
#           "Effect" : "Allow",
#           "Action" : [
#             "elasticfilesystem:CreateAccessPoint"
#           ],
#           "Resource" : "*",
#           "Condition" : {
#             "StringLike" : {
#               "aws:RequestTag/efs.csi.aws.com/cluster" : "true"
#             }
#           }
#         },
#         {
#           "Effect" : "Allow",
#           "Action" : [
#             "elasticfilesystem:TagResource"
#           ],
#           "Resource" : "*",
#           "Condition" : {
#             "StringLike" : {
#               "aws:ResourceTag/efs.csi.aws.com/cluster" : "true"
#             }
#           }
#         },
#         {
#           "Effect" : "Allow",
#           "Action" : "elasticfilesystem:DeleteAccessPoint",
#           "Resource" : "*",
#           "Condition" : {
#             "StringEquals" : {
#               "aws:ResourceTag/efs.csi.aws.com/cluster" : "true"
#             }
#           }
#         }
#       ]
#     }
#   )
# }