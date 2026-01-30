#!/bin/bash

# Configurable Kubernetes version (major.minor, e.g., 1.32, 1.31, 1.30)
# Find latest versions at: https://kubernetes.io/releases/
K8S_VERSION="${K8S_VERSION:-1.32}"

# Create directory for APT repository signing keys
mkdir -p /etc/apt/keyrings

# Remove any existing Kubernetes repository configuration to ensure a clean setup
rm -rf /etc/apt/keyrings/kubernetes-apt-keyring.gpg /etc/apt/sources.list.d/kubernetes.list

# Add Kubernetes repository GPG key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes APT repository
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" >/etc/apt/sources.list.d/kubernetes.list

# Add Docker repository GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | tee /etc/apt/keyrings/docker.asc

# Add Docker APT repository for containerd installation
echo "deb [signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >/etc/apt/sources.list.d/docker.list

# Update package lists with newly added repositories
apt-get update

# Install Kubernetes components (kubeadm, kubelet, kubectl) and containerd runtime
apt-get install -y apt-transport-https ca-certificates curl software-properties-common gpg kubeadm kubelet kubectl containerd.io

# Generate default containerd configuration
containerd config default >/etc/containerd/config.toml

# Enable systemd cgroup driver for containerd (required for Kubernetes compatibility)
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Restart containerd to apply configuration changes
systemctl restart containerd

# Enable containerd to start automatically on system boot
systemctl enable containerd

# Enable IPv4 packet forwarding (required for Kubernetes networking)
sysctl -w net.ipv4.ip_forward=1

# Persist IPv4 forwarding setting across reboots
echo "net.ipv4.ip_forward = 1" >>/etc/sysctl.conf
sysctl -p
