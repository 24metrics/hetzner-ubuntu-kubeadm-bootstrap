# Hetzner Ubuntu Kubeadm Bootstrap

Cloud-init configuration for provisioning Ubuntu servers on Hetzner Cloud with Kubernetes (kubeadm) prerequisites.

## Overview

This repository contains bootstrap scripts designed to prepare Ubuntu servers for Kubernetes cluster deployment using kubeadm. The scripts are intended to be used as cloud-config during Hetzner server provisioning.

## What it does

- Installs Kubernetes components (kubeadm, kubelet, kubectl v1.32)
- Configures containerd as the container runtime
- Sets up required system networking parameters
- Prepares the system for kubeadm cluster initialization

## Usage

Use `init.sh` as part of your Hetzner Cloud-init configuration when provisioning new Ubuntu servers.
