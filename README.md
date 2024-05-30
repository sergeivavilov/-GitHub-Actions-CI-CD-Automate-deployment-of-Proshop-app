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













