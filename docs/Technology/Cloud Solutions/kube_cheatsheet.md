---
title: Kubernetes Cheatsheet 
sidebar_position: 2
displayed_sidebar: technologySidebar
tags:
  - kubernetes
  - kubectl
  - devops
  - cheatsheet
  - containers
---

# Kubernetes Cheatsheet

Quick reference for commonly used kubectl commands. Keep this handy!

---

## 🔧 Cluster Info & Context

```bash
kubectl cluster-info                      # Display cluster endpoint and services
kubectl config view                       # Show kubeconfig settings
kubectl config current-context            # Show current context
kubectl config get-contexts               # List all contexts
kubectl config use-context <context>      # Switch to another context
kubectl get nodes                         # List all nodes in the cluster
kubectl describe node <node-name>         # Detailed info about a node
```

---

## 📦 Pods

```bash
kubectl get pods                          # List pods in current namespace
kubectl get pods -A                       # List pods in ALL namespaces
kubectl get pods -o wide                  # List pods with more details (IP, node)
kubectl get pods -w                       # Watch pods in real-time
kubectl describe pod <pod-name>           # Detailed info about a pod
kubectl logs <pod-name>                   # View pod logs
kubectl logs -f <pod-name>                # Stream pod logs (follow)
kubectl logs <pod-name> -c <container>    # Logs from specific container
kubectl logs --previous <pod-name>        # Logs from previous crashed container
kubectl exec -it <pod-name> -- /bin/sh    # Shell into a pod
kubectl exec -it <pod-name> -- bash       # Bash into a pod
kubectl delete pod <pod-name>             # Delete a pod
kubectl run nginx --image=nginx           # Quick run a pod
kubectl port-forward <pod> 8080:80        # Forward local port to pod
```

---

## 🚀 Deployments

```bash
kubectl get deployments                   # List deployments
kubectl describe deployment <name>        # Detailed deployment info
kubectl create deployment <name> --image=<image>  # Create deployment
kubectl scale deployment <name> --replicas=3      # Scale replicas
kubectl rollout status deployment/<name>          # Check rollout status
kubectl rollout history deployment/<name>         # View rollout history
kubectl rollout undo deployment/<name>            # Rollback to previous version
kubectl rollout restart deployment/<name>         # Restart deployment (rolling)
kubectl set image deployment/<name> <container>=<image>  # Update image
kubectl delete deployment <name>          # Delete deployment
```

---

## 🌐 Services & Networking

```bash
kubectl get svc                           # List services
kubectl get svc -A                        # List services in all namespaces
kubectl describe svc <service-name>       # Detailed service info
kubectl expose deployment <name> --port=80 --type=LoadBalancer  # Expose deployment
kubectl get endpoints                     # List endpoints
kubectl get ingress                       # List ingress resources
kubectl describe ingress <name>           # Detailed ingress info
```

---

## 📁 Namespaces

```bash
kubectl get namespaces                    # List all namespaces
kubectl create namespace <name>           # Create namespace
kubectl delete namespace <name>           # Delete namespace (and all resources!)
kubectl config set-context --current --namespace=<ns>  # Set default namespace
kubectl get all -n <namespace>            # Get all resources in namespace
```

---

## 🔐 Secrets & ConfigMaps

```bash
kubectl get secrets                       # List secrets
kubectl get configmaps                    # List configmaps
kubectl describe secret <name>            # Describe secret (values hidden)
kubectl get secret <name> -o yaml         # View secret in yaml (base64 encoded)
kubectl create secret generic <name> --from-literal=key=value  # Create secret
kubectl create configmap <name> --from-file=<path>   # Create configmap from file
kubectl delete secret <name>              # Delete secret
```

---

## 💾 Persistent Storage

```bash
kubectl get pv                            # List persistent volumes
kubectl get pvc                           # List persistent volume claims
kubectl describe pv <name>                # Describe persistent volume
kubectl describe pvc <name>               # Describe PVC
kubectl delete pvc <name>                 # Delete PVC
```

