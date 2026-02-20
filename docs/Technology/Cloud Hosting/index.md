---
title: Cloud Hosting
sidebar_position: 3
displayed_sidebar: technologySidebar
tags:
  - cloud
  - hosting
  - devops
  - digitalocean
  - nginx
---

# Cloud Hosting

A practical guide to deploying and hosting web applications in the cloud — from buying your first server to hosting multiple apps with custom subdomains.

---

## 📂 What's Inside

| Guide | What You'll Learn |
|---|---|
| [🛒 Buying Cloud Resources](./buying_cloud_resources.md) | Compare cloud providers from budget to premium; pick the right plan |
| [🌐 Domain Registration](./domain_registration.md) | Register a domain on Namecheap, compare registrars, configure DNS |
| [⚙️ Nginx Setup & Subdomains](./nginx_setup_subdomains.md) | Install Nginx, serve static sites, host multiple apps under `sub.domain.com` |
| [🚀 Auto-Deploy to DigitalOcean](./auto_deploy_digitalocean.md) | GitHub Actions CI/CD pipeline that deploys on every merge to `master` |

---

## 🎯 Goal

By the end of this section you will be able to:

1. **Spin up a cloud server** in minutes (DigitalOcean Droplet, AWS EC2, etc.)
2. **Register a domain** and point it at your server
3. **Host multiple apps** on the same server using Nginx virtual hosts and subdomains
4. **Auto-deploy** your site every time you push to `master`

> 🏠 **Analogy:** Think of a cloud server as renting an apartment building. Nginx is the doorman who directs each visitor to the right apartment (app). Your domain is the building's street address, and subdomains are the apartment numbers.

---

*Last updated: February 2026*
