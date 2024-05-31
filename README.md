






============================================================================================================================================================================================================================================================================================================================================================================================================

{
  echo "Directory Structure:";
  tree;
  echo "";

  # Print the contents of the workflow files in .github/workflows
  find .github/workflows -type f \( -name "*.yaml" -o -name "*.yml" \) -print -exec echo "Contents of {}:" \; -exec cat {} \; -exec echo "" \;
} > tree_and_workflows.txt






Project Tickets Summary
1:
Establish Amazon EKS Cluster

Summary:
Deploy an EKS cluster using CloudFormation and Makefile automation from the platform-tools repository, ensuring successful deployment of platform tools including ingress-nginx.

Tasks:

Review automation scripts in the eks-cloudformation folder.
Verify and update Kubernetes version if outdated.
Manually trigger EKS cluster creation using GitHub Actions.
Validate platform tools deployment, especially ingress-nginx.
Acceptance Criteria:

Operational EKS cluster.
Up-to-date Kubernetes version.
Successful platform tools deployment.

2:
Create EKS Cluster with Terraform

Summary:
Create an Amazon EKS cluster within a VPC using Terraform, focusing on modular architecture and GitHub Actions.

Tasks:

Develop Terraform modules for EKS and VPC.
Implement multi-environment setup (dev, staging, prod).
Configure GitHub Actions for Terraform execution.
Establish VPC and EKS cluster configurations.
Acceptance Criteria:

Operational EKS cluster and VPC via Terraform.
Detailed README on deployment strategy and configuration.

3: 
CI/CD for Weather App (Kubernetes)

Summary:
Configure the backend of the Weather app for automatic deployment via GitHub Actions using Helm charts.

Tasks:

Set up Docker, AWS ECR, and Helm for app deployment.
Configure environments (dev, staging, prod) with hostnames.
Integrate AWS Secrets Manager with Kubernetes.
Implement TLS for security.
Acceptance Criteria:

Fully deployed Weather app in dev environment.
Accessible API endpoints with configured hostnames.
Comprehensive README on deployment strategy.


4:
EFK Logging Solution with S3 Redundancy

Summary:
Implement the EFK stack for logging in AWS EKS, with FluentD configured to send logs to Amazon S3.

Tasks:

Deploy EFK using Helm.
Configure security and redundancy.
Update documentation.
Acceptance Criteria:

Functional EFK stack in dev environment.
Secure, accessible Kibana endpoints.
FluentD sending logs to Elasticsearch and S3.



5:
Setup Monitoring for Kubernetes Cluster

Summary:
Replace Datadog with Prometheus and Grafana for monitoring AWS EKS.

Tasks:

Deploy Prometheus and Grafana using Helm.
Configure security and accessibility.
Update documentation.
Acceptance Criteria:

Operational Prometheus and Grafana in dev environment.
Accessible Grafana endpoints with proper authentication.
Comprehensive setup documentation.



6:
Automate IAM Roles and Policies Creation

Summary:
Automate the creation of IAM roles and policies using Terraform and GitHub Actions.

Tasks:

Develop Terraform module for IAM setup.
Implement multi-environment configuration.
Configure GitHub Actions for Terraform execution.
Acceptance Criteria:

Functional IAM roles and policies.
Comprehensive README on setup and configuration.



7:
Cluster Autoscaler Setup

Summary:
Implement cluster-autoscaler for AWS EKS to enable automatic node scaling.

Tasks:

Deploy cluster-autoscaler with Helm.
Configure GitHub Actions for deployment.
Validate autoscaling functionality.
Acceptance Criteria:

Functional cluster-autoscaler.
Comprehensive documentation and demonstration.



8:
Secure Developer User in Kubernetes

Summary:
Configure a secure ReadOnly Kubernetes user mapped to Developer IAM role.

Tasks:

Set up Kubernetes user and map to IAM role.
Restrict permissions using RBAC.
Update documentation.
Acceptance Criteria:

Secure ReadOnly Kubernetes user.
Detailed README on user setup and security.


9:
Automate Route53 Records with External-DNS

Summary:
Configure Kubernetes to manage DNS records in AWS Route 53 using external-dns.

