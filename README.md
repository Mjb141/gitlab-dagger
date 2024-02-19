## Scanning:

### Secrets:

Run `docker run -t -v .:/path checkmarx/kics:latest scan -p /path -o "/path/"`

### Misconfigurations:

Run `trivy config ./`

## Todo:

Replace bastion instance + sec group etc with session manager

Example:

1) source: https://github.com/terraform-aws-modules/terraform-aws-ec2-instance/blob/v5.6.0/examples/session-manager/main.tf
2) module: https://github.com/terraform-aws-modules/terraform-aws-ec2-instance/blob/v5.6.0/main.tf#L569
