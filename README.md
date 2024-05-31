{
  echo "Directory Structure:";
  tree;
  echo "";

  # Print the contents of the workflow files in .github/workflows
  find .github/workflows -type f \( -name "*.yaml" -o -name "*.yml" \) -print -exec echo "Contents of {}:" \; -exec cat {} \; -exec echo "" \;
} > tree_and_workflows.txt






tickets of project for all students : 

1: 
Description
Summary:
Establish an Amazon EKS cluster on AWS using the existing CloudFormation and Makefile-based automation from the platform-tools... repository, ensuring the successful deployment of platform tools including the ingress-nginx controller.

Tasks:

Review Existing Automation Scripts:

Located in the platform-tools repository, under the eks-cloudformation folder.

Familiarize yourself with the CloudFormation templates and Makefile setup.

Ensure Version Compliance:

Verify the Kubernetes version in the YAML file.

If the version is over two releases behind the latest supported by EKS, update the YAML accordingly.

Manual Workflow for EKS Cluster:

Manually trigger the EKS cluster creation using the GitHub Actions workflow .github/workflows/eks-setup-manual-trigger.yaml.

Consult the Manually running a workflow - GitHub Docs for instructions on manually running a workflow.

Validate Platform Tools Deployment:

Ensure that the separate workflow for deploying platform tools (deploy-platform-tools.yaml) is executed successfully.

Confirm the successful deployment of the ingress-nginx controller within the EKS cluster.

Real-World Context:

Assume the EKS cluster was initially created using CloudFormation and later migrated to Terraform.

This simulates a real-world scenario of evolving infrastructure management practices and can be a point of discussion for “Why did you have a need to create terraform code for launching EKS cluster”

Acceptance Criteria:

An Amazon EKS cluster is successfully operational on AWS.

Kubernetes version used aligns with the latest supported versions by EKS (not more than two versions behind).

The platform tools deployment workflow completes successfully, including the deployment of the ingress-nginx controller.



2: 
[Terraform + GHA] Create EKS Cluster on AWS

Attach

Create subtask

Create

To Do

Actions
Description
1st grade story: Mid to Large scale projects that can be used as one of the most impactful/heavyweight in the interviews.

Purpose:
Create an Amazon EKS cluster on AWS within a newly created VPC, utilizing Terraform with a focus on modular architecture.

General Guidelines:
All Terraform commands are to be executed via GitHub Actions, adhering to GitOps principles.

Emphasize modular design in Terraform, with separate modules for the EKS cluster and VPC.

Key Requirements:
Dedicated Terraform Modules:

Develop two custom Terraform modules: one for the EKS Cluster setup and another for the VPC creation.

The VPC module must be called from the primary root module before the EKS module to ensure proper network setup.

Multi-Environment Setup:

Implement Terraform configurations for development (dev), staging, and production environments.

although during the 1 month of the project, we will only test code in development environment/account