Tasks:

Implement external-dns in Kubernetes.
Deploy configurations using GitHub Actions.
Update documentation.
Acceptance Criteria:

Functional automatic DNS record creation.
Comprehensive setup documentation.



10:
Create RDS MySQL for Versus App

Summary:
Set up an RDS MySQL database for the Versus App using Terraform and GitHub Actions.

Tasks:

Develop Terraform module for RDS setup.
Implement multi-environment configuration.
Configure GitHub Actions for Terraform execution.
Acceptance Criteria:

Functional RDS MySQL database.
Detailed README on deployment and configuration.



11:
Final Cleanup

Summary:
Ensure no resources are left in the AWS account after project completion.

12:
Serverless Application Deployment

Summary:
Automate deployment of a serverless full-stack web application using Terraform and GitHub Actions.

Tasks:

Implement CI/CD pipeline for serverless architecture.
Deploy AWS serverless components.
Update documentation.
Acceptance Criteria:

Operational serverless application.
Comprehensive deployment documentation.


13:
Proshop App Deployment Automation

Summary:
Configure CI/CD pipeline to build and deploy Proshop app via GitHub Actions.

Tasks:

Set up Docker, AWS ECR, and Helm for deployment.
Configure environments (dev, staging, prod).
Integrate AWS Secrets Manager with Kubernetes.
Implement TLS for security.
Acceptance Criteria:

Fully deployed Proshop app in dev environment.
Accessible API endpoints with configured hostnames.
Comprehensive README on deployment strategy.



14:
Provision MongoDB for Proshop App

Summary:
Set up an AWS DocumentDB for Proshop app using Terraform and GitHub Actions.

Tasks:

Develop Terraform module for DocumentDB setup.
Implement multi-environment configuration.
Configure GitHub Actions for Terraform execution.
Acceptance Criteria:

Functional DocumentDB database.
Detailed README on deployment and configuration.


15:
Set Up GitLab Runner in Kubernetes

Summary:
Create a GitLab account and set up GitLab Runner in Kubernetes for CI/CD.

Tasks:

Create GitLab account.
Deploy GitLab Runner using Helm.
Configure security and access controls.
Update documentation.
Acceptance Criteria:

Operational GitLab Runner in Kubernetes.
Comprehensive documentation.


16:
Versus App Deployment with Packer

Summary:
Automate deployment of Versus app on AWS EC2 using Packer, Terraform, and GitLab CI.

Tasks:

Create custom AMI with Packer.
Use Terraform for infrastructure setup.
Configure GitLab CI for deployment.
Implement systemd service for app management.
Acceptance Criteria:

Seamless Versus app deployment.
Comprehensive deployment documentation.


17:
CI/CD for Versus App on Kubernetes

Summary:
Configure Versus app for deployment via GitLab CI/CD.

Tasks:

Set up Docker, AWS ECR, and Helm for deployment.
Configure environments (dev, staging, prod).
Integrate AWS Secrets Manager with Kubernetes.
Implement TLS for security.
Acceptance Criteria:

Fully deployed Versus app in dev environment.
Accessible API endpoints with configured hostnames.
Comprehensive README on deployment strategy.




structure we already have : 


terraform-infra-23d-centos 


Directory Structure:
.
├── README.md
├── dummy-module-1
│   ├── locals.tf
│   ├── outputs.tf
│   ├── resources.tf
│   └── variables.tf
├── dummy-module-2
│   ├── locals.tf
│   ├── resources.tf
│   └── variables.tf
├── roots
│   └── devops-project-main
│       ├── dev.tfvars
│       ├── main.tf
│       ├── production.tfvars
│       ├── providers.tf
│       ├── staging.tfvars
│       └── variables.tf
└── tree_and_workflows.txt

5 directories, 15 files

