# WordPress Automation Project

This project automates the deployment of a WordPress site using a CI/CD pipeline. The infrastructure is provisioned on AWS using Terraform, and the configuration of the WordPress site is managed with Ansible. GitHub Actions is used to orchestrate the entire pipeline.

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
  - [Terraform](#terraform)
  - [Ansible](#Ansible)
  - [GitHub Actions](#github-actions)
- [Setup](#setup)
  - [Prerequisites](#prerequisites)
  - [Clone the Repository](#clone-the-repository)
  - [Set Up GitHub Secrets](#set-up-github-secrets)
  - [Run the Pipeline](#run-the-pipeline)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Project Overview

This project aims to automate the end-to-end deployment of a WordPress site. It includes:

- **Infrastructure as Code (IaC)**: Using Terraform to provision AWS resources.
- **Configuration Management**: Using Ansible to configure WordPress.
- **Continuous Integration/Continuous Deployment (CI/CD)**: Using GitHub Actions to automate the workflow.

### Terraform

Terraform will create the architecture in AWS that is needed for Wordpress to run. This includes a VPC with public and private subnets, security groups, Application Load Balancer, EC2 Instance, Elastic File Share, and Relational Database Service. Visit the 'terraform' directory and view main.tf for more details.

![Architecture Diagram](img/architecture.jpg)

### Ansible

Ansible is the tool we will use for configuration management. It is essentially what will connect to our EC2 instance and install Wordpress. You can view setup.yml in the 'ansible' directory to see the playbook.

- Installing Apache, PHP, and necessary extensions.
- Downloading and configuring WordPress.
- Setting up EFS for shared storage.
- Connecting to RDS for the database.

### GitHub Actions

GitHub Actions is used as the CI/CD pipeline tool. It is what logs into AWS and then runs our Terraform and Ansible configurations automatically upon pushing the code into your own repo. You can view the 'workflow.yml' file in .github/workflows to see it in detail. There is also a 'destroy.yml' file you can run manually in case you want to destroy your infrastructure.

## Setup

### Prerequisites

Before you begin, ensure you have the following:

- AWS account with IAM permissions to create resources.
- SSO setup in your AWS account
- [OIDC Setup](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) so GitHub Actions can configure AWS
- SSH key pair for accessing EC2 instances.

**PLEASE NOTE:** Following this repo will make Wordpress accessible via the DNS name of the Application Load Balancer. This project **DOES NOT** setup a custom domain name for your Wordpress website 

### Clone the Repository

```sh
git clone https://github.com/B-Howell/CI-CD-WordPress-Blog.git
cd CI-CD-WordPress-Blog
```

### Setup GitHub Secrets

GitHub Secrets are necessary to pass variables that should be hidden or custom to you into your pipeline such as a private ssh key or the password to your database. These are the secrets that I use:

- AWS_REGION
- DB_NAME
- DB_PASSWORD
- DB_USERNAME
- ROLE_TO_ASSUME
- SSH_PRIVATE_KEY_BASE64

### Run the Pipeline

Push changes to the master branch to trigger the GitHub Actions workflow, or manually trigger the workflow if you have set up workflow_dispatch.

## Verification

After the pipeline completes, verify the deployment:

    1. Navigate to the DNS name of your ALB to access the WordPress setup page.
    2. Complete the WordPress installation steps in the browser.

## Troubleshooting

- Terraform Errors: Check the Terraform logs in the GitHub Actions workflow for any errors.
- Ansible Errors: Check the Ansible logs in the GitHub Actions workflow for any errors.
- AWS Issues: Ensure your AWS IAM user has the necessary permissions to create resources.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License. See the MIT-LICENSE file for details.