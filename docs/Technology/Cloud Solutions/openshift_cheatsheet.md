---
title: OpenShift Cheatsheet
sidebar_position: 3
displayed_sidebar: technologySidebar
tags:
  - openshift
  - kubernetes
  - devops
  - cheatsheet
  - containers
---

# OpenShift Cheatsheet

Quick reference for commonly used `oc` commands. Keep this handy!

---

## 🔐 Login & Authentication

```bash
oc login <cluster-url>                    # Login to cluster (prompts for credentials)
oc login -u <user> -p <password>          # Login with username/password
oc login --token=<token>                  # Login with token
oc logout                                 # Logout from cluster
oc whoami                                 # Show current user
oc whoami --show-token                    # Show current auth token
oc whoami --show-server                   # Show current server URL
oc whoami --show-context                  # Show current context
```

---

## 📁 Projects (Namespaces)

```bash
oc projects                               # List all projects you have access to
oc project                                # Show current project
oc project <project-name>                 # Switch to project
oc new-project <name>                     # Create new project
oc new-project <name> --description="desc" --display-name="Display Name"
oc delete project <name>                  # Delete project (careful!)
oc describe project <name>                # Project details
```

---

## 📦 Pods

```bash
oc get pods                               # List pods in current project
oc get pods -o wide                       # List with more details (IP, node)
oc get pods --all-namespaces              # List pods in all projects
oc get pods -w                            # Watch pods in real-time
oc describe pod <pod-name>                # Detailed pod info
oc logs <pod-name>                        # View pod logs
oc logs -f <pod-name>                     # Stream logs (follow)
oc logs <pod-name> -c <container>         # Logs from specific container
oc logs --previous <pod-name>             # Logs from previous crashed container
oc rsh <pod-name>                         # Remote shell into pod
oc exec -it <pod-name> -- /bin/bash       # Execute bash in pod
oc delete pod <pod-name>                  # Delete pod
oc port-forward <pod-name> 8080:80        # Forward local port to pod
```

---

## 🚀 Applications & Deployments

```bash
# Create applications
oc new-app <image>                        # Create app from image
oc new-app <image-stream>:<tag>           # Create from image stream
oc new-app https://github.com/user/repo   # Create from Git repo (S2I)
oc new-app nodejs~https://github.com/...  # Specify builder image
oc new-app --name=myapp <image>           # Create with custom name
oc new-app --docker-image=<image>         # Create from Docker image

# Manage deployments
oc get deployments                        # List deployments
oc get dc                                 # List deployment configs
oc describe dc <name>                     # Deployment config details
oc rollout status dc/<name>               # Check rollout status
oc rollout latest dc/<name>               # Trigger new deployment
oc rollout history dc/<name>              # View rollout history
oc rollout undo dc/<name>                 # Rollback to previous
oc rollout cancel dc/<name>               # Cancel ongoing rollout
oc scale dc/<name> --replicas=3           # Scale replicas
oc delete all -l app=<name>               # Delete app and all resources
```

---

## 🌐 Services & Routes

```bash
# Services
oc get svc                                # List services
oc describe svc <name>                    # Service details
oc expose dc/<name> --port=8080           # Create service for deployment

# Routes (OpenShift's ingress)
oc get routes                             # List routes
oc describe route <name>                  # Route details
oc expose svc/<name>                      # Create route for service
oc expose svc/<name> --hostname=app.example.com  # Route with custom hostname
oc create route edge --service=<svc> --cert=tls.crt --key=tls.key  # TLS route
oc delete route <name>                    # Delete route
```

---

## 🏗️ Builds & Image Streams

```bash
# Builds
oc get builds                             # List builds
oc get bc                                 # List build configs
oc describe bc <name>                     # Build config details
oc start-build <bc-name>                  # Start a new build
oc start-build <bc-name> --follow         # Start and follow logs
oc start-build <bc-name> --from-dir=.     # Build from local directory
oc cancel-build <build-name>              # Cancel running build
oc logs build/<build-name>                # View build logs
oc logs -f bc/<bc-name>                   # Follow build config logs

# Image Streams
oc get is                                 # List image streams
oc describe is <name>                     # Image stream details
oc import-image <name> --from=<image> --confirm  # Import external image
oc tag <src-image> <dest-stream>:<tag>    # Tag an image
```

---

## ⚙️ ConfigMaps & Secrets

```bash
# ConfigMaps
oc get configmaps                         # List configmaps
oc create configmap <name> --from-literal=key=value
oc create configmap <name> --from-file=<path>
oc describe configmap <name>              # ConfigMap details
oc delete configmap <name>                # Delete configmap

# Secrets
oc get secrets                            # List secrets
oc create secret generic <name> --from-literal=key=value
oc create secret generic <name> --from-file=<path>
oc create secret docker-registry <name> --docker-server=<url> --docker-username=<user> --docker-password=<pass>
oc describe secret <name>                 # Secret details (values hidden)
oc get secret <name> -o yaml              # View secret (base64 encoded)
oc delete secret <name>                   # Delete secret
```