.github/workflows/terraform-deploy.yaml
Contents of .github/workflows/terraform-deploy.yaml:
name: 'Workflow - Deploy on multi-account AWS with Terraform'
on:
  # trigger/start job when push happens to any of specified branches
  push:
    branches:
    - feature/**
    - main
    # - staging
# required permissions by GitHub Actions for assuming AWS IAM role
permissions:
  id-token: write # This is required for requesting the JWT
  contents: read  # This is required for actions/checkout
env:
  AWS_REGION: "us-east-1"
  # ENVIRONMENT_STAGE: ${{ (github.ref == 'refs/heads/main' && 'production') || (github.ref == 'refs/heads/staging' && 'staging') || 'dev' }}
  # since production and staging are not ready, deploy only to dev for now
  ENVIRONMENT_STAGE: "dev"

jobs:
  deploy-terraform:
    runs-on: ubuntu-latest
    # default settings to apply for all the steps
    defaults:
      run:
        working-directory: ./roots/devops-project-main
        shell: bash
    # environment: ${{ (github.ref == 'refs/heads/main' && 'production') || (github.ref == 'refs/heads/staging' && 'staging') || 'dev' }}
    # since production and staging are not ready, deploy only to dev for now
    environment: dev
    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # equivalent of "git clone repo"
      - uses: actions/checkout@v3

      # login to AWS
      - name: configure aws credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ vars.IAM_ROLE }}
          role-session-name: GitHubActionsRoleSession
          aws-region: ${{ env.AWS_REGION }}

      # Initialize a new or existing Terraform working directory by creating initial files, loading any remote state, downloading modules, etc.
      - name: Terraform Init
        run: |
          AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
          terraform init -backend-config="bucket=${AWS_ACCOUNT_ID}-state-bucket-${ENVIRONMENT_STAGE}" -backend-config="key=${GITHUB_REF#refs/heads/}.tfstate"

      # Checks that all Terraform configuration files adhere to a canonical format
      - name: Terraform Format
        run: terraform fmt -check

      # Generates an execution plan for Terraform
      - name: Terraform Plan
        run: terraform plan -input=false -var-file=${ENVIRONMENT_STAGE}.tfvars

      # Build infrastructure according to Terraform configuration files
      - name: Terraform Apply
        run: terraform apply -auto-approve -input=false -var-file=${ENVIRONMENT_STAGE}.tfvars

.github/workflows/terraform-destroy-dev.yaml
Contents of .github/workflows/terraform-destroy-dev.yaml:
# this is a temporary workaround pipeline
# that's only necessary because we don't have separate Staging and Production account yet
name: 'Workflow - Terraform Destroy before merge'

on:
  pull_request_review:
    types: [submitted]

env:
    AWS_REGION : "us-east-1"
    ENVIRONMENT_STAGE: "dev"
# permission can be added at job level or workflow level
permissions:
    id-token: write   # This is required for requesting the JWT
    contents: read    # This is required for actions/checkout
jobs:
  destroy_dev:
    # if PR is into main branch,
    # and if PR approval was received
    if: github.event.pull_request.base.ref == 'main' && github.event.review.state == 'APPROVED'
    runs-on: ubuntu-latest
    # default settings to apply for all the steps
    defaults:
      run:
        working-directory: ./roots/devops-project-main
        shell: bash
    environment: dev
    steps:
      # equivalent of "git clone repo"
      - uses: actions/checkout@v3

      # login to AWS
      - name: configure aws credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ vars.IAM_ROLE }}
          role-session-name: GitHubActionsRoleSession
          aws-region: ${{ env.AWS_REGION }}

      # Initialize a new or existing Terraform working directory by creating initial files, loading any remote state, downloading modules, etc.
      - name: Terraform Init
        run: |
          AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
          terraform init -backend-config="bucket=${AWS_ACCOUNT_ID}-state-bucket-${ENVIRONMENT_STAGE}" -backend-config="key=${{ github.event.pull_request.head.ref }}.tfstate"

      # Destroy all resources before merge into main branch
      - name: Terraform Destroy
        run: terraform destroy -auto-approve -input=false -var-file=${ENVIRONMENT_STAGE}.tfvars




platform-tools-23d-centos 


Directory Structure:
.
├── README.md
├── cluster-autoscaler
│   └── README.md
├── eks-cloudformation
│   ├── Makefile
│   ├── README.md
│   ├── cloudformation
│   │   ├── amazon-eks-nodegroup.yaml
│   │   ├── cfn-resource-provider.yaml
│   │   ├── ec2-sshkeypair.yaml
│   │   ├── eks.yaml
│   │   └── iam.yaml
│   ├── cluster_config
│   └── kubernetes
│       └── aws-auth-cm.yaml
├── eks-logging
│   └── README.md
├── eks-monitoring
│   └── README.md
├── external-dns
│   └── README.md
├── ingress-nginx
│   ├── README.md
│   └── deploy.yaml
├── k8s-user-roles
│   └── README.md
├── state-buckets-manual
│   └── buckets.tf
└── tree_and_workflows.txt

11 directories, 19 files

.github/workflows/eks-setup-manual-trigger.yaml
Contents of .github/workflows/eks-setup-manual-trigger.yaml:
# Manually triggered workflow
name: 'EKS Cluster Setup with CloudFormation'

on:
  workflow_dispatch:
    inputs:
      environment_stage:
        description: 'Environment Stage for Manual EKS Setup'
        required: true
        default: 'dev'

permissions:
    id-token: write
    contents: read
          
env:
  AWS_REGION: "us-east-1"

jobs:
  setup-eks-cluster:
    runs-on: ubuntu-latest
    defaults:
        run:
          shell: bash
    environment: ${{ github.event.inputs.environment_stage }}
    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ vars.IAM_ROLE }}
          role-session-name: GitHubActionsRoleSession
          aws-region: ${{ env.AWS_REGION }}

      # Official installation instructions from https://eksctl.io/installation/
      - name: Install eksctl
        run: |
          ARCH=amd64
          PLATFORM=$(uname -s)_$ARCH
          curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
          tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
          sudo mv /tmp/eksctl /usr/local/bin
          eksctl version

      # Create EKS cluster with CloudFormation
      # both AWSReservedSSO_Administrator-* role and an IAM role running this job should get full access to this EKS cluster
      - name: Create EKS Cluster with CloudFormation
        run: |
          SSO_ADMIN_ROLE=$(aws iam list-roles --query "Roles[?starts_with(RoleName, 'AWSReservedSSO_Administrator')].RoleName" --output text)
          make cluster name=temporary-eks-cluster-${{ github.event.inputs.environment_stage }} version=1.28 role=$SSO_ADMIN_ROLE
        working-directory: ./eks-cloudformation

      # Login to EKS
      - name: Login to EKS - update kubeconfig
        run: aws eks update-kubeconfig --name temporary-eks-cluster-${{ github.event.inputs.environment_stage }} --region $AWS_REGION

      # Display aws-auth configmap
      - name: View the new IAM to Kubernetes RBAC mapping
        run: kubectl -n kube-system get configmap aws-auth -o yaml

.github/workflows/deploy-platform-tools.yaml
Contents of .github/workflows/deploy-platform-tools.yaml:
# This worflow is primarily for platform/devops tools that need to be deployed into K8s cluster
# or tools that don't belong to Terraform
name: 'Workflow - Deploy Platform Tools'

on:
  push:
    branches:
      - feature/**
      - main

permissions:
  id-token: write
  contents: read

env:
  AWS_REGION: "us-east-1"
  ENVIRONMENT_STAGE: "dev"

jobs:
  deploy-platform-tools:
    runs-on: ubuntu-latest
    defaults:
      run:
        shell: bash
    environment: dev

    steps:
      - uses: actions/checkout@v3

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ vars.IAM_ROLE }}
          role-session-name: GitHubActionsRoleSession
          aws-region: ${{ env.AWS_REGION }}

      # Login to EKS, make sure to switch to the permanent cluster created with terraform once it's up
      - name: Login to EKS - update kubeconfig
        run: aws eks update-kubeconfig --name temporary-eks-cluster-${ENVIRONMENT_STAGE} --region $AWS_REGION

      # Add deployment steps for each tool below
      - name: Deploy ingress-nginx controller
        run: kubectl apply -f ingress-nginx/deploy.yaml

      # Example for a tool like Cluster Autoscaler
      - name: Deploy Cluster Autoscaler
        run: |
            echo "Deploy Cluster Autoscaler steps go here"

      # Example for a tool like EKS Logging
      - name: Deploy EKS Logging
        run: |
            echo "Deploy EKS Logging steps go here"

      # Repeat for each additional tool...
      # Example: Deploy External DNS
      # Example: Setup K8s User Roles

      - name: Finalize Deployment
        run: |
            echo "Final deployment steps and cleanup"



proshop-23d-centos



Directory Structure:
.
├── README.md
├── backend
│   ├── config
│   │   └── db.js
│   ├── controllers
│   │   ├── orderController.js
│   │   ├── productController.js
│   │   └── userController.js
│   ├── data
│   │   ├── products.js
│   │   └── users.js
│   ├── middleware
│   │   ├── asyncHandler.js
│   │   ├── authMiddleware.js
│   │   ├── checkObjectId.js
│   │   └── errorMiddleware.js
│   ├── models
│   │   ├── orderModel.js
│   │   ├── productModel.js
│   │   └── userModel.js
│   ├── routes
│   │   ├── orderRoutes.js
│   │   ├── productRoutes.js
│   │   ├── uploadRoutes.js
│   │   └── userRoutes.js
│   ├── seeder.js
│   ├── server.js
│   └── utils
│       ├── calcPrices.js
│       ├── generateToken.js
│       └── paypal.js
├── frontend
│   ├── README.md
│   ├── package-lock.json
│   ├── package.json
│   ├── public
│   │   ├── favicon.ico
│   │   ├── images
│   │   │   ├── airpods.jpg
│   │   │   ├── alexa.jpg
│   │   │   ├── camera.jpg
│   │   │   ├── mouse.jpg
│   │   │   ├── phone.jpg
│   │   │   ├── playstation.jpg
│   │   │   ├── sample.jpg
│   │   │   └── screens.png
│   │   ├── index.html
│   │   ├── logo192.png
│   │   ├── logo512.png
│   │   ├── manifest.json
│   │   └── robots.txt
│   └── src
│       ├── App.js
│       ├── assets
│       │   ├── logo.png
│       │   └── styles
│       │       ├── bootstrap.custom.css
│       │       └── index.css
│       ├── components
│       │   ├── AdminRoute.jsx
│       │   ├── CheckoutSteps.jsx
│       │   ├── Footer.jsx
│       │   ├── FormContainer.jsx
│       │   ├── Header.jsx
│       │   ├── Loader.jsx
│       │   ├── Message.jsx
│       │   ├── Meta.jsx
│       │   ├── Paginate.jsx
│       │   ├── PrivateRoute.jsx
│       │   ├── Product.jsx
│       │   ├── ProductCarousel.jsx
│       │   ├── Rating.jsx
│       │   └── SearchBox.jsx
│       ├── constants.js
│       ├── index.js
│       ├── reportWebVitals.js
│       ├── screens
│       │   ├── CartScreen.jsx
│       │   ├── HomeScreen.jsx
│       │   ├── LoginScreen.jsx
│       │   ├── OrderScreen.jsx
│       │   ├── PaymentScreen.jsx
│       │   ├── PlaceOrderScreen.jsx
│       │   ├── ProductScreen.jsx
│       │   ├── ProfileScreen.jsx
│       │   ├── RegisterScreen.jsx
│       │   ├── ShippingScreen.jsx
│       │   └── admin
│       │       ├── OrderListScreen.jsx
│       │       ├── ProductEditScreen.jsx
│       │       ├── ProductListScreen.jsx
│       │       ├── UserEditScreen.jsx
│       │       └── UserListScreen.jsx
│       ├── setupTests.js
│       ├── slices
│       │   ├── apiSlice.js
│       │   ├── authSlice.js
│       │   ├── cartSlice.js
│       │   ├── ordersApiSlice.js
│       │   ├── productsApiSlice.js
│       │   └── usersApiSlice.js
│       ├── store.js
│       └── utils
│           └── cartUtils.js
├── package-lock.json
├── package.json
├── pnpm-lock.yaml
├── static
│   └── documentdb_connection.png
├── tree_and_workflows.txt
└── uploads

22 directories, 90 files










