# VPC 생성
resource "aws_vpc" "bespin-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "bespin-vpc"
  }
}

# Public 서브넷
resource "aws_subnet" "bespin-subnet-public-a" {
  vpc_id            = aws_vpc.bespin-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "bespin-subnet-public-a"
  }
}
resource "aws_subnet" "bespin-subnet-public-c" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.bespin-vpc.id
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "bespin-subnet-public-c"
  }
}

# Private 서브넷
resource "aws_subnet" "bespin-subnet-private-a" {
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-2a"
  vpc_id     = aws_vpc.bespin-vpc.id
  tags = {
    Name = "bespin-subnet-private-a"
  }
}
resource "aws_subnet" "bespin-subnet-private-c" {
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-2c"
  vpc_id     = aws_vpc.bespin-vpc.id
  tags = {
    Name = "bespin-subnet-private-c"
  }
}

# Private-DB 서브넷
resource "aws_subnet" "bespin-subnet-private-DBa" {
  cidr_block = "10.0.5.0/24"
  vpc_id     = aws_vpc.bespin-vpc.id
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "bespin-subnet-private-DBa"
  }
}
resource "aws_subnet" "bespin-subnet-private-DBc" {
  cidr_block = "10.0.6.0/24"
  vpc_id     = aws_vpc.bespin-vpc.id
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "bespin-subnet-private-DBc"
  }
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "bespin-igt" {
  vpc_id = aws_vpc.bespin-vpc.id
  tags = {
    Name = "bespin-igt"
  }
}


# 라우팅 테이블
resource "aws_route_table" "bespin-route-table-public" {
  vpc_id = aws_vpc.bespin-vpc.id
  tags = {
    Name = "bespin-public-subnet"
  }
}
resource "aws_route_table" "bespin-route-table-private" {
  vpc_id = aws_vpc.bespin-vpc.id
  tags = {
    Name = "bespin-private-subnet"
  }
}
resource "aws_route_table" "bespin-route-table-private-DB" {
  vpc_id = aws_vpc.bespin-vpc.id
  tags = {
    Name = "bespin-private-DB-subnet"
  }
}

resource "aws_route" "bespin-route-public" {
  route_table_id         = aws_route_table.bespin-route-table-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.bespin-igt.id
}

resource "aws_route_table_association" "bespin-subnet-public-a-association" {
  route_table_id = aws_route_table.bespin-route-table-public.id
  subnet_id      = aws_subnet.bespin-subnet-public-a.id
}
resource "aws_route_table_association" "bespin-subnet-public-c-association" {
  route_table_id = aws_route_table.bespin-route-table-public.id
  subnet_id      = aws_subnet.bespin-subnet-public-c.id
}
resource "aws_route_table_association" "bespin-subnet-private-a-association" {
  route_table_id = aws_route_table.bespin-route-table-private.id
  subnet_id      = aws_subnet.bespin-subnet-private-a.id
}
resource "aws_route_table_association" "bespin-subnet-private-c-association" {
  route_table_id = aws_route_table.bespin-route-table-private.id
  subnet_id      = aws_subnet.bespin-subnet-private-c.id
}
resource "aws_route_table_association" "bespin-subnet-private-DBa-association" {
  route_table_id = aws_route_table.bespin-route-table-private-DB.id
  subnet_id      = aws_subnet.bespin-subnet-private-DBa.id
}
resource "aws_route_table_association" "bespin-subnet-private-DBc-association" {
  route_table_id = aws_route_table.bespin-route-table-private-DB.id
  subnet_id      = aws_subnet.bespin-subnet-private-DBc.id
}

# 보안그룹
resource "aws_security_group" "bespin-sg" {
  vpc_id = aws_vpc.bespin-vpc.id
  description = "bespin-sg"
  name   = "bespin-sg"
  tags = {
    Name = "bespin-sg"
  }
}
resource "aws_security_group_rule" "bespin-sg-rule-vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.bespin-sg.id
}
resource "aws_security_group_rule" "bespin-sg-rule-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bespin-sg.id
}
resource "aws_security_group_rule" "bespin-sg-rule-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bespin-sg.id
}
resource "aws_security_group_rule" "bespin-sg-rule-outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bespin-sg.id
}

#ACL
resource "aws_default_network_acl" "bespin-network-acl-public" {
  default_network_acl_id = aws_vpc.bespin-vpc.default_network_acl_id

  ingress {
    protocol = "-1"
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  egress {
    protocol = "-1"
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  subnet_ids = [
  aws_subnet.bespin-subnet-public-a.id,
  aws_subnet.bespin-subnet-public-c.id
  ]

  tags = {
    Name = "bespin-network-acl-public"
  }
}

resource "aws_network_acl" "bespin-network-acl-private" {
  vpc_id = aws_vpc.bespin-vpc.id

  ingress {
    protocol = "-1"
    rule_no = 100
    action = "allow"
    cidr_block = "10.0.1.0/24"
    from_port = 0
    to_port = 0
  }
  ingress {
    protocol = "-1"
    rule_no = 200
    action = "allow"
    cidr_block = "10.0.2.0/24"
    from_port = 0
    to_port = 0
  }
  egress {
    protocol = "-1"
    rule_no = 100
    action = "allow"
    cidr_block = "10.0.1.0/24"
    from_port = 0
    to_port = 0
  }
  egress {
    protocol = "-1"
    rule_no = 200
    action = "allow"
    cidr_block = "10.0.2.0/24"
    from_port = 0
    to_port = 0
  }
  subnet_ids = [
    aws_subnet.bespin-subnet-private-a.id,
    aws_subnet.bespin-subnet-private-c.id
  ]

  tags = {
    Name = "bespin-network-acl-private"
  }
}

resource "aws_network_acl" "bespin-network-acl-private-DB" {
  vpc_id = aws_vpc.bespin-vpc.id

  ingress {
    protocol = "-1"
    rule_no = 100
    action = "allow"
    cidr_block = "10.0.3.0/24"
    from_port = 0
    to_port = 0
  }
  ingress {
    protocol = "-1"
    rule_no = 200
    action = "allow"
    cidr_block = "10.0.4.0/24"
    from_port = 0
    to_port = 0
  }
  egress {
    protocol = "-1"
    rule_no = 100
    action = "allow"
    cidr_block = "10.0.3.0/24"
    from_port = 0
    to_port = 0
  }
  egress {
    protocol = "-1"
    rule_no = 200
    action = "allow"
    cidr_block = "10.0.4.0/24"
    from_port = 0
    to_port = 0
  }
  subnet_ids = [
    aws_subnet.bespin-subnet-private-DBa.id,
    aws_subnet.bespin-subnet-private-DBc.id
  ]

  tags = {
    Name = "bespin-network-acl-private-DB"
  }
}