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

echo "----------"
echo "INSTALLING DAGGER CLI"
echo "----------"
curl -L https://dl.dagger.io/dagger/install.sh | BIN_DIR=$HOME/.local/bin sh
export PATH=$PATH:/.local/bin

echo "----------"
echo "STARTING DAGGER"
echo "----------"
docker run \
  -v /var/lib/dagger \
  -p ${dagger_engine_port}:${dagger_engine_port} \
  --rm \
  --privileged \
  --name dagger-engine \
  registry.dagger.io/engine:v0.13.0 \
  --addr tcp://0.0.0.0:${dagger_engine_port} \
  --addr unix:///run/buildkit/buildkitd.sock
