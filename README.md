# airflow-postgres-automation
Script and Results of an Airflow Automation Script which installs Docker, Airflow, and Postgres via a user-friendly Script (relatively).


# Advanced Airflow Docker Setup Script

## Overview
This script automates the setup of Apache Airflow in a Docker environment, using PostgreSQL as the backend. It encapsulates best practices from the Airflow, Docker, and Linux communities, ensuring a secure, efficient, and user-friendly installation.

## Features
- **Automated Setup**: Creates Dockerfile, docker-compose.yml, and user management script.
- **Secure**: Handles sensitive information like passwords carefully.
- **Customizable**: Allows for easy customization and configuration.
- **Dependency Checks**: Ensures Docker and Docker Compose are installed.

## Prerequisites
- Docker
- Docker Compose

## Usage
Run the script, navigate to the created directory (`airflow-docker-setup`), and execute `docker-compose up` to start the Airflow instance.

## Best Practices Implemented
- **Parameterization**: The script allows for flexible configuration.
- **Security**: Sensitive data is not hardcoded but can be set via environment variables.
- **Documentation**: This README provides clear instructions for setup and usage.

## Why This Project?
This project simplifies the process of setting up a robust Airflow environment, making it accessible to those with basic Docker knowledge while ensuring advanced users can still customize as needed.

## Abstracted Complexity
To prevent misuse by inexperienced users, the script requires basic familiarity with Docker and does not expose sensitive configuration details in plaintext or within the script itself.
