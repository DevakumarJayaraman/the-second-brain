---
title: OpenShift Objects Reference
sidebar_position: 4
displayed_sidebar: technologySidebar
tags:
  - openshift
  - kubernetes
  - devops
  - reference
---

# OpenShift Objects Reference

Complete list of OpenShift/Kubernetes objects with one-liner explanations.

---

## 🏗️ Workloads

| Object | Short | Description | Analogy |
|--------|-------|-------------|----------|
| **Pod** | `po` | Smallest deployable unit; one or more containers sharing network/storage | A shipping container on a cargo ship |
| **ReplicaSet** | `rs` | Ensures a specified number of pod replicas are running at all times | A manager ensuring minimum staff on shift |
| **Deployment** | `deploy` | Declarative updates for Pods and ReplicaSets with rollback support | A restaurant menu that can be updated anytime |
| **DeploymentConfig** | `dc` | OpenShift-specific deployment with triggers, hooks, and strategies | A smart recipe that cooks itself when ingredients arrive |
| **StatefulSet** | `sts` | Manages stateful apps with stable network IDs and persistent storage | Assigned parking spots with your name on them |
| **DaemonSet** | `ds` | Ensures a pod runs on all (or selected) nodes in the cluster | Security guard at every building entrance |
| **Job** | `job` | Creates pods that run to completion (batch processing) | A one-time task like cleaning the garage |
| **CronJob** | `cj` | Schedules Jobs to run at specified times (like cron) | An alarm clock that triggers a task |
| **ReplicationController** | `rc` | Legacy way to ensure pod replicas (use Deployment instead) | Old flip phone (still works, but outdated) |

---

## 🌐 Networking

| Object | Short | Description | Analogy |
|--------|-------|-------------|----------|
| **Service** | `svc` | Stable network endpoint to access a set of pods | A phone number that always reaches someone |
| **Endpoints** | `ep` | List of IP addresses for pods backing a service | Contact list behind a call center number |
| **Route** | `route` | OpenShift-specific; exposes services externally with hostname | A street address for your business |
| **Ingress** | `ing` | Kubernetes standard for HTTP/HTTPS routing to services | A reception desk directing visitors |
| **NetworkPolicy** | `netpol` | Rules to control pod-to-pod network traffic | Firewall rules like office door access cards |
| **EgressNetworkPolicy** | - | OpenShift-specific; controls outbound traffic from project | Rules about what websites employees can visit |

---

## 💾 Storage

| Object | Short | Description | Analogy |
|--------|-------|-------------|----------|
| **PersistentVolume** | `pv` | Cluster-wide storage resource provisioned by admin | A storage unit in a warehouse |
| **PersistentVolumeClaim** | `pvc` | User's request for storage; binds to a PV | A rental agreement for a storage unit |
| **StorageClass** | `sc` | Defines storage "classes" for dynamic provisioning | Storage tiers: economy, standard, premium |
| **ConfigMap** | `cm` | Stores non-sensitive configuration as key-value pairs | A sticky note with settings |
| **Secret** | `secret` | Stores sensitive data (passwords, tokens) in base64 | A locked safe for passwords |

---

## 🏗️ Builds (OpenShift-specific)

| Object | Short | Description | Analogy |
|--------|-------|-------------|----------|
| **BuildConfig** | `bc` | Defines how to build container images from source | A recipe card for baking a cake |
| **Build** | `build` | A single execution of a BuildConfig | Actually baking the cake once |
| **ImageStream** | `is` | Tracks images by tag; triggers builds/deployments on changes | A photo album that auto-updates |
| **ImageStreamTag** | `istag` | A specific tagged image within an ImageStream | A labeled photo in the album ("vacation-2024") |
| **ImageStreamImage** | - | A specific image by SHA within an ImageStream | A photo identified by its unique fingerprint |

---

## 🔐 Security & Access Control

| Object | Short | Description | Analogy |
|--------|-------|-------------|----------|
| **ServiceAccount** | `sa` | Identity for pods to authenticate with the API | An employee badge for apps |
| **Role** | `role` | Defines permissions within a namespace | Job description listing allowed tasks |
| **ClusterRole** | `clusterrole` | Defines permissions cluster-wide | Company-wide access policy |
| **RoleBinding** | `rolebinding` | Grants Role to users/groups in a namespace | Assigning a job title to a person |
| **ClusterRoleBinding** | `clusterrolebinding` | Grants ClusterRole to users/groups cluster-wide | Giving someone company-wide admin access |
| **SecurityContextConstraints** | `scc` | OpenShift-specific; defines pod security policies | Building security rules (no weapons, ID required) |
| **PodSecurityPolicy** | `psp` | Kubernetes pod security (deprecated in K8s 1.25) | Old security rulebook (being replaced) |

---

## 📁 Namespace & Projects

