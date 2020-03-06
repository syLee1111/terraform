variable "ami_id" {
  #default = "ami-0a93a08544874b3b7"
  type = string
}


variable "instance_type" {
  #default = "t2.micro"
  type = string
}

#variable "public_subnets" {
#  description = "Public Subnet IP 리스트"
#  type        = list
#}

variable "tags" {
  description = "모든 리소스에 추가되는 tag 맵"
  type        = map
}

variable "name" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = string
}
/*
variable "eni" {
  description = "네트워크 인터페이스"
  type        = list
}



variable "vpc_id" {
  type = string
}
*/
variable "sg" {
  type = string
}

variable "azs" {
  type = list
}

variable "subnet" {
  type = list
}
