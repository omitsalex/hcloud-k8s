# hcloud-k8s

Install a Kubernetes Cluster on Hetzner Cloud.
The Playbook install a Master and Workers with Private Networking inclusive Cloud Controller Manager for Hetzner Cloud with a Load Balancer.

Tested Versions Kubernetes v1.19.6

---
# Forked to align with more current dependencies - Note Load Balancer and Failover IPs not working yet (looking to switch from metallb)

## Local Requirements
  - Ansible v2.9.6 (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
  - Kubectl v1.19.6 (https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  - Terraform >= v0.13.1 (https://github.com/tfutils/tfenv#installation)
  - Helm >= v3.3.0 (https://github.com/helm/helm#install)

## Prerequirments edit the following files
  - create a HCloud Project in Hetzner Cloud Console
  - Create a floating IP with the name that you'll use as my_ip_tag in your values.yaml below
  - copy/rename "env/values.yaml.example" to "env/values.yaml"
  - create a API Token and set in "env/values.yaml"
  - edit the values in "env/values.yaml"

## Prerequriements for Ingress & Let's Encrypt! support
  - Add for `lb_hostname` a valid DNS-Entry (necessary for Certificate Requests)

## Create Infrastructure Ansible Playbook Terrafom Module
```bash
ansible-playbook create-infrastructure.yaml
```
After creation is complete waiting 5 Minutes, because Hetzner install the "roles/tf-infrastructure/terraform/user-data/cloud-config.yaml" (Docker, Kubelet, Kubeadm, Kubectl, SSH Keys)
The Playbook execute Terraform and apply the resources. The working directory is "roles/tf-infrastructure/terraform/"

## Install Kubernetes Ansible Playbook
```bash
ansible-playbook k8s-install.yaml -i env/inventory
```
Install Kubernetes, Master, Workers, Load Balancer.

Test on your local machine if all works after few minutes:
```bash
kubectl get pods --all-namespaces
```

## Get Kube Config from Master Node
```bash
ansible-playbook get-kubeconfig.yaml -i env/inventory
```

## Delete Kubernetes and destroy Infrastructure Ansible Playbook Terrafom Module
```bash
ansible-playbook destroy-infrastructure.yaml
```
The Playbook execute Terraform and destroy the resources (Delete Instances, Load Balancers, Networks). The working directory is "roles/tf-infrastructure/terraform/"

## Add new nodes into cluster
```bash
ansible-playbook k8s-scale.yaml -i env/inventory
```
The playbook will setup new nodes and join them already created cluster. You should run this, if you have changed workers amount bigger after creating cluster from `env/values.yaml`.

## What's happening
  - Create Infrastructure on Hetzner Cloud with Terraform (roles/tf-infrastructure/terraform/)
    - Create 1 master
    - Create up to 4 different workers (depends on config-types)
    - Create a hetzner loadbalancer
  - Prepare Kubernetes Tools and Configuration on all Servers
  - Install Master-Node
  - Join Worker-Nodes to Master
  - Install NGINX Ingress & Cert-Manager (Let's Encrypt! with prod & staging certificate)
  - Cleanup

## Caution Security
  - No network policy enabled (multi-tenancy is dangerous)
  - No pod policy - privileged pods are allowed
  - Instances/Cluster not secured by a VPC (also have public IPs)

### Credits

Credits for Installation Manual: https://github.com/cbeneke/

Ansible and Terraform created by: https://github.com/gammpamm/
