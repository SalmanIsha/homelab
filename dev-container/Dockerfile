# Use a lightweight, stable base image
FROM python:3.11-slim AS base

# Install system dependencies and tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    git \
    jq \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://amazonaws.com" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip ./aws

# Install Terraform (Adjust version as needed)
ENV TERRAFORM_VERSION=1.7.5
RUN curl -fsSL https://hashicorp.com{TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/ \
    rm terraform.zip

# Install Ansible via pip (keeps it isolated and lightweight)
RUN pip install --no-cache-dir ansible

# Set workspace directory inside the container
WORKDIR /workspace

# Default command opens a bash shell
CMD ["/bin/bash"]

