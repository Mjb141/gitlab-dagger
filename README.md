## Scanning:

### Secrets:

Run `docker run -t -v .:/path checkmarx/kics:latest scan -p /path -o "/path/"`

### Misconfigurations:

Run `trivy config ./`

## Todo:

* Write userdata scripts for gitlab-runner
  * Test these before going any further

* Write (copy existing) gitlab-runner config file