| Object | Short | Description | Analogy |
|--------|-------|-------------|----------|
| **Namespace** | `ns` | Kubernetes isolation boundary for resources | A separate apartment in a building |
| **Project** | `project` | OpenShift wrapper around namespace with extra metadata | An apartment with a nameplate and mailbox |
| **ResourceQuota** | `quota` | Limits total resource consumption in a namespace | Monthly budget cap for a department |
| **LimitRange** | `limits` | Default/max resource limits for pods in namespace | Min/max salary range for job positions |

---

## 📋 Configuration & Templates

| Object | Short | Description | Analogy |
|--------|-------|-------------|----------|
| **Template** | `template` | OpenShift-specific; parameterized resource definitions | A fill-in-the-blanks form |
| **HorizontalPodAutoscaler** | `hpa` | Auto-scales pods based on CPU/memory or custom metrics | Hiring more cashiers when lines get long |
| **VerticalPodAutoscaler** | `vpa` | Recommends/sets resource requests and limits | Upgrading an employee's desk/computer |
| **PodDisruptionBudget** | `pdb` | Limits voluntary disruptions during maintenance | Minimum staff required during renovations |
| **PriorityClass** | `pc` | Defines scheduling priority for pods | VIP vs regular queue at airport |

---

## 🔄 Operators & CRDs

| Object | Short | Description | Analogy |
|--------|-------|-------------|----------|
| **CustomResourceDefinition** | `crd` | Extends Kubernetes API with custom resources | Adding new words to a dictionary |
| **Operator** | - | Application that manages other applications via CRDs | A robot manager that handles routine tasks |
| **OperatorGroup** | `og` | Defines operator's target namespaces | Manager's jurisdiction (which departments) |
| **Subscription** | `sub` | Subscribes to an operator from a catalog | Subscribing to a magazine |
| **ClusterServiceVersion** | `csv` | Describes an operator version and its requirements | Product spec sheet with version number |
| **CatalogSource** | `catsrc` | Source of operator packages | An app store for operators |
| **InstallPlan** | `ip` | Plan for installing operator resources | Installation checklist |

---

## 🖥️ Cluster & Nodes

| Object | Short | Description | Analogy |
|--------|-------|-------------|----------|
| **Node** | `node` | A worker machine in the cluster | A single computer/server |
| **MachineSet** | `machineset` | Defines and manages a group of machines | A fleet of delivery trucks |
| **Machine** | `machine` | Represents a single machine/node | One truck in the fleet |
| **MachineConfig** | `mc` | Defines node configuration (OS, kubelet, etc.) | Standard specs for all trucks |
| **MachineConfigPool** | `mcp` | Groups nodes for configuration management | Truck categories (small, medium, large) |

---

## 📊 Monitoring & Observability

| Object | Short | Description | Analogy |
|--------|-------|-------------|----------|
| **Event** | `ev` | Records significant occurrences in the cluster | A diary entry of what happened |
| **ServiceMonitor** | `sm` | Defines how Prometheus should scrape metrics | Instructions for a health inspector |
| **PodMonitor** | `pm` | Defines Prometheus scraping for specific pods | Fitness tracker for specific apps |
| **PrometheusRule** | - | Defines alerting and recording rules | "Call me if temperature exceeds 100°F" |
| **AlertManager** | - | Manages alerts from Prometheus | A 911 dispatcher routing emergencies |

---

## 🔧 Other Objects

| Object | Short | Description | Analogy |
|--------|-------|-------------|----------|
| **ComponentStatus** | `cs` | Health status of cluster components | Dashboard showing system health |
| **Lease** | `lease` | Used for leader election and node heartbeats | "I'm still here" check-in system |
| **EndpointSlice** | - | Scalable way to track network endpoints | Phone book split into sections |
| **RuntimeClass** | - | Selects container runtime configuration | Choosing which engine to run containers |
| **MutatingWebhookConfiguration** | - | Modifies objects before persistence | Auto-correct before saving |
| **ValidatingWebhookConfiguration** | - | Validates objects before persistence | Spell-check before saving |

---

## 📊 Quick Reference by Category

```
Workloads:    Pod, Deployment, DeploymentConfig, StatefulSet, DaemonSet, Job, CronJob
Networking:   Service, Route, Ingress, NetworkPolicy
Storage:      PV, PVC, StorageClass, ConfigMap, Secret
Builds:       BuildConfig, Build, ImageStream
Security:     ServiceAccount, Role, RoleBinding, SCC
Scaling:      HPA, VPA, PodDisruptionBudget
Operators:    CRD, Subscription, CSV, CatalogSource
```

---

## 🛠️ Get All Objects Command

```bash
# List all API resources with their short names
oc api-resources

# List resources in a namespace
oc api-resources --namespaced=true

# List cluster-scoped resources
oc api-resources --namespaced=false
```

---

*Last updated: February 2026*