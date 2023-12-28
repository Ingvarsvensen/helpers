#!/bin/bash

sudo apt update

# Install GoLang (required for KinD)
sudo apt install -y golang

# Install kubectl (Kubernetes command-line tool)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install KinD
if [ $(uname -m) = "x86_64" ]; then
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
elif [ $(uname -m) = "aarch64" ]; then
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-arm64
fi
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create KinD config file
cat <<EOF > config.yaml
apiVersion: kind.x-k8s.io/v1alpha4
kind: Cluster
nodes:
- role: control-plane
- role: worker
  extraPortMappings:
  - containerPort: 30000
    hostPort: 30000
    listenAddress: "0.0.0.0"
    protocol: tcp
EOF

# Create a Kubernetes cluster using KinD
kind create cluster --config=config.yaml

# Verify Cluster Creation
kubectl cluster-info --context kind-kind

# Print setup result
echo "KinD Setup Complete. Kubernetes cluster created successfully."
