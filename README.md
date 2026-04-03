# 🚀 GitOps-Based Kubernetes Deployment on AWS (EKS + ArgoCD + Terraform)

## 📌 Overview

This project demonstrates a **production-grade GitOps CI/CD pipeline** on AWS using **Terraform, GitHub Actions, Kubernetes (EKS), and ArgoCD**. It follows a **secure 3-tier architecture**, with a React frontend hosted on Vercel and backend APIs delivered through CloudFront and ALB.

---

## 🧱 Architecture

```text
User
 ↓
Frontend (Vercel - React)
 ↓
API Call → CloudFront (CDN + HTTPS)
 ↓
Application Load Balancer (Public Subnet)
 ↓
Kubernetes Ingress (EKS)
 ↓
Service (ClusterIP)
 ↓
Spring Boot Pods (Private Subnet)
 ↓
PostgreSQL (RDS - Private DB Subnet)
```

---

## ⚙️ Infrastructure (Terraform)

All infrastructure is provisioned using **Terraform (IaC)**:

### ✅ Resources Created

* VPC (10.0.0.0/16)
* 2 Public Subnets (ALB)
* 2 Private Subnets (EKS)
* 2 Private DB Subnets (RDS)
* Internet Gateway + NAT Gateway
* EKS Cluster + Managed Node Groups
* RDS (PostgreSQL)
* ECR (Docker Registry)
* IAM Roles & Policies

### 🔥 Key Highlight

```bash
terraform apply
```

➡️ Provisions complete infrastructure in a single command

---

## ☸️ Kubernetes (EKS)

* EKS cluster deployed in **private subnets**
* Workloads are **not publicly exposed**
* ALB acts as the only entry point

### Kubernetes Resources

* Deployment (Spring Boot)
* Service (ClusterIP)
* Ingress (AWS ALB)

---

## 📦 Application Stack

### 🔹 Backend

* Spring Boot (Java)
* REST APIs exposed at `/api`

### 🔹 Frontend

* React (Vercel)
* Uses environment variables to call backend APIs

### 🔹 Database

* MySQL (AWS RDS)

---

## 🐳 Containerization

* Dockerized backend application
* Images stored in AWS ECR
* Image versioning using commit SHA

---

## 🔁 CI/CD Pipeline

### 🔹 CI – GitHub Actions

Triggered on code push:

1. Build Docker image
2. Tag image using commit SHA
3. Push image to AWS ECR
4. Update Helm `values.yaml` with new image tag
5. Commit & push changes

---

### 🔹 CD – ArgoCD (GitOps)

* Git acts as **single source of truth**
* ArgoCD continuously monitors repository

```text
Git change → ArgoCD sync → Deploy to EKS
```

### Features

* Automated Sync
* Self-Healing
* Drift Detection
* Rollbacks via Git

---

## 📊 Helm Deployment

* Reusable Helm chart for application
* Environment-specific configurations via values files
* Clean separation of templates and configuration

---

## 🌐 Traffic Management

### 🔹 CloudFront (CDN Layer)

* Sits in front of backend APIs
* Provides:

  * HTTPS termination
  * Low latency via edge locations
  * Optional caching

---

### 🔹 AWS ALB Ingress

* Internet-facing ALB deployed in public subnets
* Routes `/api` traffic to Kubernetes services

---

## 🔄 Multi-Environment Setup

| Environment | Namespace | ALB      |
| ----------- | --------- | -------- |
| Dev         | dev       | Separate |
| Staging     | staging   | Separate |
| Prod        | prod      | Separate |

Each environment has:

* Isolated namespace
* Independent ALB
* Separate Kubernetes secrets

---

## 🔐 Secrets Management

* Kubernetes Secrets used for:

  * DB_HOST
  * DB_PORT
  * DB_USERNAME
  * DB_PASSWORD

* Injected via `secretKeyRef`

* Sensitive data not stored in Git

---

## 🔁 End-to-End Flow

```text
Code Push
 ↓
GitHub Actions (CI)
 ↓
Docker Build + Push (ECR)
 ↓
Update Helm Values
 ↓
Git Push
 ↓
ArgoCD (CD)
 ↓
Deploy to EKS
 ↓
CloudFront → ALB → Application
```

---

## 🔐 Security Best Practices

* EKS nodes in private subnets
* RDS isolated in DB subnet
* No direct public access to backend
* ALB is only entry point
* Secrets managed securely

