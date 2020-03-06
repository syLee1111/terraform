# main.tf

# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = merge(var.tags, map("Name", format("%s", var.name)))
}

# internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, map("Name", format("%s", var.name)))
}

# default network ACL
resource "aws_default_network_acl" "dev_default" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = [
    aws_subnet.public.0.id,
    aws_subnet.public.1.id,
    aws_subnet.private.0.id,
    aws_subnet.private.1.id
  ]

  tags = merge(var.tags, map("Name", format("%s-default", var.name)))
}
/*
# default security group
resource "aws_default_security_group" "dev_default" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = merge(var.tags, map("Name", format("%s-default", var.name)))
}
*/
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.this.id
  description = "sangyul-test-sg"
  name   = "sangyul-test-sg"
  tags = {
    Name = "sangyul-test-sg"
  }
}
resource "aws_security_group_rule" "sg-rule-vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["172.17.0.0/16"]
  security_group_id = aws_security_group.sg.id
}
resource "aws_security_group_rule" "sg-rule-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}
resource "aws_security_group_rule" "sg-rule-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}
resource "aws_security_group_rule" "sg-rule-outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

# public subnet
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, map("Name", format("%s-public-%s", var.name, var.azs[count.index])))
}



# private subnet
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, map("Name", format("%s-private-%s", var.name, var.azs[count.index])))
}

/*
# EIP for NAT gateway
resource "aws_eip" "eip" {
  count = length(var.azs)

  vpc = true
}

# NAT gateway
resource "aws_nat_gateway" "this" {
  count = length(var.azs)

  allocation_id = aws_eip.nat.*.id[count.index]
  subnet_id     = aws_subnet.public.*.id[count.index]
}
*/
# public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  #tags = "${merge(var.tags, map("Name", format("%s-public", var.name)))}"
  tags = merge(var.tags, map("Name", format("%s-public", var.name)))
}

# private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, map("Name", format("%s-private", var.name)))
}

# route table association
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private.id
  }

resource "aws_network_interface" "public_eni" {
  count = length(var.public_subnets)

  subnet_id = aws_subnet.public.*.id[count.index]
  security_groups = [aws_security_group.sg.id]


  tags = merge(var.tags, map("Name", format("%s-public", var.name)))
}