---

## 📋 Apply & Create Resources

```bash
kubectl apply -f <file.yaml>              # Apply/create resources from file
kubectl apply -f <directory>/             # Apply all yamls in directory
kubectl create -f <file.yaml>             # Create resource (fails if exists)
kubectl delete -f <file.yaml>             # Delete resources defined in file
kubectl diff -f <file.yaml>               # Preview changes before apply
kubectl apply -k <directory>/             # Apply with Kustomize
```

---

## 🔍 Debug & Troubleshoot

```bash
kubectl get events                        # List cluster events
kubectl get events --sort-by=.metadata.creationTimestamp  # Events sorted by time
kubectl top nodes                         # Resource usage of nodes
kubectl top pods                          # Resource usage of pods
kubectl describe <resource> <name>        # Debug any resource
kubectl get pod <name> -o yaml            # Full YAML of running pod
kubectl explain <resource>                # Explain resource fields
kubectl explain pod.spec.containers       # Explain specific field
kubectl api-resources                     # List all API resources
kubectl auth can-i create pods            # Check permissions
```

---

## 🏷️ Labels & Selectors

```bash
kubectl get pods --show-labels            # Show labels on pods
kubectl get pods -l app=nginx             # Filter by label
kubectl get pods -l 'env in (prod,dev)'   # Filter with set-based selector
kubectl label pod <pod> env=prod          # Add label to pod
kubectl label pod <pod> env-               # Remove label from pod
kubectl annotate pod <pod> desc="my pod"  # Add annotation
```

---

## 📊 Output Formats

```bash
kubectl get pods -o wide                  # Wide output with extra columns
kubectl get pods -o yaml                  # Output as YAML
kubectl get pods -o json                  # Output as JSON
kubectl get pods -o name                  # Output only names
kubectl get pods -o jsonpath='{.items[*].metadata.name}'  # JSONPath query
kubectl get pods --sort-by=.metadata.name # Sort output
```

---

## 🛠️ Useful One-Liners

```bash
# Delete all pods in a namespace
kubectl delete pods --all -n <namespace>

# Get all images running in cluster
kubectl get pods -A -o jsonpath="{.items[*].spec.containers[*].image}" | tr -s ' ' '\n' | sort | uniq

# Find pods not running
kubectl get pods -A --field-selector=status.phase!=Running

# Copy file to/from pod
kubectl cp <pod>:/path/to/file ./local-file
kubectl cp ./local-file <pod>:/path/to/file

# Run temporary debug pod
kubectl run debug --rm -it --image=busybox -- sh

# Drain node for maintenance
kubectl drain <node> --ignore-daemonsets --delete-emptydir-data

# Uncordon node after maintenance
kubectl uncordon <node>
```

---

## 📚 Useful Links

| Resource | Link |
|----------|------|
| Official Kubectl Cheatsheet | [kubernetes.io/docs/reference/kubectl/cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) |
| Kubectl Commands Reference | [kubernetes.io/docs/reference/generated/kubectl/kubectl-commands](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands) |
| Kubernetes API Reference | [kubernetes.io/docs/reference/kubernetes-api](https://kubernetes.io/docs/reference/kubernetes-api/) |
| Interactive K8s Tutorial | [kubernetes.io/docs/tutorials](https://kubernetes.io/docs/tutorials/) |
| YAML Reference | [kubernetes.io/docs/reference](https://kubernetes.io/docs/reference/) |
| Helm Charts | [artifacthub.io](https://artifacthub.io/) |
| K9s Terminal UI | [k9scli.io](https://k9scli.io/) |
| Lens IDE | [k8slens.dev](https://k8slens.dev/) |

---

:::tip Pro Tips
- Use `alias k=kubectl` to save typing
- Set up bash/zsh completion: `source <(kubectl completion bash)`
- Use `-n <namespace>` to avoid switching contexts
- Always use `--dry-run=client -o yaml` to generate YAML templates
:::

---

*Last updated: February 2026*