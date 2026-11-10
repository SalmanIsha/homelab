# 🛡️ Security Tools — Usage Commands

Quick reference for the open-source security tools installed in `devops-box`.

Run the container, then use the commands below inside it:

```bash
docker-compose run --rm devops-box
```

---

## Trivy — containers / filesystem / IaC vulnerability & misconfig scanner

```bash
# Scan a project's dependencies (lockfiles) for CVEs
trivy fs /workspace/myapp

# Scan Terraform / Kubernetes / Docker configs for misconfigs
trivy config /workspace/terraform

# Scan both dependencies and misconfigs together
trivy fs --scanners vuln,misconfig /workspace

# Scan a container image for vulnerabilities
trivy image your-image:tag

# Scan a git repository (remote)
trivy repo https://github.com/org/repo

# Generate an SBOM
trivy fs --format cyclonedx --output sbom.json /workspace/myapp
```

> Trivy scans **dependencies** and **configs**. It is **not** a SAST tool — use semgrep/bandit for your own source logic.

---

## Semgrep — multi-language static analysis (SAST) ✅ for JS/TS/Vite

```bash
# Auto-select rules (covers JS/TS/React/Node — your Vite code)
semgrep scan --config=auto /workspace/vite-app

# Focused security rule pack
semgrep scan --config=p/security-audit /workspace/vite-app

# Output as JSON
semgrep scan --config=auto --json /workspace/vite-app
```

> Supports 50+ languages including JavaScript/TypeScript/JSX/TSX.

---

## Bandit — Python static analysis (SAST)

```bash
# Scan a Python project recursively
bandit -r /workspace/python-service

# Show only high-confidence, high-severity findings
bandit -r /workspace/python-service -ll -iii

# Output to a file
bandit -r /workspace/python-service -o bandit-report.txt
```

> **Python only.** Does not understand JS/TS — won't work on Vite code.

---

## Gitleaks — secret detection in code & git history

```bash
# Scan a directory for leaked secrets
gitleaks detect --source /workspace/myapp -v

# Scan the current git repo (all history)
gitleaks detect -v

# Scan using a custom config/rules file
gitleaks detect --source /workspace --config /path/to/gitleaks.toml

# Full repo history audit
gitleaks git --repository /workspace/myapp -v
```

---

## Checkov — IaC security & compliance (Terraform, K8s, Docker)

```bash
# Scan a Terraform directory
checkov -d /workspace/terraform

# Output only failed checks
checkov -d /workspace/terraform --compact

# Output to a file (JSON)
checkov -d /workspace/terraform -o json --output-file-path checkov-report.json

# Scan a single file
checkov -f /workspace/terraform/main.tf
```

---

## Nmap — network discovery & scanning

```bash
# Basic scan of a host
nmap 192.168.1.10

# Scan a subnet
nmap -sV 192.168.1.0/24

# Detect versions + run default scripts
nmap -sV -sC 192.168.1.10

# Full port range
nmap -p- 192.168.1.10

# Output to a file
nmap -oN scan.txt 192.168.1.0/24
```

> **Legal note:** only scan hosts/networks you own or have explicit permission to test.

---

## Installed versions

| Tool | Version | Purpose |
|------|---------|---------|
| trivy | 0.76.1 | Container / FS / IaC scanner |
| semgrep | 1.182.1 | Multi-language SAST (JS/TS) |
| bandit | 3.11.16 | Python SAST |
| checkov | 3.4.0 | IaC security & compliance |
| gitleaks | 8.24.3 | Secret detection |
| nmap | 7.95 | Network scanning |
