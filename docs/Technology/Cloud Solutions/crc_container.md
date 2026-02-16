---
title: CodeReady Containers (CRC) Setup Guide
sidebar_position: 3
displayed_sidebar: technologySidebar
tags:
  - kubernetes
  - openshift
  - devops
  - containers
  - setup-guide
  - macos
---

# CodeReady Containers (CRC) Setup Guide for macOS

This document provides a **clear, structured, and simple setup guide** to install and configure CodeReady Containers (CRC) on macOS.

## Scope

This document provides a **clear, structured, and simple setup guide**
to install and configure CodeReady Containers (CRC) on macOS.

It covers: - Installation steps - Configuration recommendations -
Cluster startup process - Basic troubleshooting - Operational commands

This guide is intended for developers, DevOps engineers, and platform
teams who need a **local OpenShift environment** for development and
testing.

------------------------------------------------------------------------

## Purpose

The purpose of CRC is to run a **single-node OpenShift cluster locally**
on your machine.

Typical use cases: - Local OpenShift testing - Kubernetes/OpenShift
learning - Testing container images before pushing to cluster -
Validating Helm charts - Testing CI/CD pipeline changes locally

CRC eliminates the need for: - External OpenShift clusters - Cloud
infrastructure for basic testing - Shared dev cluster dependency

------------------------------------------------------------------------

## System Requirements

Minimum: - macOS 12+ - 8 GB RAM - 35 GB free disk

Recommended: - 16 GB RAM - 60 GB free disk - 4+ CPU cores - Admin access

------------------------------------------------------------------------

## Install Dependencies

Install Homebrew (if not installed):

``` bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install required tools:

``` bash
brew install qemu
brew install podman
```

------------------------------------------------------------------------

## Download CRC and Pull Secret

1.  Visit: https://console.redhat.com/openshift/create/local
2.  Login or create account
3.  Download:
    -   CRC macOS installer (.pkg)
    -   Pull secret (JSON file)

Keep the pull secret safe.

------------------------------------------------------------------------

## Install CRC

Install using GUI or CLI:

``` bash
sudo installer -pkg crc-macos-installer.pkg -target /
```

Verify installation:

``` bash
crc version
```

------------------------------------------------------------------------

## Initial Setup

Run one-time setup:

``` bash
crc setup
```

------------------------------------------------------------------------

## Recommended Configuration

Before starting cluster, configure resources:

``` bash
crc config set memory 12288
crc config set cpus 6
crc config set disk-size 60
```

------------------------------------------------------------------------

## Start the Cluster

``` bash
crc start
```

Provide pull secret when prompted.

------------------------------------------------------------------------

## Access OpenShift Console

After startup, CRC prints: - Console URL - kubeadmin password

Login using: - Username: kubeadmin - Password: printed in terminal

------------------------------------------------------------------------

## Enable oc CLI

``` bash
crc oc-env
```

Run export command shown.

Verify:

``` bash
oc whoami
```

------------------------------------------------------------------------

## Useful Commands

Check status:

``` bash
crc status
```

Stop cluster:

``` bash
crc stop
```

Delete cluster:

``` bash
crc delete
```

------------------------------------------------------------------------

## Troubleshooting Tips

If memory/disk issues occur:

``` bash
crc config set memory 14336
crc config set disk-size 80
crc delete
crc start
```

Reboot Mac if virtualization errors occur.

------------------------------------------------------------------------

## Conclusion

CRC provides a lightweight, local OpenShift cluster ideal for
development, testing, and experimentation without relying on cloud
infrastructure.
