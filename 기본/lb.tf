/*
#퍼블릭 alb
resource "aws_lb" "bespin-alb" {
  name = "bespin-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.bespin-sg.id]
  subnets = [aws_subnet.bespin-subnet-public-a.id, aws_subnet.bespin-subnet-public-c.id]
  tags = {
    Name = "bespin-alb"
  }
}

resource "aws_lb_target_group" "bespin-alb-target-a" {
  name = "bespin-alb-target"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.bespin-vpc.id

  health_check {
    interval = 30
    path = "/"
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
  tags = {
    Name = "bespin-alb-target-a"
  }
}
resource "aws_lb_target_group" "bespin-alb-target-b" {
  name = "bespin-alb-target"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.bespin-vpc.id

  health_check {
    interval = 30
    path = "/"
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
  tags = {
    Name = "bespin-alb-target-b"
  }
}

resource "aws_lb_target_group_attachment" "bespin-alb-attach-a" {
  target_group_arn = aws_lb_target_group.bespin-alb-target-a.arn
  target_id = aws_instance.bespin-ec2-web-a.id
  port  = 80
}
resource "aws_lb_target_group_attachment" "bespin-alb-attach-b" {
  target_group_arn = aws_lb_target_group.bespin-alb-target-b.arn
  target_id = aws_instance.bespin-ec2-web-b.id
  port  = 80
}

resource "aws_lb_listener" "bespin-alb-listner" {
  load_balancer_arn = aws_lb.bespin-alb.arn
  port = 80
  default_action {
    target_group_arn = aws_lb_target_group.bespin-alb-target-a.arn
    type = "forward"
  }
}

#프라이빗 nlb
resource "aws_lb" "bespin-nlb" {
  name = "bespin-nlb"
  internal = true
  load_balancer_type = "application"
  security_groups = [aws_security_group.bespin-sg.id]
  subnets = [aws_subnet.bespin-subnet-private-a.id, aws_subnet.bespin-subnet-private-c.id]
  tags = {
    Name = "bespin-nlb"
  }
}

resource "aws_lb_target_group" "bespin-nlb-target-a" {
  name = "bespin-nlb-target"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.bespin-vpc.id

  health_check {
    interval = 30
    path = "/"
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
  tags = {
    Name = "bespin-nlb-target-a"
  }
}
resource "aws_lb_target_group" "bespin-nlb-target-b" {
  name = "bespin-nlb-target"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.bespin-vpc.id

  health_check {
    interval = 30
    path = "/"
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
  tags = {
    Name = "bespin-nlb-target-b"
  }
}

resource "aws_lb_target_group_attachment" "bespin-nlb-attach-a" {
  target_group_arn = aws_lb_target_group.bespin-nlb-target-a.arn
  target_id = aws_instance.bespin-ec2-was-a.id
  port  = 80
}
resource "aws_lb_target_group_attachment" "bespin-nlb-attach-b" {
  target_group_arn = aws_lb_target_group.bespin-nlb-target-b.arn
  target_id = aws_instance.bespin-ec2-was-b.id
  port  = 80
}

resource "aws_lb_listener" "bespin-nlb-listner" {
  load_balancer_arn = aws_lb.bespin-nlb.arn
  port = 80
  default_action {
    target_group_arn = aws_lb_target_group.bespin-nlb-target-a.arn
    type = "forward"
  }
}
*/