---

## 🧠 Key Concepts Demonstrated

* Infrastructure as Code (Terraform)
* GitOps (ArgoCD)
* CI/CD separation (GitHub Actions + ArgoCD)
* Kubernetes (EKS)
* Helm templating
* AWS networking (VPC, ALB, CloudFront)
* Secure 3-tier architecture
* Containerized deployments

---

# 🚀 Getting Started (Step-by-Step Guide)

Follow these steps to set up and deploy the project end-to-end.

---

## 🧾 Prerequisites

Make sure you have:

* AWS Account
* AWS CLI configured (`aws configure`)
* Docker installed
* kubectl installed
* Helm installed
* Terraform installed
* Git installed

---

## ⚙️ Step 1: Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO
```

---

## 🏗️ Step 2: Provision Infrastructure (Terraform)

Navigate to infra folder:

```bash
cd infra
```

Initialize Terraform:

```bash
terraform init
```

Apply infrastructure:

```bash
terraform apply
```

This will create:

* VPC (public, private, DB subnets)
* EKS cluster
* RDS database
* ECR repository
* IAM roles

---

## 🔗 Step 3: Configure kubectl

```bash
aws eks --region <region> update-kubeconfig --name <cluster-name>
```

Verify:

```bash
kubectl get nodes
```

---

## 🚀 Step 4: Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Wait for pods:

```bash
kubectl get pods -n argocd
```

---

## 🔐 Step 5: Access ArgoCD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open:

```text
https://localhost:8080
```

Get password:

```bash
kubectl get secret argocd-initial-admin-secret \
-n argocd \
-o jsonpath="{.data.password}" | base64 --decode
```

---

## 🐳 Step 6: Build & Push Docker Image

```bash
docker build -t spring-app .
docker tag spring-app:latest <ECR_URL>:latest
docker push <ECR_URL>:latest
```

---

## 🔐 Step 7: Create Kubernetes Secret

```bash
kubectl create namespace dev

kubectl create secret generic db-secret \
  --from-literal=DB_HOST=<db-endpoint> \
  --from-literal=DB_PORT=5432 \
  --from-literal=DB_USERNAME=<username> \
  --from-literal=DB_PASSWORD=<password> \
  -n dev
