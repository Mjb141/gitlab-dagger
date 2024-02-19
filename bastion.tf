resource "aws_security_group" "bastion" {
  name        = "Bastion SG"
  description = "SG for Bastion"

  vpc_id = aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "bastion-ssh-to-dagger" {
  description = "Allow SSH from Bastion"

  security_group_id = aws_security_group.dagger.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22

  referenced_security_group_id = aws_security_group.bastion.id

  tags = {
    Name = "SSH from Bastion"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  description = "Allow SSH from Bastion"

  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22

  tags = {
    Name = "SSH from Bastion"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion-ssh-to-gitlab" {
  description = "Allow SSH from Bastion"

  security_group_id = aws_security_group.runner.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22

  referenced_security_group_id = aws_security_group.bastion.id

  tags = {
    Name = "SSH from Bastion"
  }
}

resource "aws_vpc_security_group_egress_rule" "bastion-ssh-to-gitlab" {
  description = "Allow Bastion to SSH to Gitlab-Runners"

  security_group_id = aws_security_group.bastion.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22

  referenced_security_group_id = aws_security_group.runner.id
}

resource "aws_vpc_security_group_egress_rule" "bastion-ssh-to-dagger" {
  description = "Allow Bastion to SSH to Dagger"

  security_group_id = aws_security_group.bastion.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22

  referenced_security_group_id = aws_security_group.dagger.id
}


resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id

  key_name = var.key_pair

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.01
    }
  }

  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "Bastion"
  }
}
