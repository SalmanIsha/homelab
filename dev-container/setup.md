# 🛠️ Personal DevOps Tool Box

A lightweight, ephemeral Docker container equipped with all essential DevOps tools (`Ansible`, `Terraform`, `AWS CLI`, `jq`, `git`). This setup allows you to execute infrastructure tasks securely without cluttering your local machine with dependencies.

## 🚀 Quick Start

### 1. Prerequisites
Ensure you have **Docker** installed and running on your local machine.

### 2. File Setup
Create a new directory and save the following two files inside it.

#### `Dockerfile`
```dockerfile
# Use a lightweight, stable base image
FROM python:3.11-slim

# Install system dependencies and tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    git \
    jq \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip ./aws

# Install Terraform
ENV TERRAFORM_VERSION=1.7.5
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform.zip

# Install Ansible via pip
RUN pip install --no-cache-dir ansible

# Set workspace directory inside the container
WORKDIR /workspace

# Default command opens a bash shell
CMD ["/bin/bash"]
```

### 3. Build the Image
Open your terminal in the directory containing the `Dockerfile` and run:
```bash
docker build -t devops-box .
```

### 4. Run the Container
Run the following command to launch the container. This mounts your current directory, AWS credentials, and SSH keys into the workspace.

#### For Linux / macOS (Bash/Zsh):
```bash
docker run -it --rm \
  -v "$(pwd)":/workspace \
  -v "$HOME/.aws":/root/.aws:ro \
  -v "$HOME/.ssh":/root/.ssh:ro \
  devops-box
```

#### For Windows (PowerShell):
```powershell
docker run -it --rm `
  -v "${PWD}:/workspace" `
  -v "${HOME}/.aws:/root/.aws:ro" `
  -v "${HOME}/.ssh:/root/.ssh:ro" `
  devops-box
```

---

## ⚡ Streamline with Shortcuts (Optional)

Avoid typing the long `docker run` command every time by creating an alias. 

### Linux / macOS
Add this line to your `~/.bashrc` or `~/.zshrc`:
```bash
alias dbox='docker run -it --rm -v "$(pwd)":/workspace -v "$HOME/.aws":/root/.aws:ro -v "$HOME/.ssh":/root/.ssh:ro devops-box'
```
*Run `source ~/.bashrc` or `source ~/.zshrc` to apply.*

### Windows (PowerShell)
Add this function to your PowerShell profile script (`$PROFILE`):
```powershell
function dbox {
    docker run -it --rm -v "${PWD}:/workspace" -v "${HOME}/.aws:/root/.aws:ro" -v "${HOME}/.ssh:/root/.ssh:ro" devops-box
}
```

**Usage:** Navigate to any folder with infrastructure code and simply type `dbox`.

---

## 🔍 How It Works

*   `--rm`: Automatically deletes the container instance upon exiting to save disk space.
*   `-v "$(pwd)":/workspace`: Mounts your local project files. Code modifications persist on your host machine.
*   `:ro`: Mounts your sensitive local credentials securely as **Read-Only**.
