resource "aws_iam_role" "bespin-role" {
  name = "bespin-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    name = "bespin-role"
  }
}

resource "aws_iam_instance_profile" "bespin-iam-profile" {
  name = "bespin-iam-profile"
  role = aws_iam_role.bespin-role.id
}

resource "aws_iam_role_policy" "bespin-iam-policy" {
  name = "bespin-iam-policy"
  role = aws_iam_role.bespin-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["s3:*", "ec2:*", "rds:*"],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
