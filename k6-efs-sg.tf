module "efs_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 4.13.0"

  name = "efs_sg"
  description = "security group for efs"
  vpc_id = var.vpc_id //make sure to pass your vpc id

  ingress_with_cidr_blocks = [
    {
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      type        = "NFS"
      cidr_blocks = var.vpc_cidr_block //make sure to pass your vpc cidr block
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0 
      to_port     = 0 
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