```

---

## 📦 Step 8: Deploy Application via ArgoCD

Apply ArgoCD application:

```bash
kubectl apply -f gitops/apps/dev/spring-app.yaml
```

---

## 🔍 Step 9: Verify Deployment

```bash
kubectl get pods -n dev
kubectl get svc -n dev
kubectl get ingress -n dev
```

---

## 🌐 Step 10: Access Backend API

Get ALB URL:

```bash
kubectl get ingress -n dev
```

Test:

```text
http://<ALB-DNS>/api
```

---

## 🌍 Step 11: Setup Frontend (Vercel)

1. Deploy React app on Vercel
2. Add environment variable:

```text
VITE_API_URL=http://<ALB-DNS>/api
```

---

## 🔄 Step 12: CI/CD Flow

Once setup is complete:

```text
Code Push → GitHub Actions → Build & Push Image → Update Helm → ArgoCD Deploy
```

---

## 🧪 Step 13: Test End-to-End

* Open frontend (Vercel URL)
* Perform API action
* Verify backend response

---

## 🧹 Cleanup (Optional)

```bash
terraform destroy
```

---

## 🚀 You're Done!

You now have a fully working:

* GitOps CI/CD pipeline
* Kubernetes deployment
* Cloud-native architecture
* Multi-environment setup


## 🔥 Highlights

* Fully automated CI/CD pipeline
* Production-grade cloud architecture
* Secure and scalable design
* Real-world DevOps toolchain

---

## 🧠 Interview Summary

> Built an end-to-end GitOps CI/CD pipeline on AWS using Terraform for infrastructure provisioning, GitHub Actions for CI, and ArgoCD for CD, with CloudFront and ALB enabling scalable and secure traffic routing.

---

## 🚀 Future Enhancements

* AWS Secrets Manager + External Secrets
* Custom domain + HTTPS (ACM)
* Monitoring (Prometheus + Grafana)
* ArgoCD ApplicationSet for multi-env automation

---

## 📌 Author

**DevOps Project – GitOps on AWS EKS**





<img width="727" height="130" alt="Screenshot From 2026-04-02 14-18-10" src="https://github.com/user-attachments/assets/315bc911-d023-427d-a527-56d247c7d4eb" />
<img width="727" height="130" alt="Screenshot From 2026-04-02 14-18-46" src="https://github.com/user-attachments/assets/cd813626-81cd-437d-b6e4-48f65e624148" />
<img width="727" height="130" alt="Screenshot From 2026-04-02 14-19-22" src="https://github.com/user-attachments/assets/063bdd06-5432-4a0f-a915-25415f50a3ae" />
<img width="727" height="130" alt="Screenshot From 2026-04-02 14-19-50" src="https://github.com/user-attachments/assets/20b8faa5-2cfe-42c4-a2a4-2593f91e0a21" />
<img width="727" height="130" alt="Screenshot From 2026-04-02 14-20-10" src="https://github.com/user-attachments/assets/62cdd077-990e-4ae1-8787-2b2627be0c1c" />
<img width="727" height="130" alt="Screenshot From 2026-04-02 14-20-35" src="https://github.com/user-attachments/assets/bdb0a4ba-e4c5-4240-9a2b-e62324b32ffe" />
<img width="727" height="130" alt="Screenshot From 2026-04-02 14-21-08" src="https://github.com/user-attachments/assets/e8f53822-32f5-4fac-b86a-e32ed3eef54f" />
<img width="727" height="130" alt="Screenshot From 2026-04-02 14-21-29" src="https://github.com/user-attachments/assets/aad01625-7d54-4079-a995-e6aa41935085" />
<img width="727" height="130" alt="Screenshot From 2026-04-02 14-21-50" src="https://github.com/user-attachments/assets/ebbce394-aea4-478f-a428-7d561d830ef4" />
<img width="727" height="130" alt="Screenshot From 2026-04-02 14-22-26" src="https://github.com/user-attachments/assets/c3ae8ce7-7df9-4a6d-8a2b-524415d27ef4" />
<img width="735" height="117" alt="Screenshot From 2026-04-02 14-24-22" src="https://github.com/user-attachments/assets/7f1eab42-37ff-49e2-8928-fc291f99e13e" />
<img width="735" height="117" alt="Screenshot From 2026-04-02 14-25-02" src="https://github.com/user-attachments/assets/00074ea9-26fb-49b5-825c-3bd8494abbf9" />
# Spring Boot + React + MySQL: CRUD example

For more detail, please visit:
> [How to integrate Spring Boot with React.js](https://bezkoder.com/integrate-reactjs-spring-boot/)

> [React (Components) CRUD example to consume Web API](https://bezkoder.com/react-crud-web-api/)

> [React (Hooks) CRUD example to consume Web API](https://bezkoder.com/react-hooks-crud-axios-api/)

> [Spring Boot JPA - Building Rest CRUD API example](https://bezkoder.com/spring-boot-jpa-crud-rest-api/)

Fullstack with Spring Boot:
> [React.js + Spring Boot + MySQL](https://bezkoder.com/react-spring-boot-crud/)

> [React.js + Spring Boot + PostgreSQL](https://bezkoder.com/spring-boot-react-postgresql/)

> [React.js + Spring Boot + MongoDB](https://bezkoder.com/react-spring-boot-mongodb/)

More Practice:
> [React (Hooks) CRUD example to consume Web API](https://bezkoder.com/react-hooks-crud-axios-api/)

> [React Material UI examples with a CRUD Application](https://bezkoder.com/react-material-ui-examples-crud/)

> [Spring Boot Pagination & Filter example | Spring JPA, Pageable](https://bezkoder.com/spring-boot-pagination-filter-jpa-pageable/)

> [Spring Data JPA Sort/Order by multiple Columns | Spring Boot](https://bezkoder.com/spring-data-sort-multiple-columns/)

> [Spring Boot Repository Unit Test with @DataJpaTest](https://bezkoder.com/spring-boot-unit-test-jpa-repo-datajpatest/)

> [Deploy Spring Boot App on AWS – Elastic Beanstalk](https://bezkoder.com/deploy-spring-boot-aws-eb/)

Serverless:
> [React Firebase CRUD App with Realtime Database](https://bezkoder.com/react-firebase-crud/)

> [React Firestore CRUD App example | Firebase Cloud Firestore](https://bezkoder.com/react-firestore-crud/)

## Project setup
```
mvn clean install
```

### Run
```
mvn spring-boot:run
```
