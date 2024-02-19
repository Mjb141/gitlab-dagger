data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "runner" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.private.id

  key_name = var.key_pair

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.01
    }
  }

  user_data                   = templatefile("gitlab-runner-userdata", {})
  user_data_replace_on_change = true

  vpc_security_group_ids = [aws_security_group.runner.id]

  tags = {
    Name = "Gitlab Runner"
  }
}

resource "aws_instance" "dagger" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.private.id

  key_name = var.key_pair

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.01
    }
  }

  vpc_security_group_ids = [aws_security_group.dagger.id]

  tags = {
    Name = "Dagger Host"
  }
}
