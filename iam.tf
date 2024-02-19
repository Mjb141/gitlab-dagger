data "aws_partition" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}
resource "aws_iam_role" "instance_profile_role" {
  name        = "InstanceProfileRole"
  description = "IAM Role for Instance Profile"

  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "instance_profile_policy_attachment" {
  role       = aws_iam_role.instance_profile_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "InstanceProfile"
  role = aws_iam_role.instance_profile_role.name

  tags = {
    Name = "Instance Profile"
  }

  lifecycle {
    create_before_destroy = true
  }
}