---

## 💾 Storage (PVC)

```bash
oc get pvc                                # List persistent volume claims
oc get pv                                 # List persistent volumes
oc describe pvc <name>                    # PVC details
oc delete pvc <name>                      # Delete PVC
oc set volume dc/<name> --add --type=pvc --claim-name=<pvc> --mount-path=/data
```

---

## 🔒 Security & RBAC

```bash
# Service Accounts
oc get sa                                 # List service accounts
oc create sa <name>                       # Create service account
oc describe sa <name>                     # Service account details

# Role Bindings
oc get rolebindings                       # List role bindings
oc adm policy add-role-to-user <role> <user>  # Grant role to user
oc adm policy add-role-to-user admin developer -n myproject
oc adm policy add-scc-to-user anyuid -z <service-account>  # Add SCC
oc adm policy remove-scc-from-user anyuid -z <service-account>

# Security Context Constraints
oc get scc                                # List SCCs
oc describe scc <name>                    # SCC details
```

---

## 📊 Resource Management

```bash
# View resources
oc get all                                # List all resources in project
oc get all -l app=<name>                  # Filter by label
oc api-resources                          # List all API resources

# Resource quotas & limits
oc get quota                              # List quotas
oc get limitrange                         # List limit ranges
oc describe quota <name>                  # Quota details

# Resource usage
oc adm top nodes                          # Node resource usage
oc adm top pods                           # Pod resource usage
```

---

## 📋 YAML Operations

```bash
oc apply -f <file.yaml>                   # Apply/create from YAML
oc create -f <file.yaml>                  # Create from YAML
oc delete -f <file.yaml>                  # Delete resources from YAML
oc get <resource> <name> -o yaml          # Export as YAML
oc get <resource> <name> -o yaml > file.yaml  # Save to file
oc explain <resource>                     # Explain resource fields
oc explain pod.spec.containers            # Explain specific field
```

---

## 🔧 Debugging & Troubleshooting

```bash
oc get events                             # List cluster events
oc get events --sort-by='.lastTimestamp'  # Events sorted by time
oc describe <resource> <name>             # Detailed resource info
oc debug dc/<name>                        # Start debug pod
oc debug node/<node-name>                 # Debug node
oc adm node-logs <node-name>              # View node logs
oc status                                 # Overview of project status
oc status --suggest                       # Status with suggestions
```

---

## 🏷️ Labels & Annotations

```bash
oc get pods --show-labels                 # Show labels on pods
oc get pods -l app=myapp                  # Filter by label
oc label pod <pod> env=prod               # Add label
oc label pod <pod> env-                   # Remove label
oc annotate pod <pod> desc="my pod"       # Add annotation
```

---

## 🛠️ Useful One-Liners

```bash
# Delete all failed pods
oc delete pods --field-selector=status.phase=Failed

# Get all pod images
oc get pods -o jsonpath="{.items[*].spec.containers[*].image}" | tr ' ' '\n'

# Restart all pods in deployment
oc rollout restart deployment/<name>

# Copy file to/from pod
oc cp <pod>:/path/to/file ./local-file
oc cp ./local-file <pod>:/path/to/file

# Run temporary debug pod
oc run debug --rm -it --image=registry.access.redhat.com/ubi8/ubi -- /bin/bash

# Export all resources
oc get all -o yaml > backup.yaml

# Get pod resource usage
oc adm top pods --containers
```

---

## 📚 Useful Links

| Resource | Link |
|---|---|
| OpenShift CLI Reference | [docs.openshift.com/container-platform/latest/cli_reference](https://docs.openshift.com/container-platform/latest/cli_reference/openshift_cli/getting-started-cli.html) |
| oc Command Reference | [docs.openshift.com/cli_reference](https://docs.openshift.com/container-platform/latest/cli_reference/openshift_cli/developer-cli-commands.html) |
| Red Hat Developer | [developers.redhat.com](https://developers.redhat.com/) |
| OpenShift Learning | [learn.openshift.com](https://learn.openshift.com/) |

---

:::tip Pro Tips
- `oc` is a superset of `kubectl` - all kubectl commands work with oc
- Use `oc explain` to understand any resource field
- Use `oc status --suggest` for troubleshooting recommendations
- Add `-o wide` for more details, `-o yaml` for full resource definition
- Use `oc whoami -t | pbcopy` to copy your token to clipboard (macOS)
:::

---

*Last updated: February 2026*