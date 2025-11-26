# DevOps Monitoring & Deployment Infrastructure

This project sets up a complete cloud-native monitoring and deployment environment using **Prometheus**, **Grafana**, **ArgoCD**, **Kubernetes**, and automated CI/CD using **GitHub Actions**.

It is built to provide full observability into Kubernetes workloads, especially **ArgoCD Application health, sync status, and controller performance**, using custom Grafana dashboards.

---

## 🚀 Features

### 🔹 **1. Kubernetes Cluster Deployment (Terraform)**

* Infrastructure provisioned using Terraform.
* Master and Worker nodes deployed in private subnets.
* Bastion/SSM-based access to private nodes.
* Automated kubeadm initialization using Terraform + remote-exec.

### 🔹 **2. Prometheus Monitoring Stack (Helm Chart)**

* Installed using the official **prometheus-community/kube-prometheus-stack** chart.
* Includes:

  * Prometheus Server
  * Alertmanager
  * Node Exporter
  * Kube State Metrics
  * ServiceMonitors & PodMonitors

### 🔹 **3. Full ArgoCD Monitoring Integration**

* Added `ServiceMonitor` for all ArgoCD components:

  * application-controller
  * repo-server
  * server
  * redis
  * notifications
  * applicationset controller
* Prometheus now automatically scrapes ArgoCD metrics.

### 🔹 **4. Grafana Dashboards for ArgoCD**

* Custom dashboards for:

  * ArgoCD sync status
  * OutOfSync application count
  * Deployment frequencies
  * ArgoCD controller performance
* Dashboards are generated via JSON in a dedicated directory:

```
├── grafana-argocd-dashboard-scripts
│   ├── argocd-dashboard-alternative-2.json
│   ├── argocd-dashboard-alternative.json
│   └── argocd-dashboard.json
```

### 🔹 **5. CI/CD via GitHub Actions**

* Fully automated pipeline:

  * On push → build → test → deploy application.
  * Deploys container images to EC2/K8s using GitHub Secrets.
  * Trigger ArgoCD sync automatically.
  * Uses environment-specific workflows (dev/prod).

---

## 📊 Monitoring Metrics Included

### **ArgoCD Metrics Captured**

* `argocd_app_sync_total`
* `argocd_app_health_status`
* `argocd_app_sync_status`
* `argocd_app_unhealthy`
* `argocd_app_info`
* `etc`


### **Node & Cluster Metrics**

* CPU / RAM usage
* Pod/Node availability
* API server health
* Kubelet performance

---

## 🧩 Folder Structure

```
├── grafana-argocd-dashboard-scripts
│   ├── argocd-dashboard-alternative-2.json
│   ├── argocd-dashboard-alternative.json
│   └── argocd-dashboard.json
├── k8s-setup
│   ├── config
│   │   └── dev.tfvars
│   ├── data.tf
│   ├── main.tf
│   ├── modules
│   │   ├── argocd
│   │   │   ├── argocd_app.yaml
│   │   │   ├── argocd_projects_apps.yaml
│   │   │   ├── argocd_repo.yaml
│   │   │   ├── github_secret.yaml
│   │   │   ├── main.tf
│   │   │   └── variable.tf
│   │   ├── iam
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variable.tf
│   │   ├── manager
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   ├── user_data_ssm.sh
│   │   │   └── variable.tf
│   │   ├── monitoring
│   │   │   └── main.tf
│   │   └── nodes
│   │       ├── main.tf
│   │       ├── output.tf
│   │       ├── user_data_master.sh
│   │       ├── user_data_worker.sh
│   │       └── variables.tf
│   ├── output.tf
│   ├── provider.tf
│   └── variables.tf
├── network
│   ├── config
│   │   └── dev.tfvars
│   ├── main.tf
│   ├── modules
│   │   ├── bastion
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   ├── user_data.sh
│   │   │   └── variables.tf
│   │   └── vpc
│   │       ├── main.tf
│   │       ├── output.tf
│   │       └── variables.tf
│   ├── output.tf
│   ├── provider.tf
│   └── variable.tf
└── README.md

```

---

## 🛠️ How to Deploy

First setup the `network` by going inside the network and running 
```
terraform init
terraform apply -var-file=config/dev.tfvars
```
Then go inside the bashion and clone the code of `k8s-setup` and than than run:

```
terraform init
terraform apply -var-file=config/dev.tfvars
```
### **Prometheus Dashboards**
Run this for accessing the prometheus dashboard.
```
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
```
### ** Import Grafana Dashboards**
For accessing the grafana UI.
```
kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80
```
1. Run this to access the grafana dashboard UI.
2. The username will be `admin` and the the password will be `admin123`.
3. After logging in click in `+` icon and than paste the json file there to import the dashboard. The json files are present in the dir `grafana-argocd-dashboard-scripts`.

## 🎯 Purpose of This Project

This setup is designed for:

* Complete observability of ArgoCD deployments.
* Understanding sync failures, performance, and app status.
* Monitoring Kubernetes cluster health.
* Automated CI/CD pipelines using GitHub Actions.
* Production-grade infrastructure with Terraform + Helm.

---
