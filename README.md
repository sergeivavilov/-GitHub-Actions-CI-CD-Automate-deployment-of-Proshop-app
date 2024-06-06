{
  echo "Directory Structure:";
  tree;
  echo "";

  # Print the contents of the workflow files in .github/workflows
  find .github/workflows -type f \( -name "*.yaml" -o -name "*.yml" \) -print -exec echo "Contents of {}:" \; -exec cat {} \; -exec echo "" \;

  # Print the contents of the Terraform configuration files
  find . -type f \( -name "*.tf" -o -name "*.tfvars" \) -print -exec echo "Contents of {}:" \; -exec cat {} \; -exec echo "" \;

  # Print the contents of Dockerfiles
  find . -type f -name "Dockerfile" -print -exec echo "Contents of {}:" \; -exec cat {} \; -exec echo "" \;

  # Print the contents of Helm chart files
  find ./helm -type f \( -name "*.yaml" -o -name "*.yml" \) -print -exec echo "Contents of {}:" \; -exec cat {} \; -exec echo "" \;
} > tree_and_files.txt


================================================================================================================================================================================================================================================



# ProShop Application Deployment Guide

# Automated CI/CD Pipeline for a Full-Stack Application

This README describes the creation and configuration of an automated CI/CD pipeline using GitHub Actions, Helm, Docker, AWS IAM, and Kubernetes Ingress for an application with both frontend and backend components.

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Architecture Overview](#architecture-overview)
4. [GitHub Actions](#github-actions)
5. [Docker and Amazon ECR](#docker-and-amazon-ecr)
6. [AWS IAM](#aws-iam)
7. [Helm](#helm)

## Introduction

This is an automated CI/CD pipeline for a full-stack application. The pipeline leverages GitHub Actions for CI/CD, Docker for containerization, Helm for Kubernetes deployment management, AWS IAM for secure access management, AWS Secrets Manager for credentials, and Kubernetes Ingress for routing and load balancing.

## Prerequisites

Before you begin, ensure you have the following:

- A GitHub account with access to the repository.
- Docker installed on your local machine.
- Helm installed on your local machine.
- AWS CLI installed and configured with appropriate IAM permissions.
- A Kubernetes cluster (e.g., EKS) with `kubectl` configured to interact with it.
- Domain names configured according to the specified hostname

## Architecture Overview

The architecture of the pipeline is designed to streamline the deployment process. Here is an overview:

- **Frontend and Backend Repositories:** Separate folders for frontend and backend code.
- **GitHub Actions:** Workflows defined to automate build, test, and deployment processes.
- **Docker:** Containerizes the application for consistency across different environments.
- **Helm:** Manages Kubernetes manifests and deployment configurations.
- **AWS IAM:** Secures access to AWS resources.
- **AWS Secrets:** Stores credentials.
- **Kubernetes Ingress:** Manages routing and load balancing for the application.

## GitHub Actions

GitHub Actions are used to automate the CI/CD process. Here’s a breakdown of the steps:

### Workflow Files

- `.github/workflows/cicd.yml`: Defines the workflow for the whole application. It includes steps from building and pushing a Docker image to ECR repository to deploying it with helm charts in EKS cluster.

### Key Steps

1. **Checkout Code:** Uses `actions/checkout@v3` to fetch the latest code.
2. **Build and Test:** Runs the build and test commands for both frontend and backend.
3. **Docker Build and Push:** Builds Docker images and pushes them to Docker Hub or an AWS ECR repository.
4. **Deploy with Helm:** Deploys the application to the Kubernetes cluster using Helm. (Not yet)

### Detailed Look Into Workflow File

- **Triggers**: 
  - The workflow is triggered on pushes to branches matching `feature/**`.

- **Permissions**:
  - The workflow requires specific permissions to assume the AWS IAM role:
    - `id-token: write`
    - `contents: read`

- **Environment Variables**:
  - `AWS_REGION`: Specifies the AWS region (`us-east-1`).
  - `ENVIRONMENT_STAGE`: Determines the deployment environment based on the branch:
    - `production` for `main`
    - `staging` for `staging`
    - `dev` for all other branches

- **Jobs**:
  - **proshop-app-build-and-deploy**:
    - Runs on `ubuntu-latest`.
    - Uses the appropriate environment based on the branch.
    - **Steps**:
      1. **Checkout Branch**:
         - Uses `actions/checkout@v3` to checkout the branch.
      2. **Configure AWS Credentials**:
         - Uses `aws-actions/configure-aws-credentials@v4` to configure AWS credentials with the specified role and region.
      3. **Login to Amazon ECR**:
         - Uses `aws-actions/amazon-ecr-login@v2` to login to Amazon ECR.
      4. **Backend - Build, tag, and push Docker image**:
         - Builds, tags, and pushes the Docker image for the backend to Amazon ECR.
         - This step is skipped for the `main` branch.
      5. **Frontend - Build, tag, and push Docker image**:
         - Builds, tags, and pushes the Docker image for the frontend to Amazon ECR.
         - This step is skipped for the `main` branch.

## Docker and Amazon ECR

This project utilizes Docker for containerization and Amazon Elastic Container Registry (ECR) for storing and managing Docker images.

### Docker

Docker is an open platform for developing, shipping, and running applications. Using Docker, we can separate our applications from our infrastructure, ensuring consistency across multiple development and release cycles. Docker allows us to package software into standardized units called containers that include everything the software needs to run, including libraries, dependencies, and configuration files.

### Amazon Elastic Container Registry (ECR)

Amazon ECR is a fully managed Docker container registry that makes it easy to store, manage, and deploy Docker container images. ECR is integrated with Amazon Elastic Container Service (ECS), simplifying the process of managing and deploying containerized applications.

### Workflow with Docker and ECR
1. **Dockerfile Creation:**
Define a Dockerfile for frontend and backend specifying the base image, dependencies, and runtime configuration.
2. **Building and Pushing Docker Images with GitHub Actions**:
Utilize GitHub Actions workflows to automate the build, tagging, and pushing of Docker images to AWS ECR.
```yaml
- name: Backend - Build, tag, and push docker image to Amazon ECR
  if: github.ref != 'refs/heads/main'
  env:
    REGISTRY: ${{ steps.login-ecr.outputs.registry }}
    REPOSITORY: proshop-backend
    IMAGE_TAG: ${{ github.sha }}
  working-directory: ./backend
  run: |
    docker build -t $REGISTRY/$REPOSITORY:$IMAGE_TAG .
    docker push $REGISTRY/$REPOSITORY:$IMAGE_TAG

- name: Frontend - Build, tag, and push docker image to Amazon ECR
  if: github.ref != 'refs/heads/main'
  env:
    REGISTRY: ${{ steps.login-ecr.outputs.registry }}
    REPOSITORY: proshop-frontend
    IMAGE_TAG: ${{ github.sha }}
  working-directory: ./frontend
  run: |
    docker build -t $REGISTRY/$REPOSITORY:$IMAGE_TAG .
    docker push $REGISTRY/$REPOSITORY:$IMAGE_TAG
```

## AWS IAM

To securely integrate AWS services with GitHub Actions, create an IAM role named `GitHubActionsCICDrole`. This role enables GitHub Actions workflows to interact with AWS services like ECR and EKS by establishing a trust relationship using OpenID Connect (OIDC).

### Setup for GitHub Actions

1. **OIDC Identity Provider**:
   - In AWS IAM, create an OIDC identity provider for GitHub Actions.
   - Use `https://token.actions.githubusercontent.com` as the provider URL and `sts.amazonaws.com` as the audience.

2. **IAM Role Creation**:
   - Create the `GitHubActionsCICDrole` with the OIDC provider as the trusted entity.
   - Define a condition to restrict the role to be assumable only by workflows from your specific GitHub repository, ensuring enhanced security.

3. **Attach Policies**:
   - Assign necessary permissions to the role for interacting with ECR for Docker image storage and EKS for Kubernetes cluster operations.
   - Ensure the policies adhere to the principle of least privilege.

### Kubernetes Cluster Access

To grant the `GitHubActionsCICDrole` permissions within your EKS cluster, update the `aws-auth` ConfigMap:

1. **Retrieve the current aws-auth ConfigMap**:
   ```bash
   kubectl get configmap/aws-auth -n kube-system -o yaml > aws-auth.yaml
   ```

2. **Edit the aws-auth.yaml file**:
   - Add the following snippet under the `mapRoles` section, replacing `<your-aws-account-id>` with your actual AWS account ID:
   ```yaml
   - rolearn: arn:aws:iam::<your-aws-account-id>:role/GitHubActionsCICDrole
     username: github-actions
     groups:
       - system:masters

3. **Apply the updated aws-auth ConfigMap**:
   ```bash
   kubectl apply -f aws-auth.yaml
   ```

This configuration establishes a secure link between GitHub Actions and AWS, facilitating seamless CI/CD workflows for deploying and managing your application.

## Helm

Working on it...





======================================================================================================================================================
command for gpt help :


{
  echo "Directory Structure:";
  tree;
  echo "";

  # Print the contents of the workflow files in .github/workflows
  find .github/workflows -type f \( -name "*.yaml" -o -name "*.yml" \) -print -exec echo "Contents of {}:" \; -exec cat {} \; -exec echo "" \;
} > tree_and_workflows.txt

========================================================================================================================

# ProShop eCommerce Platform (v2)

> eCommerce platform built with the MERN stack & Redux.

<img src="./frontend/public/images/screens.png">

This project is part of my [MERN Stack From Scratch | eCommerce Platform](https://www.traversymedia.com/mern-stack-from-scratch) course. It is a full-featured shopping cart with PayPal & credit/debit payments. See it in action at https://www.proshopdemo.dev

This is version 2.0 of the app, which uses Redux Toolkit. The first version can be found [here](https://proshopdemo.dev)

<!-- toc -->

  * [Features](#features)
  * [Usage](#usage)
    + [Env Variables](#env-variables)
    + [Install Dependencies (frontend & backend)](#install-dependencies-frontend--backend)
    + [Run](#run)
  * [Build & Deploy](#build--deploy)
    + [Seed (populate) Database](#seed-database)
- [Code FAQ](#bug-fixes-corrections-and-code-faq)
    + [FAQ: How do I use Vite instead of CRA?](#faq-how-do-i-use-vite-instead-of-cra)
      - [Setting up the proxy](#setting-up-the-proxy)
      - [Setting up linting](#setting-up-linting)
      - [Vite outputs the build to /dist](#vite-outputs-the-build-to-dist)
      - [Vite has a different script to run the dev server](#vite-has-a-different-script-to-run-the-dev-server)
      - [A final note:](#a-final-note)
  * [License](#license)

<!-- tocstop -->

## Features

- Full featured shopping cart
- Product reviews and ratings
- Top products carousel
- Product pagination
- Product search feature
- User profile with orders
- Admin product management
- Admin user management
- Admin Order details page
- Mark orders as delivered option
- Checkout process (shipping, payment method, etc)
- PayPal / credit card integration
- Database seeder (populate the database) (products & users)

## Usage

- Create a MongoDB database and obtain your `MongoDB URI` - [MongoDB Atlas](https://www.mongodb.com/cloud/atlas/register)
- Create a PayPal account and obtain your `Client ID` - [PayPal Developer](https://developer.paypal.com/)

### Env Variables

Rename the `.env.example` file to `.env` and add the following

```
PORT=5000
MONGO_URI=<your_mongo_db_uri>
JWT_SECRET='abc123'
PAYPAL_CLIENT_ID=<your_paypal_client_id>
PAYPAL_APP_SECRET=<your_paypal_secret>
PAYPAL_API_URL=https://api-m.sandbox.paypal.com
PAGINATION_LIMIT=8
```

![Alt text](<static/documentdb_connection.png>)

Change the JWT_SECRET and PAGINATION_LIMIT to what you want

### Note

- If you don't plan to use credit card feature or just don't want to create paypal account etc. you can just leave paypal env variables as they are.

### Install Dependencies (frontend & backend)

```
npm install
cd frontend
npm install
```

### Run

```

# Run frontend (:3000) & backend (:5000)
npm run dev

# Run backend only
npm run server
```

## Build & Deploy

```
# Create frontend prod build
cd frontend
npm run build
```

### Seed (populate) Database

You can use the following commands to seed the database with some sample users and products as well as destroy all data

```
# Import data
npm run data:import

# Destroy data
npm run data:destroy
```

```
Sample User Logins

admin@email.com (Admin)
123456

john@email.com (Customer)
123456

jane@email.com (Customer)
123456
```

---

<!-- # Code FAQ -->

### FAQ: How do I use Vite instead of CRA?

Ok so you're at **Section 1 - Starting The Frontend** in the course and you've
heard cool things about [Vite](https://vitejs.dev/) and why you should use that
instead of [Create React App](https://create-react-app.dev/) in 2023.

There are a few differences you need to be aware of using Vite in place of CRA
here in the course after [scaffolding out your Vite React app](https://github.com/vitejs/vite/tree/main/packages/create-vite#create-vite)

#### Setting up the proxy

Using CRA we have a `"proxy"` setting in our frontend/package.json to avoid
breaking the browser [Same Origin Policy](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy) in development.
In Vite we have to set up our proxy in our
[vite.config.js](https://vitejs.dev/config/server-options.html#server-proxy).

```js
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: {
    // proxy requests prefixed '/api' and '/uploads'
    proxy: {
      '/api': 'http://localhost:5000',
      '/uploads': 'http://localhost:5000',
    },
  },
});
```

#### Setting up linting

By default CRA outputs linting from eslint to your terminal and browser console.
To get Vite to ouput linting to the terminal you need to add a [plugin](https://www.npmjs.com/package/vite-plugin-eslint) as a
development dependency...

```bash
npm i -D vite-plugin-eslint

```

Then add the plugin to your **vite.config.js**

```js
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
// import the plugin
import eslintPlugin from 'vite-plugin-eslint';

export default defineConfig({
  plugins: [
    react(),
    eslintPlugin({
      // setup the plugin
      cache: false,
      include: ['./src/**/*.js', './src/**/*.jsx'],
      exclude: [],
    }),
  ],
  server: {
    proxy: {
      '/api': 'http://localhost:5000',
      '/uploads': 'http://localhost:5000',
    },
  },
});
```

By default the eslint config that comes with a Vite React project treats some
rules from React as errors which will break your app if you are following Brad exactly.
You can change those rules to give a warning instead of an error by modifying
the **eslintrc.cjs** that came with your Vite project.

```js
module.exports = {
  env: { browser: true, es2020: true },
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:react/jsx-runtime',
    'plugin:react-hooks/recommended',
  ],
  parserOptions: { ecmaVersion: 'latest', sourceType: 'module' },
  settings: { react: { version: '18.2' } },
  plugins: ['react-refresh'],
  rules: {
    // turn this one off
    'react/prop-types': 'off',
    // change these errors to warnings
    'react-refresh/only-export-components': 'warn',
    'no-unused-vars': 'warn',
  },
};
```

#### Vite outputs the build to /dist

Create React App by default outputs the build to a **/build** directory and this is
what we serve from our backend in production.  
Vite by default outputs the build to a **/dist** directory so we need to make
some adjustments to our [backend/server.js](./backend/server.js)
Change...

```js
app.use(express.static(path.join(__dirname, '/frontend/build')));
```

to...

```js
app.use(express.static(path.join(__dirname, '/frontend/dist')));
```

and...

```js
app.get('*', (req, res) =>
  res.sendFile(path.resolve(__dirname, 'frontend', 'build', 'index.html'))
);
```

to...

```js
app.get('*', (req, res) =>
  res.sendFile(path.resolve(__dirname, 'frontend', 'dist', 'index.html'))
);
```

#### Vite has a different script to run the dev server

In a CRA project you run `npm start` to run the development server, in Vite you
start the development server with `npm run dev`  
If you are using the **dev** script in your root pacakge.json to run the project
using concurrently, then you will also need to change your root package.json
scripts from...

```json
    "client": "npm start --prefix frontend",
```

to...

```json
    "client": "npm run dev --prefix frontend",
```

Or you can if you wish change the frontend/package.json scripts to use `npm
start`...

```json
    "start": "vite",
```

#### A final note:

Vite requires you to name React component files using the `.jsx` file
type, so you won't be able to use `.js` for your components. The entry point to
your app will be in `main.jsx` instead of `index.js`

And that's it! You should be good to go with the course using Vite.

---

## License

The MIT License

Copyright (c) 2023 Traversy Media https://traversymedia.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.








==========================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================





previous readme ::: 



my ticket : 

ticket 13 


[GitHub Actions] CI/CD: Automate deployment of Proshop app







Description

1st grade story: Mid to Large scale projects that can be used as one of the most impactful/heavyweight in the interviews.

Description:
Purpose: Configure the ProShop app to be built and deployed via GitHub Actions.

Deliverables:

Application deployed end-to-end in Dev environment through GitHub Actions and accessible via the Internet with the below hostname structure.

Docker for building the application.

AWS ECR as the image registry, with repository immutability enabled.

Use git SHA for image tagging.

Use Helm chart for deploying both frontend and backend apps.

Use Helm values, but since this is a single-stage setup - create only dev-values.yaml for each app: frontend and backend.

Must have dev, staging, and prod environment configs enabled for each app: frontend and backend..

but use only dev environment during the final project. Staging and Production environments do not exist yet in the final project, but everything should be configured with an assumption that if the project was to continue - deployment into staging and production environments would require little to no changes or adjustments.

for example, create 3 helm values YAML files - dev-values.yaml, staging-values.yaml, prod-values.yaml, even though we will only get to use dev-values.yaml during this project due to time constraints.

Deploy apps in shop-app namespace

Must deploy with hostnames configured and accessible to the Internet (e.g., 312centos.com, 312ubuntu.com, 312redhat.com).

requested domain syntax shop-TEAM-dev.TEAM_DOMAIN (ex: shop-ubuntu-dev.312ubuntu.com)

define values in staging and production configs accordingly, even if we are not going to deploy them yet (shop-TEAM-staging.TEAM_DOMAIN, shop-TEAM.TEAM_DOMAIN)

Set up GitHub Actions in conjunction with AWS.

Create an IAM role named GitHubActionsCICDrole

note: you can reuse the role if it already exists, adjusting the trust policy to allow your repository env as well - About security hardening with OpenID Connect - GitHub Docs 

ensure it has necessary permissions to Build and Push images to ECR

Using Trust policy, be sure to limit access specifically to your organization (YOUR_USERNAME) and relevant repositories. Refer to Configuring OpenID Connect in Amazon Web Services - GitHub Docs 

provide IAM role the access to Kubernetes cluster, and allow it to create K8s objects (deployments, pods, etc.)

update AWS auth configmap manually with kubectl - ensure IAM role has system:masters or similar permissions to Deploy into Kubernetes cluster.

allow eks:Describe* IAM action

refer to Technical Interview Prep class recordings for guidance

Create devenvironment in GitHub Repository settings. Request access from project manager if not enough privileges

Configure Environment level variable IAM_ROLE in GitHub Repository to store the ARN of the IAM role created.

Allow feature/** and main branches to use this environment. We will not be using staging or production environments during the project.

README explaining GitHub Actions CI/CD deployment strategy in a multi-environment along with installation/configuration instructions.

Database Connectivity for Backend:

Establish network connectivity from the backend application pods to the Database instance.

Integrate AWS SecretsManager secrets with Kubernetes secrets for Security:

Create a Kubernetes secret via ASCP and SecretProviderClass from AWS Secrets Manager for the provisioned DB.

Use AWS Secrets Manager secrets in Amazon Elastic Kubernetes Service - AWS Secrets Manager 

refer to Technical Interview Prep class recordings for guidance

Configure backend application pods to retrieve DB connection details from the Kubernetes secret (use supported ENV variables, as per backend README).

Code should be located in: proshop-.. team repository

Implement TLS for Security:

Request a certificate from LetsEncrypt, or use a Wildcard Certificate that any of your teammates might have requested already.

store TLS cert in the Kubernetes secret, and specify in Ingress rules to provide TLS termination at Ingress controller

refer to Technical Interview Prep class recordings for guidance

Notes:

API endpoint needs to be publicly accessible for the Proshop app to function properly.

Do not create new load balancers for the app; reuse existing Ingress-nginx controller in the cluster.

Acceptance Criteria:

GitHub Repository Setup:

A GitHub repository for the Proshop app has been created.

Hostname Configuration:

During deployment, the GitHub Actions CI/CD pipeline configures the specified hostnames (e.g., 312centos.com, 312ubuntu.com, 312redhat.com).

Ingress resources are correctly configured in Kubernetes to route traffic to the appropriate services.

API Endpoint Accessibility:

API endpoints are publicly accessible from the internet to ensure the proper functioning of the Proshop app.

DNS configurations and Ingress controllers are set up to enable external access.

README Documentation:

A comprehensive README  file is available in the repository.

The README includes detailed instructions for deploying and configuring the Proshop app using GitHub Actions.

Instructions for setting up Helm charts, configuring environments, and relevant links to documentation are provided.

Testing and Validation:

The GitHub Actions pipeline has been tested and validated to ensure correct deployment in dev, staging, production environments.

The specified hostnames are accessible from the internet, and traffic is routed correctly to the app services.

The Proshop app functions as expected after deployment.

Maintenance and Updates:

Documentation includes guidelines for making future updates and performing maintenance using GitHub Actions.

Best practices for handling application updates and database migrations are documented.

Additional tips:
Getting started is the hardest but the most important part.

Define an action plan before diving into work. Outline it in bullet points or draw a diagram of steps if necessary.

Don't overthink or panic. Ask clarifying questions about your action plan. If you find a story too challenging to understand, discuss it with a Project Manager within three days of assignment.

Show your soft skills by communicating frequently and professionally, and stay engaged.

Refer to Technical Interview Prep...App CI/CD... classes and App repository with CI/CD implemented for guidelines on how to structure the pipelines, folder structure, helm chart, etc

Commit and push your code regularly, ideally after each change.

Your commit history is your work history. No commits equates to no proof of work or progress. Lack of proof of work or progress will result in disqualification from achieving graduation status, even if the demo is presented.

Each project manager completes an evaluation form that includes a separate questionnaire for progress during the project and the final demo/work result.

Continuously run your code after every change. Avoid testing changes in bulk, as it complicates troubleshooting.

Treat project as DevOps work/internship.

Show your project manager, a real DevOps professional, that you're becoming one too.

Attend every meeting. Inform the team if you can't make it and state the reason.

Prepare for standup meetings in advance to avoid thinking on the spot when many are listening.

What to Say in Standup Meetings: 10 Rules for Better Updates

Avoid procrastination.

Start your workday with a bit of motivation.

Watch one motivational video every day before starting work on your story. Consistency in this routine can lead to project completion in 19 days or sooner.

Create a simple routine to stop procrastinating: start by watching 1 motivational video every day you show up to work on your story. If you do this consistently - you will finish the project before you get to watch all 19 videos over 19 days.

19 Inspirational Videos That Will Completely Blow You Away (2024) 

Team Collaboration

Team collaboration goes beyond just working on a story together. It's about engaging with your team by asking questions, updating everyone on your progress, and sharing insights. Don't hesitate to talk about the mistakes you've made, big or small, – these experiences are valuable for everyone. Also, regularly ask for peer code reviews. This approach strengthens your knowledge and improves your mental well-being.

Learning from Mistakes and potentially using them in Job interviews

Mistakes and problems are part of the learning process. Never give up on your story when facing a challenge; struggling indicates learning.

However, communicate effectively to avoid wasting time on solvable issues or unnecessary tasks.

Document and learn from these mistakes, as this experience is invaluable.

When discussing your story in interviews, articulately define the challenges you faced to build trust in your answer.

Refer to this page on how to define the Issue and Solution - https://www.notion.so/312-bc/Building-Confidence-50d4652222844167870c1b4a9ea2c3e0?pvs=4#8a0455e889fe4f4a8bd6ae23e867bef0.

Notes:
link to the original repo bradtraversy/proshop-v2






















============================================================================================================================================================================================================================================================================================================================================================================================================

{
  echo "Directory Structure:";
  tree;
  echo "";

  # Print the contents of the workflow files in .github/workflows
  find .github/workflows -type f \( -name "*.yaml" -o -name "*.yml" \) -print -exec echo "Contents of {}:" \; -exec cat {} \; -exec echo "" \;
} > tree_and_workflows.txt


============================================================================================================================================================================================================================================================================================================================================================================================================








все тикеты коротко : 






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









