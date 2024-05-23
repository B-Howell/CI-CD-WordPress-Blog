# WordPress Automation Project

This project automates the deployment of a WordPress site using a CI/CD pipeline. The infrastructure is provisioned on AWS using Terraform, and the configuration of the WordPress site is managed with Ansible. GitHub Actions is used to orchestrate the entire pipeline.

## Table of Contents

- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Architecture](#architecture)
- [Setup](#setup)
  - [Clone the Repository](#clone-the-repository)
  - [Configure AWS](#configure-aws)
  - [Set Up GitHub Secrets](#set-up-github-secrets)
  - [Run the Pipeline](#run-the-pipeline)
- [Components](#components)
  - [Terraform](#terraform)
  - [Ansible](#ansible)
  - [GitHub Actions](#github-actions)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Project Overview

This project aims to automate the end-to-end deployment of a WordPress site. It includes:

- **Infrastructure as Code (IaC)**: Using Terraform to provision AWS resources.
- **Configuration Management**: Using Ansible to configure WordPress.
- **Continuous Integration/Continuous Deployment (CI/CD)**: Using GitHub Actions to automate the workflow.

## Prerequisites

Before you begin, ensure you have the following:

- AWS account with IAM permissions to create resources.
- Terraform installed on your local machine (if you'd like to test locally).
- Ansible installed on your local machine (if you'd like to test locally).
- GitHub account.
- SSH key pair for accessing EC2 instances.

## Architecture

The architecture consists of the following components:

- **AWS Infrastructure**: VPC, Subnets, Internet Gateway, Route Tables, Security Groups, EC2 instances, RDS (MySQL), EFS, and ALB.
- **WordPress**: Installed and configured on EC2 instances using Ansible.
- **CI/CD Pipeline**: GitHub Actions workflow to automate Terraform and Ansible execution.

## Setup

### Clone the Repository

```sh
git clone https://github.com/yourusername/your-repo-name.git
cd your-repo-name
