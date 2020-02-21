# 유저데이터 파일 선언
data "template_file" "user_data" {
  template = file("${path.module}/userdata.sh")
}

#EC2 인스턴스
resource "aws_instance" "bespin-ec2-web-a" {
  ami = "ami-0bea7fd38fabe821a"
  instance_type = "t2.micro"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.bespin-public-a-eni.id
  }
  tags = {
    Name = "bespin-ec2-web-a"
  }
  user_data = data.template_file.user_data.rendered
}
/*
resource "aws_instance" "bespin-ec2-web-b" {
  ami = "ami-0bea7fd38fabe821a"
  instance_type = "t2.micro"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.bespin-public-c-eni.id
  }
  tags = {
    Name = "bespin-ec2-web-b"
  }
  user_data = data.template_file.user_data.rendered
}
resource "aws_instance" "bespin-ec2-was-a" {
  ami = "ami-0bea7fd38fabe821a"
  instance_type = "t2.micro"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.bespin-private-a-eni.id
  }
  tags = {
    Name = "bespin-ec2-was-a"
  }
  user_data = data.template_file.user_data.rendered
}
resource "aws_instance" "bespin-ec2-was-b" {
  ami = "ami-0bea7fd38fabe821a"
  instance_type = "t2.micro"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.bespin-private-c-eni.id
  }
  tags = {
    Name = "bespin-ec2-was-b"
  }
  user_data = data.template_file.user_data.rendered
}
*/
#네트워크 인터페이스 연결

resource "aws_network_interface" "bespin-public-a-eni" {
  subnet_id = aws_subnet.bespin-subnet-public-a.id
  private_ips = ["10.0.1.10"]
  security_groups = [aws_security_group.bespin-sg.id]
  tags = {
    Name = "bespin-Public-a-ENI"
  }
}
/*
resource "aws_network_interface" "bespin-public-c-eni" {
  subnet_id = aws_subnet.bespin-subnet-public-c.id
  private_ips = ["10.0.2.10"]
  security_groups = [aws_security_group.bespin-sg.id]
  tags = {
    Name = "bespin-Public-c-ENI"
  }
}
resource "aws_network_interface" "bespin-private-a-eni" {
  subnet_id = aws_subnet.bespin-subnet-private-a.id
  private_ips = ["10.0.3.10"]
  security_groups = [aws_security_group.bespin-sg.id]
  tags = {
    Name = "bespin-private-a-ENI"
  }
}
resource "aws_network_interface" "bespin-private-c-eni" {
  subnet_id = aws_subnet.bespin-subnet-private-c.id
  private_ips = ["10.0.4.10"]
  security_groups = [aws_security_group.bespin-sg.id]
  tags = {
    Name = "bespin-private-c-ENI"
  }
}
*/

#인스턴스 EIP할당
resource "aws_eip" "bespin-public-a-eip" {
  instance = aws_instance.bespin-ec2-web-a.id
  vpc = true
}
/*
resource "aws_eip" "bespin-public-c-eip" {
  instance = aws_instance.bespin-ec2-web-b.id
  vpc = true
}
*/