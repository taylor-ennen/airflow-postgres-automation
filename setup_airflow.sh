#!/bin/bash

# Check for Docker and Docker Compose installation
check_dependencies() {
    if ! command -v docker &> /dev/null; then
        echo "Error: Docker is not installed. Please install Docker and rerun this script."
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null; then
        echo "Error: Docker Compose is not installed. Please install Docker Compose and rerun this script."
        exit 1
    fi
}

# Create Dockerfile
create_dockerfile() {
    cat <<EOF >Dockerfile
# Dockerfile for Airflow setup
# Using the official Airflow image as a base
FROM apache/airflow:latest

# Set environment variable for Airflow home directory
ENV AIRFLOW_HOME=/usr/local/airflow

# Install PostgreSQL client
USER root
RUN apt-get update && apt-get install -y --no-install-recommends postgresql-client && rm -rf /var/lib/apt/lists/*

# Add user management script
COPY manage_users.sh /usr/local/airflow/manage_users.sh
RUN chmod +x /usr/local/airflow/manage_users.sh

USER airflow
EOF
}

# Create docker-compose.yml
create_docker_compose() {
    cat <<EOF >docker-compose.yaml
# Docker Compose configuration for Airflow with PostgreSQL
version: '

services:
  postgres:
    image: postgres:latest
    environment:
      POSTGRES_USER: \${POSTGRES_USER}
      POSTGRES_PASSWORD: \${POSTGRES_PASSWORD}
      POSTGRES_DB: \${POSTGRES_DB}
    volumes:
      - postgres_data:/var/lib/postgresql/data

  webserver:
    build: .
    depends_on:
      - postgres
    ports:
      - "8080:8080"
    environment:
      AIRFLOW__CORE__SQL_ALCHEMY_CONN: postgresql+psycopg2://\${POSTGRES_USER}:\${POSTGRES_PASSWORD}@postgres/\${POSTGRES_DB}
      AIRFLOW_USER: \${AIRFLOW_USER}
      AIRFLOW_PASSWORD: \${AIRFLOW_PASSWORD}
      AIRFLOW_EMAIL: \${AIRFLOW_EMAIL}
      AIRFLOW_FIRSTNAME: \${AIRFLOW_FIRSTNAME}
      AIRFLOW_LASTNAME: \${AIRFLOW_LASTNAME}

volumes:
  postgres_data:
EOF
}

# Create manage_users.sh
create_manage_users_script() {
    cat <<EOF >manage_users.sh
# Script for managing Airflow users
# Waits for Airflow to be up and initializes the database
sleep 10
airflow db init

# Delete the default admin user
airflow users delete -u admin

# Create a new Airflow user
airflow users create \\
    --username "\${AIRFLOW_USER}" \\
    --firstname "\${AIRFLOW_FIRSTNAME}" \\
    --lastname "\${AIRFLOW_LASTNAME}" \\
    --role Admin \\
    --email "\${AIRFLOW_EMAIL}" \\
    --password "\${AIRFLOW_PASSWORD}"
EOF
    chmod +x manage_users.sh
}

# Main function
main() {
    # Setup directory
    DIR="airflow-docker-setup"
    mkdir -p "$DIR"
    cd "$DIR" || exit

    # Check dependencies
    check_dependencies

    # Create files
    create_dockerfile
    create_docker_compose
    create_manage_users_script

    echo "Airflow Docker setup is ready. Navigate to the '$DIR' directory and run 'docker-compose up' to start."
}

# Execute main function
main
