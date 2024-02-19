resource "aws_security_group" "runner" {
  name        = "Gitlab-Runner SG"
  description = "SG for Gitlab Runner"

  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group" "dagger" {
  name        = "Dagger Host SG"
  description = "SG for Dagger Host"

  vpc_id = aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "dagger-tcp" {
  description = "Allow TCP traffic on port 1234 from the Gitlab Runner instance"

  security_group_id = aws_security_group.dagger.id

  ip_protocol = "tcp"
  from_port   = 1234
  to_port     = 1234

  referenced_security_group_id = aws_security_group.runner.id

  tags = {
    Name = "TCP from Gitlab Runner"
  }
}

resource "aws_vpc_security_group_egress_rule" "gitlab-all-out-443" {
  description = "Allow port 443 outbound from Gitlab"

  security_group_id = aws_security_group.runner.id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443

  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "gitlab-all-out-80" {
  description = "Allow port 80 outbound from Gitlab"

  security_group_id = aws_security_group.runner.id

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "dagger-all-out-443" {
  description = "Allow port 443 outbound from Dagger"

  security_group_id = aws_security_group.dagger.id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443

  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "dagger-all-out-80" {
  description = "Allow port 80 outbound from Dagger"

  security_group_id = aws_security_group.dagger.id

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  cidr_ipv4 = "0.0.0.0/0"
}
