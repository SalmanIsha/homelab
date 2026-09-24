# Vikunja Kubernetes Deployment Guide (SQLite3 & Home Network)

This document provides a clean, unified reference guide for deploying **Vikunja** in a Kubernetes cluster without Helm, optimized for an internal home network using a single-replica **SQLite3** database.

---

## 1. Unified Deployment Manifest (`vikunja.yaml`)

This single manifest contains the PersistentVolumeClaim (PVC), the Deployment (including resource limits and health probes), and the Service.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: vikunja-data-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vikunja
spec:
  replicas: 1
  strategy:
    type: Recreate # Required for SQLite to prevent simultaneous file access conflicts
  selector:
    matchLabels:
      app: vikunja
  template:
    metadata:
      labels:
        app: vikunja
    spec:
      securityContext:
        fsGroup: 1000 # Matches Vikunja's default user ID for directory permissions
      containers:
        - name: vikunja
          image: vikunja/vikunja:latest
          ports:
            - containerPort: 3456
              name: http
          env:
            # Database Configuration
            - name: VIKUNJA_DATABASE_TYPE
              value: "sqlite"
            - name: VIKUNJA_DATABASE_PATH
              value: "/app/vikunja/files/vikunja.db" # Database stays safe inside the PVC path
            
            # Service Configuration (Configured for Home Network)
            - name: VIKUNJA_SERVICE_PUBLICURL
              value: "http://pm.salman.com/"
          
          # Resource Allocations sized for Homelab usage
          resources:
            requests:
              memory: "128Mi"
              cpu: "100m"
            limits:
              memory: "512Mi"
              cpu: "500m" # Prevents CPU throttling during heavy AI/automation loops
          
          # Health and Status Probes
          startupProbe:
            httpGet:
              path: /health
              port: http
            initialDelaySeconds: 5
            periodSeconds: 5
            failureThreshold: 12 # Gives the app 60 seconds to finish database migrations on boot
          
          livenessProbe:
            httpGet:
              path: /health
              port: http
            periodSeconds: 15
            timeoutSeconds: 3
            failureThreshold: 3 # Forcefully restarts the container if it deadlocks or freezes
          
          readinessProbe:
            httpGet:
              path: /health
              port: http
            periodSeconds: 10
            timeoutSeconds: 3
            successThreshold: 1
            failureThreshold: 2 # Gates network traffic out if overloaded
            
          volumeMounts:
            - name: vikunja-data
              mountPath: /app/vikunja/files
      volumes:
        - name: vikunja-data
          persistentVolumeClaim:
            claimName: vikunja-data-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: vikunja
spec:
  ports:
    - port: 3456
      targetPort: 3456
      protocol: TCP
  selector:
    app: vikunja
```

---

## 3. Quick Reference Architecture Notes

Even in a **single-replica (replicas: 1)** infrastructure, configuring individual probes is critical to protect your deployment:

*   **Startup Probe (The Guard):** 
    *   **Purpose:** Runs exclusively when the container boots up. It temporarily pauses the execution of liveness and readiness checks.
    *   **Homelab Application:** Gives Vikunja up to 60 seconds to initialize database tables and handle system upgrades. It prevents Kubernetes from prematurely killing the container while it's modifying the raw SQLite file on startup.
*   **Readiness Probe (The Gatekeeper):** 
    *   **Purpose:** Evaluates whether the application is presently capable of processing end-user web traffic.
    *   **Homelab Application:** Controls deployment flow during updates. Kubernetes waits until the new pod passes this probe before shutting down the old pod, guaranteeing zero-downtime routing. Additionally, if an automation tool or an LLM (like OpenCode via Model Context Protocol) slams the API and overwhelms the app, the probe fails and blocks inbound traffic temporarily, allowing the container to catch up without hard-crashing.
*   **Liveness Probe (The Medic):** 
    *   **Purpose:** Continually confirms that the container hasn't permanently frozen, deadlocked, or crashed.
    *   **Homelab Application:** If the underlying web engine completely locks up and stops responding, Kubernetes will step in and perform a container restart to automatically restore availability.

---

## 4. Deployment Commands

Execute the following commands in your terminal to initialize the deployment:

```bash
kubectl apply -f vikunja.yaml
kubectl apply -f vikunja-ingress.yaml
```