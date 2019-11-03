data "aws_availability_zones" "this" {}

data "aws_ami" "eks_worker_1_14" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.14-v20190906"]
  }

  most_recent = true
  owners      = ["amazon"]
}