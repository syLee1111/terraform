provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {
  source = "../modules/vpc"

  name = "sangyul-test"
  cidr = "172.17.0.0/16"

  azs              = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets   = ["172.17.1.0/24", "172.17.2.0/24"]
  private_subnets  = ["172.17.101.0/24", "172.17.102.0/24"]
  tags = {
    "TerraformManaged" = "true"
  }
}
/*
module "instance" {
  vpc_id = module.vpc.vpc_id
  source = "../modules/instance"
  ami_id = "ami-0a93a08544874b3b7"
  instance_type = "t2.micro"
  #public_subnets = flatten(module.vpc.public_subnets_ids[*])
  eni = flatten(module.vpc.eni[*])
  subnet = module.vpc.public_subnets_ids[*]
  name = "sangyul-test"
  tags = {
    "TerraformManaged" = "true"
  }
}
*/

module "instance"{
  source = "../modules/instance"
  name = "sangyul-test"
  instance_type = "t2.micro"
  ami_id = "ami-0a93a08544874b3b7"
  sg = module.vpc.sg
  azs = ["ap-northeast-2a", "ap-northeast-2c"]
  subnet = module.vpc.public_subnets_ids[*]
  tags = {
    "TerraformManaged" = "true"
  }
}

