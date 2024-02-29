#!/bin/bash
echo "----------"
echo "STARTING USER DATA"
echo "----------"
apt-get update -y
apt-get install ca-certificates curl gnupg -y

echo "----------"
echo "INSTALLING DOCKER"
echo "----------"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
	tee /etc/apt/sources.list.d/docker.list >/dev/null
apt-get update -y
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# echo "----------"
# echo "INSTALLING DAGGER CLI"
# echo "----------"
# curl -L https://dl.dagger.io/dagger/install.sh | BIN_DIR=$HOME/.local/bin sh
# export PATH=$PATH:/.local/bin/

echo "----------"
echo "INSTALLING GITLAB RUNNER"
echo "----------"
curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"
chmod +x /usr/local/bin/gitlab-runner
useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
usermod -aG docker gitlab-runner
gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner

echo "----------"
echo "CREATING CONFIG"
echo "----------"
rm /etc/gitlab-runner/config.toml
cat >/etc/gitlab-runner/config.toml <<CONFIG
concurrent = 1
check_interval = 0
shutdown_timeout = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "runnerdemo"
  url = "https://gitlab.com"
  id = 28424986
  token = "${gitlab_token}"
  executor = "docker"
  [runners.docker]
    tls_verify = false
    image = "docker:24.0.5"
    privileged = true
    disable_cache = false
    volumes = ["/certs/client", "/cache"]
  [runners.cache]
    MaxUploadedArchiveSize = 0
CONFIG

echo "----------"
echo "STARTING RUNNER"
echo "----------"
gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
gitlab-runner start
