
# creating VPC
module "VPC" {
  source         = "../modules/vpc"
  REGION         = var.REGION
  PROJECT_NAME   = var.PROJECT_NAME
  VPC_CIDR       = var.VPC_CIDR
  PUB_SUB_1_CIDR = var.PUB_SUB_1_CIDR
  PUB_SUB_2_CIDR = var.PUB_SUB_2_CIDR
  PRI_SUB_1_CIDR = var.PRI_SUB_1_CIDR
  PRI_SUB_2_CIDR = var.PRI_SUB_2_CIDR
}

# cretea NAT-NAT-GW
module "NAT-GW" {
  source = "../modules/nat-gw"

  PUB_SUB_1_ID = module.VPC.PUB_SUB_1_ID
  IGW_ID       = module.VPC.IGW_ID
  PUB_SUB_2_ID = module.VPC.PUB_SUB_2_ID
  VPC_ID       = module.VPC.VPC_ID
  PRI_SUB_1_ID = module.VPC.PRI_SUB_1_ID
  PRI_SUB_2_ID = module.VPC.PRI_SUB_2_ID
}


module "IAM" {
  source       = "../modules/IAM"
  PROJECT_NAME = var.PROJECT_NAME
}

module "EKS" {
  source               = "../modules/EKS"
  PROJECT_NAME         = var.PROJECT_NAME
  EKS_CLUSTER_ROLE_ARN = module.IAM.EKS_CLUSTER_ROLE_ARN
  PUB_SUB_1_ID         = module.VPC.PUB_SUB_1_ID
  PUB_SUB_2_ID         = module.VPC.PUB_SUB_2_ID
  PRI_SUB_1_ID         = module.VPC.PRI_SUB_1_ID
  PRI_SUB_2_ID         = module.VPC.PRI_SUB_2_ID
}


module "NODE_GROUP" {
  source           = "../modules/Node-group"
  EKS_CLUSTER_NAME = module.EKS.EKS_CLUSTER_NAME
  NODE_GROUP_ARN   = module.IAM.NODE_GROUP_ROLE_ARN
  PRI_SUB_1_ID     = module.VPC.PRI_SUB_1_ID
  PRI_SUB_2_ID     = module.VPC.PRI_SUB_2_ID
}
