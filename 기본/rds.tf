/*
resource "aws_db_subnet_group" "bespin-db-subnet-gr" {
  subnet_ids = [aws_subnet.bespin-subnet-private-DBa.id, aws_subnet.bespin-subnet-private-DBc.id]
  tags = {
    Name = "bespin-db-subnet-group"
  }
}

resource "aws_db_instance" "bespin-rds" {
  identifier = "bespin-db"
  allocated_storage = 8
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.6.35"
  instance_class = "db.t2.micro"
  name = "bespindb"
  username = "admin"
  password = "bespin12345"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.bespin-db-subnet-gr.id
  vpc_security_group_ids = [aws_security_group.bespin-sg.id]
}
*/