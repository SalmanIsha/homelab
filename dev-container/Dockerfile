# Use a lightweight, stable base image
FROM python:3.11-slim AS base

# Install system dependencies and tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    git \
    jq \
    openssh-client \
    vim \
    && apt-get clean \
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

# Security scanning tools
# Trivy - container/filesystem/IaC vulnerability & misconfig scanner
ENV TRIVY_VERSION=0.76.1
RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
      amd64) TRIVY_ARCH=64bit ;; \
      arm64) TRIVY_ARCH=ARM64 ;; \
      *) echo "Unsupported architecture" >&2; exit 1 ;; \
    esac; \
    curl -fsSL "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-${TRIVY_ARCH}.tar.gz" | tar -xz -C /usr/local/bin trivy

# Gitleaks - secret detection in git repos/code
ENV GITLEAKS_VERSION=8.24.3
RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
      amd64) GITLEAKS_ARCH=x64 ;; \
      arm64) GITLEAKS_ARCH=arm64 ;; \
      *) echo "Unsupported architecture" >&2; exit 1 ;; \
    esac; \
    curl -fsSL "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_${GITLEAKS_ARCH}.tar.gz" | tar -xz -C /usr/local/bin gitleaks

# Semgrep - multi-language static analysis (SAST)
RUN pip install --no-cache-dir semgrep

# Bandit - Python static analysis (SAST)
RUN pip install --no-cache-dir bandit

# Checkov - IaC security & compliance (Terraform, K8s, Docker, etc.)
RUN pip install --no-cache-dir checkov

# Nmap - network exploration/scanning
RUN apt-get update && apt-get install -y --no-install-recommends \
    nmap \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set workspace directory inside the container
WORKDIR /workspace

# Default command opens a bash shell
CMD ["/bin/bash"]
