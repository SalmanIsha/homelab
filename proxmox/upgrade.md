# Proxmox VE 9 (No-Subscription) Upgrade Guide

This guide details the step-by-step process for applying minor patches and upgrades to a free version of Proxmox VE 9 (Debian 13 "Trixie") using the modern DEB822 `.sources` format via the Command Line Interface (CLI).

---

## Prerequisites & Verification

Before running updates, verify your current Proxmox setup and ensure you have backups of all critical Virtual Machines (VMs) and Containers (LXCs).

```bash
# Check the current running Proxmox version and kernel
pveversion -v
```

---

## Step 1: Verify Repository Configuration

Proxmox 9 uses the modern DEB822 `.sources` format located in `/etc/apt/sources.list.d/`. Ensure your files match the configurations below to completely bypass the paid enterprise repository.

### 1. Main Debian Repositories
Verify your Debian base layout:
```bash
cat /etc/apt/sources.list.d/debian.sources
```
**Expected Output:**
```text
Types: deb
URIs: http://deb.debian.org/debian/
Suites: trixie trixie-updates
Components: main contrib non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: http://security.debian.org/debian-security/
Suites: trixie-security
Components: main contrib non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
```

### 2. Proxmox Free Repository
Verify your Proxmox free repository layout:
```bash
cat /etc/apt/sources.list.d/proxmox.sources
```
**Expected Output:**
```text
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
```

*(Note: Ensure that any legacy enterprise files like `/etc/apt/sources.list.d/pve-enterprise.list` or `/etc/apt/sources.list.d/pve-enterprise.sources` do not exist, or have their lines completely commented out with `#` to prevent 401 Unauthorized errors).*

---

## Step 2: Apply Updates

Run the upgrade sequence. **Never** use a standard `apt upgrade` on Proxmox, as it may hold back vital hypervisor and virtualization packages.

```bash
# 1. Refresh the local package databases
apt update

# 2. Safely apply all system updates and dependency changes
apt full-upgrade -y
```

---

## Step 3: Finalize & Reboot

If the upgrade installed a new Linux kernel, ZFS modules, or microcode updates, a system restart is required to load them into memory.

```bash
# Reboot the hypervisor host
reboot
```

---

## Step 4: Post-Upgrade Verification

Once the server boots back up, log in via SSH or the Shell and verify the system state:

```bash
# Confirm the new Proxmox version and updated kernel are active
pveversion -v
```

---

## Troubleshooting

### Error: "401 Unauthorized" during `apt update`
* **Cause:** The system is still trying to hit the paid enterprise repository endpoint.
* **Fix:** Look for any stray enterprise configurations in `/etc/apt/sources.list.d/` and delete or comment them out.

### Message: "No valid subscription" in Web GUI
* **Cause:** Expected behavior on the free tier. 
* **Fix:** Simply click **OK** to dismiss the warning popup when logging into the Proxmox Web UI. It does not restrict any functionality.