Set up GitHub Actions to run Terraform from two branches: main for production and feature/* for development.

Changes pushed to feature/ branches should be merged into main via pull requests requiring three approvals: one from the project manager and two from peers or teammates.

VPC Configuration Module:

Create a new VPC with a unique CIDR.

Include 3 public and 3 private subnets in the VPC configuration.

no need to configure NAT Gateway

Ensure the VPC is designed to support the EKS cluster and RDS communication.

EKS Cluster Configuration Module:

Use Kubernetes version one release prior to the latest supported by EKS.

Deploy t3.medium and similar instance types, with mixed spot and on-demand instances. Set policy to

minimum 1, maximum 5, desired 3

%20 on-demand, %80 spot instance. 0 count of base on-demand instances

Configure multi-AZ deployment for nodes.

Place the EKS cluster in the VPC’s public subnets.

Establish security groups with minimal permissive rules.

Utilize an ASG for self-managed nodes, avoiding managed node groups.

Do not use off-the-shelf Terraform modules.

aws-auth Configuration:

Properly set up aws-auth ConfigMap to provide admin access to

the AWS SSO Administrator role.

GitHub Runner Application CI/CD IAM role(s).

GitHub Runner Terraform IAM role.

Ensure secure and appropriate access control for cluster administration.

EKS Add-Ons and Integrations:

Include necessary add-ons like VPC CNI, EBS CSI, etc., for enhanced EKS functionality.

Ensure these add-ons are integrated and configured correctly as part of the EKS setup.

(done) GitHub Actions and AWS Integration. This bullet section is already completed by 312 team:

Created a GitHubActionsTerraformIAMrole in AWS with AdministratorAccess, limiting permissions to the organization, repository, and dev GitHub environment.

Configured a "dev" environment in the GitHub Repository. Defined IAM_ROLE in GitHub to store the ARN of the created IAM role.

since production and staging accounts are not available during the final project, main branch will be temporarily deployed into dev environment.

Modified the GitHub Actions workflow YAML to recognize the feature/ and main (temporarily) branch as the dev environment, utilizing dev.tfvars.

Deliverables:
An operational EKS cluster and VPC, both created in Terraform.

Screenshots demonstrating the cluster, cluster version, and nodes with mixed instance types.

A README file detailing EKS cluster usage, VPC configuration, instructions from scratch, and encountered challenges.

Acceptance Criteria:
A functional EKS cluster and VPC setup through GitHub Actions Workflow with Terraform, meeting all story requirements.

Verification of the EKS cluster’s functionality within the created VPC environment.

A detailed README providing guidance on the deployment strategy, configuration, and modular setup specifics.

Additional tips:
Getting started is the hardest but the most important part.

Define an action plan before diving into work. Outline it in bullet points or draw a diagram of steps if necessary.

Don't overthink or panic. Ask clarifying questions about your action plan. If you find a story too challenging to understand, discuss it with a Project Manager within three days of assignment.

Show your soft skills by communicating frequently and professionally, and stay engaged.

Refer to Technical Interview Prep...Terraform GitOps... classes and terraform-infra repository with Terraform CI/CD implemented for guidelines on how to structure the pipelines, folder structure, etc

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



3: 

[GitHub Actions] Setup CI/CD for Weather (Kubernetes)

Attach

Create subtask

Create

To Do

Actions
Description
1st grade story: Mid to Large scale projects that can be used as one of the most impactful/heavyweight in the interviews.

Description:
Purpose: Configure the backend of the Weather app to be automatically built and deployed via GitHub Actions using Helm charts, with distinct pipelines for development, staging, and production environments.

Deliverables:

Application deployed end-to-end in Dev environment through GitHub Actions and accessible via the Internet with the below hostname structure.

Docker for building the application.

AWS ECR as the image registry, with repository immutability enabled.

Use git SHA for image tagging.

Use Helm chart for deploying the backend app.

Use Helm values, but since this is a single-stage setup - create only dev-values.yaml for each app: frontend and backend.

Must have dev, staging, and prod environment configs enabled for each app: frontend and backend..

but use only dev environment during the final project. Staging and Production environments do not exist yet in the final project, but everything should be configured with an assumption that if the project was to continue - deployment into staging and production environments would require little to no changes or adjustments.

for example, create 3 helm values YAML files - dev-values.yaml, staging-values.yaml, prod-values.yaml, even though we will only get to use dev-values.yaml during this project due to time constraints.

Deploy apps in weather-app namespace

Must deploy with hostnames configured and accessible to the Internet (e.g., 312centos.com, 312ubuntu.com, 312redhat.com).

requested domain syntax weather-TEAM-dev.TEAM_DOMAIN (ex: weather-ubuntu-dev.312ubuntu.com)

define values in staging and production configs accordingly, even if we are not going to deploy them yet (weather-TEAM-staging.TEAM_DOMAIN, weather-TEAM.TEAM_DOMAIN)

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

Code should be located in: weather-.. team repository

Implement TLS for Security:

Request a certificate from LetsEncrypt, or use a Wildcard Certificate that any of your teammates might have requested already.

store TLS cert in the Kubernetes secret, and specify in Ingress rules to provide TLS termination at Ingress controller

refer to Technical Interview Prep class recordings for guidance

Notes:

API endpoint needs to be publicly accessible for the Weather app to function properly.

Do not create new load balancers for the app; reuse existing Ingress-nginx controller in the cluster.

Acceptance Criteria:

GitHub Repository Setup:

A GitHub repository for the Weather app has been created.

Hostname Configuration:

During deployment, the GitHub Actions CI/CD pipeline configures the specified hostnames (e.g., 312centos.com, 312ubuntu.com, 312redhat.com).

Ingress resources are correctly configured in Kubernetes to route traffic to the appropriate services.

API Endpoint Accessibility:

API endpoints are publicly accessible from the internet to ensure the proper functioning of the Weather app.

DNS configurations and Ingress controllers are set up to enable external access.

README Documentation:

A comprehensive README  file is available in the repository.

The README includes detailed instructions for deploying and configuring the Weather app using GitHub Actions.

Instructions for setting up Helm charts, configuring environments, and relevant links to documentation are provided.

Testing and Validation:

The GitHub Actions pipeline has been tested and validated to ensure correct deployment in dev, staging, production environments.

The specified hostnames are accessible from the internet, and traffic is routed correctly to the app services.

The Weather app functions as expected after deployment.

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
Get Started with React Native · React Native 

Refer to Notion documentation as well for hints

Setting up CI/CD pipeline for the Frontend App is NOT part of of this project. CI/CD pipeline should be setup only for the backend on Kubernetes/EKS.

Frontend can be tested manually in ‘Android Studio’ via phone emulator.



4: 

[GitHub Actions] AWS EKS: Implement EFK Logging Solution with S3 Redundancy

Attach

Create subtask

Create

In Progress

Actions
Description
2nd grade story: Small to Mid scale projects that can be used as secondary in the interviews, to complement experience with more than just one project.

Situation:
As part of an initiative to optimize operational costs and improve efficiency, the company is transitioning from traditional logging systems to an open-source solution. This strategic shift involves setting up the EFK (Elasticsearch, FluentD, Kibana) stack for logging in the AWS EKS environment.

Task:
The objective is to configure the EFK stack to provide comprehensive logging functionalities, replacing existing systems, and ensuring no loss of logging capabilities. Additionally, implement a redundant backup system by configuring FluentD to send logs to Amazon S3.

Action:
EFK Tools Integration:

Incorporate EFK configurations under the eks-logging/ directory of the Platform Tools Repository.

Utilize Helm for deploying Elasticsearch and Kibana, with custom values for dev, staging, and production environments.

GitHub Actions Workflow:

Add deployment steps for the EFK stack into the deploy-platform-tools.yaml workflow.

Initially focus on the dev environment deployment, while preparing configurations for staging and production.

Security, Accessibility, and Redundancy:

Configure Kibana endpoints (e.g., kibana-dev, kibana-staging, kibana-prod) for respective environments.

Ensure Kibana hostnames are internet-accessible (e.g., kibana-ubuntu-dev.312ubuntu.com) and secured with authentication.

Implement authentication for Kibana, storing credentials in AWS SecretsManager.

Implement network access restriction using Ingress whitelist annotations, demonstrating with a specific source IP.

since there is no Company VPN server with Dedicated IP, use Home Public IP for demonstration purposes

Bonus feature: Configure FluentD to send logs to both Elasticsearch and Amazon S3 for redundancy, ensuring a robust backup mechanism.

Documentation and Knowledge Transfer:

Update the README in the eks-logging/ directory with comprehensive instructions and insights on setting up and using the EFK stack, and the rationale behind choosing EFK over traditional ELK.

Document the process of configuring FluentD for log backup to S3.

Result:
Deliverables:

Fully integrated EFK stack in the AWS EKS cluster for logging, managed within the Platform Tools Repository.

Updated README in the eks-logging/ directory, providing in-depth setup and usage instructions.

Acceptance Criteria:

Successful deployment and operation of the EFK stack in the dev environment, ready for scaling to staging and production.

Secure, internet-accessible Kibana endpoints with demonstrated network access restrictions.

FluentD effectively sending logs to both Elasticsearch and Amazon S3.

Positive feedback on the ease of setup, functionality of the logging solution, and the comprehensiveness of the documentation.

Additional Considerations:
Regularly review and update the documentation to reflect any changes or updates in the logging setup.

Ensure all actions adhere to the contribution guidelines of the Platform Tools Repository.

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




5: 

[GitHub Actions] AWS EKS: Setup Monitoring for Kubernetes cluster

Attach

Create subtask

Create

To Do

Actions
Description
2nd grade story: Small to Mid scale projects that can be used as secondary in the interviews, to complement experience with more than just one project.

Situation:
The company, previously utilizing Datadog for monitoring, has decided to shift towards a more cost-effective solution by adopting open-source tools. This decision aligns with the company’s initiative to optimize expenses while maintaining efficient monitoring capabilities.

Task:
The objective is to set up and configure Prometheus and Grafana for monitoring the AWS EKS Kubernetes cluster. This setup should replace the existing Datadog implementation without compromising on the quality and depth of monitoring insights.

Action:
Monitoring Tools Integration:

Add Prometheus and Grafana configurations under the eks-monitoring/ directory of the Platform Tools Repository.

Utilize Helm for deploying both Prometheus and Grafana, ensuring custom values for each environment (dev, staging, production).

Create custom helm chart with easy to update templates. Do not use public Helm charts as they’re overly complicated to adjustments

GitHub Actions Workflow:

Incorporate deployment steps for Prometheus and Grafana into the deploy-platform-tools.yaml workflow.

Initially focus on the dev environment, while preparing for future deployments in staging and production.

Security and Accessibility:

Configure Grafana endpoints (e.g., grafana-dev, grafana-staging, grafana-prod) for respective environments.

Must deploy with hostnames configured and accessible to the Internet (e.g., 312centos.com, 312ubuntu.com, 312redhat.com).

requested domain syntax grafana-TEAM-dev.TEAM_DOMAIN (ex: grafana-ubuntu-dev.312ubuntu.com)

define values in staging and production configs accordingly, even if we are not going to deploy them yet (grafana-TEAM-staging.TEAM_DOMAIN, grafana-TEAM-prod.TEAM_DOMAIN)

Demonstrate Network access restriction by using specific source IP via Ingress Whitelist annotations

since there is no Company VPN server with Dedicated IP, use Home Public IP for demonstration purposes

Implement authentication for Grafana, storing credentials in AWS SecretsManager.

Documentation and Knowledge Transfer:

Update the README within the eks-monitoring/ directory to include detailed instructions and background information on Prometheus and Grafana.

Result:
Deliverables:

Prometheus and Grafana fully integrated into the AWS EKS cluster for monitoring, with configurations managed in the Platform Tools Repository.

Updated README in the eks-monitoring/ directory providing comprehensive setup and usage instructions.

Acceptance Criteria:

Successful deployment and functionality of Prometheus and Grafana in the dev environment, with potential for scaling to staging and production.

Clear, accessible monitoring endpoints for Grafana, secured with proper authentication.

Positive feedback on the ease of setup, quality of monitoring, and the utility of the documentation.

Additional Considerations:
Regularly review and update the documentation to reflect any changes or updates in the monitoring setup.

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




6: 


[Terraform + GHA] Automate Creation of IAM Roles and Policies for Dev and Production accounts

Attach

Create subtask

Create

In Progress

Actions
Description
2nd grade story: Small to Mid scale projects that can be used as secondary in the interviews, to complement experience with more than just one project.

Purpose:
Automate the creation of specified IAM roles and policies in the AWS account using Terraform and GitHub Actions, following the GitOps principles.

General Guidelines:
Execute all Terraform commands via GitHub Actions, avoiding local executions.

Focus on setting up IAM roles and policies in a consistent manner across different environments.

Key Requirements:
Dedicated Terraform Child Module:

Create a custom Terraform module for IAM role and policy setup.

Call this module from the primary root module.

Multi-Environment Setup:

Develop Terraform configurations for development (dev), and production environments.

since during the 1 month of the project we will not be having production account:

deploy production roles in the same dev account, use production.tfvars to specify values for production roles - change all the names to avoid resource creation conflicts

for testing creation of production roles: in the feature/ branch, adjust workflow YAML temporarily to pick up production.tfvars

Set up GitHub Actions to run Terraform from two branches: main and feature/*, both for development(dev) environments.

Changes merged into main should require approvals: one from the project manager and two from peers or teammates.

IAM Roles and Policies Configuration:

DeveloperDevAccessRole: Read permissions on all EC2 actions, EKS, and full access to S3.

DevopsDevAccessRole: Full permissions.

DeveloperProdAccessRole: Read permissions on all EC2 actions, EKS, and S3.

DevopsProdAccessRole: Full Read permissions in Prod (except for secrets) and full permissions on EC2.

Ensure these roles trust the parent AWS account: 879500880845.

Follow best practices in IAM role and policy creation, ensuring customizability across environments.

MUST NOT use off-the-shelf Terraform modules, such as those from GitHub or Terraform Registry.

(done) GitHub Actions and AWS Integration. This bullet section is already completed by 312 team:

Created a GitHubActionsTerraformIAMrole in AWS with AdministratorAccess, limiting permissions to the organization, repository, and dev GitHub environment.

Configured a "dev" environment in the GitHub Repository. Defined IAM_ROLE in GitHub to store the ARN of the created IAM role.

since production and staging accounts are not available during the final project, main branch will be temporarily deployed into dev environment.

Modified the GitHub Actions workflow YAML to recognize the feature/ and main (temporarily) branch as the dev environment, utilizing dev.tfvars.

Deliverables:
Terraform configuration for the specified IAM roles and policies.

Demonstration showing the functionality of these IAM roles as per the defined scopes.

Documentation:
Create a README file detailing the setup and configuration process of IAM roles and policies, focusing on Terraform and GitHub Actions.

Acceptance Criteria:
Successful setup of specified IAM roles and policies in the AWS environment through GitHub Actions and Terraform.

Verification of IAM roles performing as outlined in the requirements.

A comprehensive README providing guidance on the deployment strategy and configuration process.

Additional tips:
Getting started is the hardest but the most important part.

Define an action plan before diving into work. Outline it in bullet points or draw a diagram of steps if necessary.

Don't overthink or panic. Ask clarifying questions about your action plan. If you find a story too challenging to understand, discuss it with a Project Manager within three days of assignment.

Show your soft skills by communicating frequently and professionally, and stay engaged.

Refer to Technical Interview Prep...Terraform GitOps... classes and terraform-infra repository with Terraform CI/CD implemented for guidelines on how to structure the pipelines, folder structure, etc

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



7: 


[GitHub Actions] AWS EKS: Setup cluster-autoscaler to Scale Cluster Node Group Automatically

Attach

Create subtask

Create

To Do

Actions
Description
2nd grade story: Small to Mid scale projects that can be used as secondary in the interviews, to complement experience with more than just one project.

Purpose:
Configure and implement the cluster-autoscaler automation for AWS EKS clusters to enable automatic scaling of the cluster node group, adhering to AWS best practices. All configurations and Terraform code will be deployed through GitHub Actions, with Terraform code managed in a separate repository.

Key Requirements:
Cluster Autoscaler Configuration:

Implement the cluster-autoscaler in the AWS EKS cluster following AWS recommended best practices.

if using Helm chart - chart templates should be downloaded to the Platform tools repository, and helm code should run from those local templates in the repository.

Ensure the autoscaler is capable of dynamically scaling node groups based on cluster demands.

GitHub Actions Deployment:

Deploy and manage the cluster-autoscaler configuration through GitHub Actions from the Platform Tools Repository.

Manage and deploy Terraform code related to the cluster-autoscaler setup through GitHub Actions from the terraform-infra... repository.

Configure necessary GitHub Actions workflows to automate the deployment and management process.

GitHub Actions Workflow:

Modify and utilize the deploy-platform-tools.yaml workflow in the Platform Tools Repository for deploying external-dns configurations.

Ensure the Terraform code in the terraform-infra repository has its own GitHub Actions workflow for deployment.

Testing and Demonstration:

Develop and implement tests to demonstrate the scaling abilities of the cluster-autoscaler within the EKS environment.

Tip for the Demo: Prepare a pre-recorded demo showcasing the autoscaling functionality, considering presentation time constraints.

Documentation:

Provide a comprehensive README in the cluster-autoscaler/ directory, explaining the purpose, functionality, and configuration of the cluster-autoscaler.

Include detailed installation and configuration instructions, along with any encountered challenges.

Deliverables:
A fully functional cluster-autoscaler integrated into the AWS EKS environment.

Test cases and a pre-recorded or live demo demonstrating the autoscaler’s ability to scale the cluster node group.

An informative README in the cluster-autoscaler/ directory detailing the setup and operational guidelines.

Contribution and Workflow:
Adhere to the Platform Tools Repository's contribution guidelines.

Ensure all deployments and configurations are executed through GitHub Actions.

Access and Permissions:
Make necessary adjustments to GitHub Actions workflows to reflect the updated cluster and tool configurations.

Acceptance Criteria:
Successful implementation and integration of the cluster-autoscaler in the AWS EKS environment, managed via GitHub Actions.

Validation of the autoscaler’s functionality through tests and the provided demo.

Comprehensive and accessible documentation detailing the autoscaler setup, its configuration process, and usage.

Additional tips:
Getting started is the hardest but the most important part.

Define an action plan before diving into work. Outline it in bullet points or draw a diagram of steps if necessary.

Don't overthink or panic. Ask clarifying questions about your action plan. If you find a story too challenging to understand, discuss it with a Project Manager within three days of assignment.

Show your soft skills by communicating frequently and professionally, and stay engaged.

Refer to Technical Interview Prep...Terraform GitOps... classes and terraform-infra repository with Terraform CI/CD implemented for guidelines on how to structure the pipelines, folder structure, etc

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

Refer to this page on how to define the Issue and Solution - https://www.notion.so/312-bc/Building-Confidence-50d4652222844167870c1b4a9ea2c3e0?pvs=4#8a0455e889fe4f4a8bd6ae23e867bef0.|


8: 


[GitHub Actions] AWS EKS: Create Secure Developer User in Kubernetes and Map to Developer IAM role

Attach

Create subtask

Create

To Do

Actions
Description
2nd grade story: Small to Mid scale projects that can be used as secondary in the interviews, to complement experience with more than just one project.

Purpose:
As per request from the external Security audit team/contractors. Configure a secure ReadOnly Kubernetes user for developers, mapped to the AWS IAM role used by Developers, for eventual deployment in production environments. The configuration must restrict exec permissions and access to Kubernetes secret objects.

Key Requirements:
Kubernetes User Configuration for Production:

Set up a ReadOnly user in Kubernetes, tailored for developer usage in production environments.

Map this user to the DeveloperProdAccessRole in AWS IAM.

Explicitly restrict the user's permissions, ensuring no access to exec commands and Kubernetes secret objects.

this is to protect database and other sensitive application credentials

if kubectl exec is allowed - developer can read credentials from inside the pod by printing Environment variables

Helm chart or Plain YAML files - both are acceptable options.

Security and Access Control:

Employ Kubernetes RBAC (Role-Based Access Control) to define and manage user permissions.

Utilize cluster roles and cluster role bindings for precise control of user access.

Update the aws-auth-configmap in EKS, initially manually for testing, and then automate through existing Terraform EKS code in the terraform-infra repository - create PR with your requested changes.

Testing and Validation:

Test the ReadOnly user role in the Kubernetes cluster, focusing on permission restrictions, particularly the inability to exec into pods.

Ensure the user role adheres to security best practices, suitable for production deployment.

GitHub Actions Workflow:

Modify and utilize the deploy-platform-tools.yaml workflow in the Platform Tools Repository for deploying k8s user role configurations.

Documentation and Resources:

Document the process of setting up the secure ReadOnly user, including mapping to the IAM role and configuring RBAC in Kubernetes.

Provide a README  in the k8s-user-roles/ directory with insights on Kubernetes user and authentication mechanisms, RBAC, and best practices for secure user roles.

Suggest additional resources or references for understanding Kubernetes RBAC and security practices.

Deliverables:
A securely configured ReadOnly user role in Kubernetes, suitable for production environments and mapped to the DeveloperProdAccessRole.

Comprehensive documentation, including a README with setup instructions, Kubernetes RBAC explanations, and security considerations.

Research and Resources:
Explore Kubernetes RBAC to understand the nuances of role creation and permission assignment.

Consider existing Kubernetes documentation and community best practices for secure user role configuration.

Contribution and Workflow:
Adhere to the contribution guidelines of the Platform Tools Repository.

All deployments must be executed through GitHub Actions.

Acceptance Criteria:
Successful implementation of a secure ReadOnly Kubernetes user for developers, with restricted permissions including no exec access.

Verification that the user role is secure and adheres to best practices, ready for production deployment.

Availability of in-depth documentation providing clear guidelines on user setup, Kubernetes RBAC, and security configurations.

Additional tips:
Getting started is the hardest but the most important part.

Define an action plan before diving into work. Outline it in bullet points or draw a diagram of steps if necessary.

Don't overthink or panic. Ask clarifying questions about your action plan. If you find a story too challenging to understand, discuss it with a Project Manager within three days of assignment.

Show your soft skills by communicating frequently and professionally, and stay engaged.

Refer to Technical Interview Prep...Terraform GitOps... classes and terraform-infra repository with Terraform CI/CD implemented for guidelines on how to structure the pipelines, folder structure, etc

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



9: 



[GitHub Actions + Terraform] AWS EKS: Automate Creation of Route53 records with external-dns

Attach

Create subtask

Create

In Progress

Actions
Description
1st grade story: Mid to Large scale projects that can be used as one of the most impactful/heavyweight in the interviews.

Purpose:
Configure Kubernetes cluster to automatically manage DNS records in AWS Route 53 using external-dns. All configurations and Terraform code will be deployed through GitHub Actions, with Terraform code managed in a separate repository.

Background Links:
external-dns GitHub Repository

external-dns AWS Tutorial

Key Requirements:
external-dns Integration:

Implement external-dns in the Kubernetes cluster to manage AWS Route 53 DNS records.

if using Helm chart - chart templates should be downloaded to the Platform tools repository, and helm code should run from those local templates in the repository.

Ensure external-dns is configurable via Ingress annotations.

Only annotated ingresses should trigger DNS record setups.

Use appropriate Route 53 hosted zones (e.g., 312centos.com, 312ubuntu.com, 312redhat.com).

GitHub Actions Deployment:

Deploy external-dns configurations through GitHub Actions from the Platform Tools Repository.

Manage and deploy Terraform code related to the external-dns setup through GitHub Actions from the terraform-infra... repository.

GitHub Actions Workflow:

Modify and utilize the deploy-platform-tools.yaml workflow in the Platform Tools Repository for deploying external-dns configurations.

Ensure the Terraform code in the terraform-infra repository has its own GitHub Actions workflow for deployment.

Documentation:

Provide a README in the external-dns/ directory explaining the external-dns architecture and background, installation, and configuration instructions.

Document any challenges or issues faced during setup.

Optionally - implement automated testing in the GitHub Actions workflow

provision sample deployment, service, ingress with annotation

wait for dns record creation

verify DNS record was created - with curl and nslookup (if tests fail, pipeline should fail)

delete the sample resources created for testing

Deliverables:
Functional automatic DNS record creation in AWS Route 53, triggered by Ingress annotations.

Updated README in the external-dns/ directory with complete documentation.

Contribution and Workflow:
Adhere to the contribution guidelines of the Platform Tools Repository.

All deployments must be executed through GitHub Actions.

Merge into the main branch requires a minimum of 3 approvals.

Access and Permissions:
Adjust GitHub Actions workflows as needed for the new cluster and tool configurations.

Acceptance Criteria:
Successful deployment and integration of external-dns in the Kubernetes cluster, managed via GitHub Actions workflows from both repositories.

Verified automation of DNS record creation/removal in AWS Route 53 based on Ingress annotations.

optionally: provision test ingress rules with test records

Comprehensive and accessible documentation detailing setup, configuration, and operational specifics.

Additional tips:
Getting started is the hardest but the most important part.

Define an action plan before diving into work. Outline it in bullet points or draw a diagram of steps if necessary.

Don't overthink or panic. Ask clarifying questions about your action plan. If you find a story too challenging to understand, discuss it with a Project Manager within three days of assignment.

Show your soft skills by communicating frequently and professionally, and stay engaged.

Refer to Technical Interview Prep...Terraform GitOps... classes and terraform-infra repository with Terraform CI/CD implemented for guidelines on how to structure the pipelines, folder structure, etc

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


10 : 


[Terraform + GHA] Create RDS MySQL for Versus app

Attach

Create subtask

Create

In Progress

Actions
Description
1st grade story: Mid to Large scale projects that can be used as one of the most impactful/heavyweight in the interviews.

Purpose:
Create a MySQL RDS database in AWS using Terraform for the Versus App in a multi-environment setup.

General Guidelines:
All Terraform commands must be executed via GitHub Actions, avoiding local executions, following the GitOps principles.

The story involves setting up the database in a multi-environment context (development, staging, and production).

Key Requirements:
Dedicated Terraform Child Module:

Develop a custom Terraform module specifically for the RDS MySQL setup.

This module should be called from the primary root module.

Multi-Environment Setup:

Implement Terraform configurations for development (dev), staging, and production environments.

although during the 1 month of the project, we will only test code in development environment/account

Set up GitHub Actions to run Terraform from two branches: main for production and feature/* for development.

Changes pushed to feature/ branches should be merged into main via pull requests requiring three approvals: one from the project manager and two from peers or teammates.

RDS MySQL Database Configuration:

Choose t2/t3.micro as the instance size for the database.

Deploy MySQL major version 5.

Use default MySQL parameter and option groups.

Position the RDS instance within a private subnet of the permanent EKS VPC.

Assign a dedicated security group specifically for the RDS database.

Incorporate best practices in database creation, including options for backups, multi-AZ deployments, etc.

ensure that options are customizable across environments

multi-az option should be disabled when deploying in dev environment

Store credentials in AWS SecretsManager

MUST NOT use off-the-shelf Terraform modules, such as those from GitHub or Terraform Registry.

(done) GitHub Actions and AWS Integration. This bullet section is already completed by 312 team:

Created a GitHubActionsTerraformIAMrole in AWS with AdministratorAccess, limiting permissions to the organization, repository, and dev GitHub environment.

Configured a "dev" environment in the GitHub Repository. Defined IAM_ROLE in GitHub to store the ARN of the created IAM role.

since production and staging accounts are not available during the final project, main branch will be temporarily deployed into dev environment.

Modified the GitHub Actions workflow YAML to recognize the feature/ and main (temporarily) branch as the dev environment, utilizing dev.tfvars.

Deliverables:
A fully operational RDS MySQL database, demonstrable via command-line queries within the AWS environment.

Use kubectl exec to enter the versus app deployment pod (or any other pod).

Inside the pod, install MySQL CLI.

Run MySQL CLI command to connect to RDS MySQL cluster

Documentation: A comprehensive README file detailing the RDS MySQL architecture, installation, and configuration process, specifically focusing on Terraform and GitHub Actions setup.

Acceptance Criteria:
Functional RDS MySQL database set up in development environment through GitHub Actions Workflow with Terraform, as per the story requirements.

Successful execution and verification of database functionality through command-line queries.

Comprehensive README providing clear guidance on deployment strategy, configuration, and operational specifics.

Additional Requirement to RDS MySQL Database Story: Configure CloudWatch Alarms for Versus DB
Purpose:
Integrate CloudWatch alarms into the existing RDS MySQL database setup for the Versus App to monitor and trigger alerts on high CPU usage.

Key Requirements:
CloudWatch Alarm Configuration:

Create a Terraform module specifically for configuring CloudWatch alarms.

Set up alarms to trigger on high CPU usage (above 80%) for the Versus RDS instance in the production environment.

Ensure the configuration adheres to Terraform best practices and does not use hosted modules from external sources.

Integration with RDS Setup:

Integrate this CloudWatch alarm configuration into the existing Terraform setup for the RDS MySQL database.

Ensure the alarm is tied specifically to the CPU metrics of the Versus RDS instance.

Terraform and GitHub Actions Workflow:

Incorporate the CloudWatch alarm setup into the same GitHub Actions workflow used for deploying the RDS MySQL database.

Ensure that the production environment is the primary focus for this alarm setup, with potential scalability to other environments in the future.

Documentation and Testing:

Update the existing README file or create a new section within it to explain the CloudWatch alarm setup, its purpose, and configuration steps.

Demonstrate a working example of the alarm in the production environment.

Deliverables:
Terraform configuration for setting up CloudWatch alarms specific to the Versus RDS instance's CPU usage.

Updated README documentation detailing the CloudWatch alarm setup and integration with the RDS MySQL database.

Acceptance Criteria:
Successful implementation of CloudWatch alarms that accurately trigger on high CPU usage of the Versus RDS instance.

Clear and comprehensive documentation explaining the setup, configuration, and rationale behind using CloudWatch alarms.

Verification of the alarm functionality through testing in the dev environment.

Demonstrate working example alarm

set-alarm-state — AWS CLI 2.15.56 Command Reference 

Additional tips:
Getting started is the hardest but the most important part.

Define an action plan before diving into work. Outline it in bullet points or draw a diagram of steps if necessary.

Don't overthink or panic. Ask clarifying questions about your action plan. If you find a story too challenging to understand, discuss it with a Project Manager within three days of assignment.

Show your soft skills by communicating frequently and professionally, and stay engaged.

Refer to Technical Interview Prep...Terraform GitOps... classes and terraform-infra repository with Terraform CI/CD implemented for guidelines on how to structure the pipelines, folder structure, etc

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




11: 



[Manual] Final cleanup

Attach

Create subtask

Create

To Do

Actions
Description
After all demos are finished, we need to make sure no resources are left hanging in AWS account. School has an automation tool for this purpose: 

https://github.com/312-bc/312-aws-nuke-resource-cleanupCan't find link 


12 : 


[Terraform + GHA] Serverless Application Deployment Using Terraform and GitHub Actions

Attach

Create subtask

Create

To Do
Flagged

Actions
Description
1st grade story: Mid to Large scale projects that can be used as one of the most impactful/heavyweight in the interviews.

Description:
Purpose: To automate the deployment of a serverless full-stack web application, which leverages AWS serverless services for efficient, scalable, and managed serverless hosting.

Key Features of the Memo app:
Express API endpoint with optional authentication.

React.js frontend, served via Amazon CloudFront and S3.

Optional email authentication using Amazon Cognito.

Utilization of Amazon DynamoDB, Lambda, API Gateway HTTP API for serverless API endpoints.

Key Requirements:
CI/CD Pipeline:

Implement GitHub Actions for continuous integration and deployment.

Use Terraform for AWS infrastructure management and provisioning.

Serverless Architecture:

Set up necessary AWS serverless components: DynamoDB, Lambda, API Gateway, CloudFront, and S3.

Application Deployment:

Automate deployment of both the Express API and React.js frontend.

Ensure frontend delivery through CloudFront and S3.

Configuring Authentication is optional:

Provide guidance on configuring Amazon Cognito for user authentication, if configured.

Security and Compliance:

Maintain secure connections and data handling, with focus on API and database interactions.

Documentation:

Develop a separate README file explaining the deployment process, architecture, and usage of Terraform and GitHub Actions for serverless app deployment.

Do not overwrite the existing README.md, create a separate markdown file, ex: Documentation.md

Deliverables:
A fully operational serverless web application deployed using automated processes.

A CI/CD pipeline setup using GitHub Actions and Terraform.

Comprehensive documentation covering deployment strategies and operational details.

Acceptance Criteria:
Successful deployment of the serverless application, including backend (API, Lambda) and frontend (React.js).

Functionality of application features, such as API access and frontend interactions, verified.

Clear documentation enabling users to understand the deployment process and replicate it if needed.

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



13: my ticket 




14 : 



[Terraform + GHA] Provision MongoDB database for Proshop app

Attach

Create subtask

Create

In Progress

Actions
Description
1st grade story: Mid to Large scale projects that can be used as one of the most impactful/heavyweight in the interviews.

Description: This project requires setting up an AWS DocumentDB database for the Proshop app using Terraform and GitHub Actions with a focus on GitOps principles within a multi-environment setup.

General Guidelines: 

All Terraform commands must be executed via GitHub Actions. Avoid executing any Terraform commands locally.

Key Requirements:

Dedicated Terraform child module

should be called from the primary root module just like any other modules

Multi-Environment Setup:

Implement Terraform configurations for development (dev), staging, and production environments.

although during the 1 month of the project, we will only test code in development environment/account

Set up GitHub Actions to run Terraform from two branches: main and feature/* , both for development(dev) environment.

Changes pushed to feature/ branches should be merged into main via pull requests requiring three approvals: one from the project manager and two from peers or teammates.

Configure Terraform with several .tfvars files (dev, staging, production), focusing on dev deployment during this project.

Database Configuration:

Opt for the smallest available instance (db.t3.medium) for the database to ensure cost efficiency.

Position the database within a private subnet of the EKS VPC.

Assign a dedicated security group to the database for enhanced security.

Ensure proshop app has network connectivity to the Database.

Important: Disable TLS

Store credentials in AWS SecretsManager

Terraform Best Practices:

Adhere to Terraform best practices throughout the project.

Create a custom Terraform module specifically for the database setup.

Ensure the database setup aligns with best practices, focusing on high availability.

MUST NOT use off-the-shelf Terraform modules, such as those from GitHub or Terraform Registry.

(done) GitHub Actions and AWS Integration. This bullet section is already completed by 312 team:

Created a GitHubActionsTerraformIAMrole in AWS with AdministratorAccess, limiting permissions to the organization, repository, and dev GitHub environment.

Configured a "dev" environment in the GitHub Repository. Defined IAM_ROLE in GitHub to store the ARN of the created IAM role.

since production and staging accounts are not available during the final project, main branch will be temporarily deployed into dev environment.

Modified the GitHub Actions workflow YAML to recognize the feature/ and main (temporarily) branch as the dev environment, utilizing dev.tfvars.

Deliverables:

Functional Database: The DocumentDB database should be fully operational and demonstrable via command-line queries. Validate the connection to the RDS database

Use kubectl exec to enter the proshop app deployment pod (or any other pod).

Inside the pod, install MongoDB CLI (mongo shell).

Run Mongo CLI command to connect to MongoDB cluster (TLS must be disabled on the DB)

https://docs.aws.amazon.com/documentdb/latest/developerguide/connect_programmatically.html#connect_programmatically-tls_disabled

The mongo Shell 

Documentation: A comprehensive README file explaining the deployment, configuration process, and specific details about the Terraform and GitHub Actions setup.

Additional tips:
Getting started is the hardest but the most important part.

Define an action plan before diving into work. Outline it in bullet points or draw a diagram of steps if necessary.

Don't overthink or panic. Ask clarifying questions about your action plan. If you find a story too challenging to understand, discuss it with a Project Manager within three days of assignment.

Show your soft skills by communicating frequently and professionally, and stay engaged.

Refer to Technical Interview Prep...Terraform GitOps... classes and terraform-infra repository with Terraform CI/CD implemented for guidelines on how to structure the pipelines, folder structure, helm chart, etc

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

15: 


[GitLabCI] Create a GitLab Account and Set Up GitLab Runner in Kubernetes Cluster

Attach

Create subtask

Create

In Progress

Actions
Description
2nd grade story: Small to Mid scale projects that can be used as secondary in the interviews, to complement experience with more than just one project.

Description:
The goal of this task is to establish the foundational elements for implementing CI/CD pipelines in our upcoming projects. This involves creating a GitLab account and setting up a GitLab Runner within a Kubernetes cluster. The GitLab Runner in Kubernetes will enable us to manage CI/CD jobs efficiently with scalability and flexibility, leveraging Kubernetes' container orchestration capabilities.

Key Steps:
GitLab Account Creation:

Sign up for a new GitLab account.

The most-comprehensive AI-powered DevSecOps platform 

Familiarize yourself with the GitLab interface and explore its various functionalities.

Get started with GitLab CI/CD | GitLab 

CI/CD components | GitLab 

Tutorial: Create and run your first GitLab CI/CD pipeline | GitLab 

lib/gitlab/ci/templates/Bash.gitlab-ci.yml · master · GitLab.org / GitLab · GitLab 

GitLab.org / charts / GitLab Runner · GitLab 

Kubernetes Cluster Access:

Ensure access to a Kubernetes cluster.

Set up kubectl to communicate with the Kubernetes cluster. (from localhost)

Helm Installation:

Install Helm to deploy the GitLab Runner using Helm charts.Helm | Helm 

GitLab Runner Deployment:

Add the GitLab Helm chart repository and update Helm.                                                                     

Create a dedicated namespace for the GitLab Runner in Kubernetes.

Deploy the GitLab Runner using Helm, ensuring it's configured to connect with the GitLab account.

GitLab.org / charts / GitLab Runner · GitLab 

GitLab Runner | GitLab 

Tutorial: Create, register, and run your own project runner | GitLab 

GitLab Runner Helm Chart | GitLab

GitLab Runner Helm Chart | GitLab 

Runner Configuration and Registration:

Configure the Runner to use Kubernetes as the executor.

Register the Runner with the GitLab instance using a registration token.

Security and Access Controls:

Apply Kubernetes security best practices and RBAC configurations.

Ensure the Runner has the necessary permissions to perform CI/CD tasks:

for Terraform pipelines (GitOps)

for container application CI/CD pipelines

Testing and Verification:

Test the setup by running a simple CI job through the Runner (own GitLab runner).

Tutorial: Create and run your first GitLab CI/CD pipeline | GitLab 

Verify that the Runner is operational and interacting correctly with Kubernetes.

Documentation:

Document the entire process, including account creation, Helm chart configuration, and Runner registration.

Include troubleshooting tips, scaling guidelines, and maintenance instructions.

Demo:

Add a note about how this would be in a real work environment, ex:

Your company would probably already have a GitLab account setup with billing and other information configured

The company would probably use GitLab as a VCS instead of GitHub. So, it would have a GitLab Organization instead of a GitHub organization.

Outline GitLabCI features in the demo since it has many DevOps tools. It’s meant to help with a full DevOps cycle.

Outline GitLab vs. GitHub vs Bitbucket differences for VCS.

For example:

The main reason to go for it is a pricing bundle. Atlassian products (Jira, Confluence, etc.) can be bundled with BitBucket. GitLabCI can be bundled with GitLab and other DevOps features of GitLab (one example is GitLab managed to terraform state files). GitHub can be bundled with GitHub actions or GitHub projects.

Git commands do not differ whether you use GitHub, GitLab, or BitBucket.

DiagramFlowchart Maker & Online Diagram Software (additional)

Bonus point(could be a great talking point for interviews):

One security related, such as container image scanning for vulnerabilities.

Container Scanning | GitLab 

One related to infrastructure management, such as managed terraform state file

GitLab-managed Terraform state | GitLab 

Deliverables:
Active GitLab Account: Ready for project integration.

Configured GitLab Runner in Kubernetes: Fully operational within the Kubernetes environment.

Comprehensive Documentation: Covering all steps, configurations, and best practices.

Code should be located in: devops-tools.. team repository

Success Criteria:
The GitLab account is operational and accessible.

GitLab Runner is successfully deployed in Kubernetes and registered with the GitLab account.

The Runner can effectively manage CI jobs, demonstrating its functionality and integration.

Additional tips:
Getting started is the hardest but the most important part.

Define an action plan before diving into work. Outline it in bullet points or draw a diagram of steps if necessary.

Don't overthink or panic. Ask clarifying questions about your action plan. If you find a story too challenging to understand, discuss it with a Project Manager within three days of assignment.

Show your soft skills by communicating frequently and professionally, and stay engaged.

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


16: 


[GitLabCI + Terraform] Automate deployment of Versus app to EC2 hosts (Packer)

Attach

Create subtask

Create

In Progress

Actions
Description
1st grade story: Mid to Large scale projects that can be used as one of the most impactful/heavyweight in the interviews.

Create Deployment Package for Versus App Using Packer, Terraform, and GitLab CI
Description:
The objective of this task is to create a comprehensive deployment package enabling the deployment of the Versus App on AWS EC2 instances. The deployment process should leverage Packer for Amazon Machine Image (AMI) creation, Terraform for infrastructure setup, and GitLab CI for continuous integration and deployment workflows. The package must adhere to best practices in cloud infrastructure management and automation.

Key Requirements:
Packer Integration: Utilize Packer to create a custom AMI that includes the Versus App and all necessary dependencies. The AMI should be configured with a systemd service to manage the application lifecycle.

Terraform Setup: Use Terraform to define and manage AWS infrastructure, including but not limited to EC2 instances (or Autoscaling Groups), Security Groups, Elastic Load Balancers (ELB), and IAM roles.

GitLab CI Workflow: Configure GitLab CI to automate the processes of building the AMI with Packer, deploying infrastructure with Terraform, and conducting post-deployment health checks.

Systemd Service for App Management: Instead of using npm start in the Packer provisioner script, create a systemctl daemon (e.g., versus-frontend). Ensure it's enabled to start on system reboot (use /etc/fstab), guaranteeing the app's automatic startup on new EC2 instances.

Documentation: Prepare a comprehensive README file detailing the deployment architecture, configuration, and installation instructions.

Deliverables:
Custom AMI: Built with Packer, containing the Versus App and a configured systemd service.

Infrastructure Code: Terraform configurations for setting up all required AWS resources.

CI/CD Pipeline Configuration: A .gitlab-ci.yml file with defined stages for AMI building, infrastructure deployment, and health checks.

Documentation: A README file documenting the deployment process, architecture, and any necessary instructions for replication or maintenance.

Code should be located in: versus-.. team repository

Demo:

Add a note about how this would be in a real work environment, ex:

Your company would probably already have a GitLab account setup with billing and other information configured

The company would probably use GitLab as a VCS instead of GitHub. So, it would have a GitLab Organization instead of a GitHub organization.

Outline GitLabCI features in the demo since it has many DevOps tools. It’s meant to help with a full DevOps cycle.

Outline GitLab vs. GitHub vs Bitbucket differences for VCS.

For example:

The main reason to go for it is a pricing bundle. Atlassian products (Jira, Confluence, etc.) can be bundled with BitBucket. GitLabCI can be bundled with GitLab and other DevOps features of GitLab (one example is GitLab managed to terraform state files). GitHub can be bundled with GitHub actions or GitHub projects.

Git commands do not differ whether you use GitHub, GitLab, or BitBucket.

DiagramFlowchart Maker & Online Diagram Software (additional) 

Bonus point(could be a great talking point for interviews):

One related to infrastructure management, such as managed terraform state file

GitLab-managed Terraform state | GitLab 

Testing and Validation:
Test the entire deployment pipeline in a controlled environment.

Validate the functionality and accessibility of the Versus App through the ELB URL which is setup as an Alias/CNAME to your custom domain versus-on-vms-TEAM-dev.TEAM_DOMAIN (ex: versus-on-vms-ubuntu-dev.312ubuntu.com).

Ensure the resilience of the deployment (e.g., autoscaling, instance restarts).

Success Criteria:
The Versus App is seamlessly deployable via the created package.

The app is accessible over the internet and responds as expected.

All infrastructure components are correctly provisioned and configured.

The deployment process is fully automated and documented.

Links:

Packer by HashiCorp 

The most-comprehensive AI-powered DevSecOps platform 

Terraform by HashiCorp 

The most-comprehensive AI-powered DevSecOps platform 

Get started with GitLab CI/CD | GitLab 

CI/CD components | GitLab 

Tutorial: Create and run your first GitLab CI/CD pipeline | GitLab 

Additional tips:
Getting started is the hardest but the most important part.

Define an action plan before diving into work. Outline it in bullet points or draw a diagram of steps if necessary.

Don't overthink or panic. Ask clarifying questions about your action plan. If you find a story too challenging to understand, discuss it with a Project Manager within three days of assignment.

Show your soft skills by communicating frequently and professionally, and stay engaged.

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



17 : 



[GitLabCI] Setup CI/CD for Versus (Kubernetes)

Attach

Create subtask

Create

In Progress

Actions
Description
1st grade story: Mid to Large scale projects that can be used as one of the most impactful/heavyweight in the interviews.

Description:
Purpose: Configure the Versus app to be built and deployed via GitLab CI/CD.

Deliverables:

Application deployed end-to-end in Dev environment through GitLab CI/CD and accessible via the Internet with the below hostname structure.

Docker for building the application.

AWS ECR as the image registry, with repository immutability enabled.

Use git SHA for image tagging.

Use Helm chart for deploying both frontend and backend apps.

Use Helm values, but since this is a single-stage setup - create only dev-values.yaml for each app: frontend and backend.

Must have dev, staging, and prod environment configs enabled for each app: frontend and backend..

but use only dev environment during the final project. Staging and Production environments do not exist yet in the final project, but everything should be configured with an assumption that if the project was to continue - deployment into staging and production environments would require little to no changes or adjustments.

for example, create 3 helm values YAML files - dev-values.yaml, staging-values.yaml, prod-values.yaml, even though we will only get to use dev-values.yaml during this project due to time constraints.

Deploy apps in versus-app namespace

Create an Ingress rules to expose both the frontend and backend apps.

Must deploy with hostnames configured and accessible to the Internet (e.g., 312centos.com, 312ubuntu.com, 312redhat.com).

requested domain syntax versus-TEAM-dev.TEAM_DOMAIN (ex: versus-ubuntu-dev.312ubuntu.com)

define values in staging and production configs accordingly, even if we are not going to deploy them yet (versus-TEAM-staging.TEAM_DOMAIN, versus-TEAM.TEAM_DOMAIN)

README explaining GitLab CI/CD deployment strategy in a multi-environment along with installation/configuration instructions.

Database Connectivity for Backend:

Establish network connectivity from the backend application pods to the Database instance.

Integrate AWS SecretsManager secrets with Kubernetes secrets for Security:

Create a Kubernetes secret via ASCP and SecretProviderClass from AWS Secrets Manager for the provisioned DB.

Use AWS Secrets Manager secrets in Amazon Elastic Kubernetes Service - AWS Secrets Manager 

refer to Technical Interview Prep class recordings for guidance

Configure backend application pods to retrieve DB connection details from the Kubernetes secret (use supported ENV variables, as per backend README).

Code should be located in: versus-.. team repository

Implement TLS for Security:

Request a certificate from LetsEncrypt, or use a Wildcard Certificate that any of your teammates might have requested already.

store TLS cert in the Kubernetes secret, and specify in Ingress rules to provide TLS termination at Ingress controller

refer to Technical Interview Prep class recordings for guidance

Notes:

API endpoint needs to be publicly accessible for the Versus app to function properly.

Do not create new load balancers for the app; reuse existing Ingress-nginx controller in the cluster.

Acceptance Criteria:

GitLab Repository Setup:

A GitLab repository for the Versus app has been created. (app repo should be migrated to GitLab from GitHub)

The codebase is structured and organized within the repository.

GitLab CI/CD Configuration:

A .gitlab-ci.yml file is present in the repository's root.

The GitLab CI/CD pipeline is configured to build and deploy the Versus app in dev and prod environments.

GitLab's Kubernetes integration is used to deploy to Kubernetes clusters.

Helm charts are used for managing Kubernetes deployments.

Hostname Configuration:

During deployment, the GitLab CI/CD pipeline configures the specified hostnames (e.g., 312centos.com, 312ubuntu.com, 312redhat.com).

Ingress resources are correctly configured in Kubernetes to route traffic to the appropriate services.

API Endpoint Accessibility:

API endpoints are publicly accessible from the internet to ensure the proper functioning of the Versus app.

DNS configurations and Ingress controllers are set up to enable external access.

README Documentation:

A comprehensive README  file is available in the repository.

The README includes detailed instructions for deploying and configuring the Versus app using GitLab CI/CD.

Instructions for setting up Helm charts, configuring environments, and relevant links to documentation are provided.

Testing and Validation:

The GitLab CI/CD pipeline has been tested and validated to ensure correct deployment in both dev and prod environments.

The specified hostnames are accessible from the internet, and traffic is routed correctly to the app services.

The Versus app functions as expected after deployment.

Maintenance and Updates:

Documentation includes guidelines for making future updates and performing maintenance using GitLab CI/CD.

Best practices for handling application updates and database migrations are documented.

Demo:

Add a note about how this would be in a real work environment, ex:

Your company would probably already have a GitLab account setup with billing and other information configured

The company would probably use GitLab as a VCS instead of GitHub. So, it would have a GitLab Organization instead of a GitHub organization.

Outline GitLabCI features in the demo since it has many DevOps tools. It’s meant to help with a full DevOps cycle.

Outline GitLab vs. GitHub vs Bitbucket differences for VCS.

For example:

The main reason to go for it is a pricing bundle. Atlassian products (Jira, Confluence, etc.) can be bundled with BitBucket. GitLabCI can be bundled with GitLab and other DevOps features of GitLab (one example is GitLab managed to terraform state files). GitHub can be bundled with GitHub actions or GitHub projects.

Git commands do not differ whether you use GitHub, GitLab, or BitBucket.

DiagramFlowchart Maker & Online Diagram Software (additional) 

Bonus point(could be a great talking point for interviews):

One security related, such as container image scanning for vulnerabilities.

Container Scanning | GitLab 

One related to infrastructure management, such as managed terraform state file

GitLab-managed Terraform state | GitLab 

Links:

The most-comprehensive AI-powered DevSecOps platform 

Get started with GitLab CI/CD | GitLab 

CI/CD components | GitLab 

Tutorial: Create and run your first GitLab CI/CD pipeline | GitLab 

Additional tips:
Getting started is the hardest but the most important part.

Define an action plan before diving into work. Outline it in bullet points or draw a diagram of steps if necessary.

Don't overthink or panic. Ask clarifying questions about your action plan. If you find a story too challenging to understand, discuss it with a Project Manager within three days of assignment.

Show your soft skills by communicating frequently and professionally, and stay engaged.

Refer to Technical Interview Prep...App CI/CD... classes and App repository with CI/CD implemented for guidelines on how to structure the pipelines, folder structure, helm chart, etc

this story will require creation of gitlab-ci.yaml instead of .github/workflows/workflow.yaml

GitLab Documentation, Internet search, Youtube tutorials, and ChatGPT are the best places to get started.

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






13 : MY TICKET : 

# -GitHub-Actions-CI-CD-Automate-deployment-of-Proshop-app
[GitHub Actions] CI/CD: Automate deployment of Proshop app


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

note: you can reuse the role if it already exists, adjusting the trust policy to allow your repository env as well - About security hardening with OpenID Connect - GitHub Docs ""https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#filtering-for-a-specific-environment""




ensure it has necessary permissions to Build and Push images to ECR

Using Trust policy, be sure to limit access specifically to your organization (YOUR_USERNAME) and relevant repositories. Refer to Configuring OpenID Connect in Amazon Web Services - GitHub Docs ""https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services""


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

Use AWS Secrets Manager secrets in Amazon Elastic Kubernetes Service - AWS Secrets Manager  ""https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_csi_driver.html""



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

What to Say in Standup Meetings: 10 Rules for Better Updates ""https://www.parabol.co/blog/what-to-say-in-standup-meetings/"""

Avoid procrastination.

Start your workday with a bit of motivation.

Watch one motivational video every day before starting work on your story. Consistency in this routine can lead to project completion in 19 days or sooner.

Create a simple routine to stop procrastinating: start by watching 1 motivational video every day you show up to work on your story. If you do this consistently - you will finish the project before you get to watch all 19 videos over 19 days.

19 Inspirational Videos That Will Completely Blow You Away (2024) ""https://www.oberlo.com/blog/23-inspirational-videos-will-completely-blow-away""


Team Collaboration

Team collaboration goes beyond just working on a story together. It's about engaging with your team by asking questions, updating everyone on your progress, and sharing insights. Don't hesitate to talk about the mistakes you've made, big or small, – these experiences are valuable for everyone. Also, regularly ask for peer code reviews. This approach strengthens your knowledge and improves your mental well-being.

Learning from Mistakes and potentially using them in Job interviews

Mistakes and problems are part of the learning process. Never give up on your story when facing a challenge; struggling indicates learning.

However, communicate effectively to avoid wasting time on solvable issues or unnecessary tasks.

Document and learn from these mistakes, as this experience is invaluable.

When discussing your story in interviews, articulately define the challenges you faced to build trust in your answer.

Refer to this page on how to define the Issue and Solution - https://www.notion.so/312-bc/Building-Confidence-50d4652222844167870c1b4a9ea2c3e0?pvs=4#8a0455e889fe4f4a8bd6ae23e867bef0.

Notes:
link to the original repo bradtraversy/proshop-v2 ""https://github.com/bradtraversy/proshop-v2"""




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










