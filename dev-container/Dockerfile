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
RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
      amd64) AWS_ARCH=x86_64 ;; \
      arm64) AWS_ARCH=aarch64 ;; \
      *) echo "Unsupported architecture" >&2; exit 1 ;; \
    esac; \
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" -o awscliv2.zip; \
    unzip awscliv2.zip; \
    ./aws/install; \
    rm -rf awscliv2.zip ./aws

# Install Terraform (Adjust version as needed)
ENV TERRAFORM_VERSION=1.16.3
RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
      amd64) TF_ARCH=amd64 ;; \
      arm64) TF_ARCH=arm64 ;; \
      *) echo "Unsupported architecture" >&2; exit 1 ;; \
    esac; \
    curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TF_ARCH}.zip" -o terraform.zip; \
    unzip terraform.zip; \
    mv terraform /usr/local/bin/; \
    rm terraform.zip

# Install Ansible via pip (keeps it isolated and lightweight)
RUN pip install --no-cache-dir ansible

# Set workspace directory inside the container
WORKDIR /workspace

# Default command opens a bash shell
CMD ["/bin/bash"]
