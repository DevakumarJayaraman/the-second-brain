---
title: Complete Tags Reference
sidebar_position: 1
description: Master list of all tags used across the documentation site.
---

# 📑 Complete Tags Reference

This page lists all tags used throughout the documentation for easy reference and organization.

## 🏆 Tag Categories

### **Security & Authentication**
- **authentication** - Login, OAuth, API keys, JWT, etc.
- **security** - General security topics
- **oauth** - OAuth 2.0 implementations
- **jwt** - JSON Web Tokens
- **tls** - TLS/SSL protocols
- **ssl** - SSL certificates
- **https** - HTTPS connections
- **mtls** - Mutual TLS
- **certificates** - Digital certificates and PKI
- **cryptography** - Encryption and cryptographic concepts

### **Cloud & DevOps**
- **cloud** - Cloud computing
- **aws** - Amazon Web Services
- **azure** - Microsoft Azure
- **gcp** - Google Cloud Platform
- **kubernetes** - Kubernetes container orchestration
- **devops** - DevOps practices
- **containers** - Docker and containerization
- **openshift** - Red Hat OpenShift

### **Programming Languages**
- **java** - Java programming
- **python** - Python programming
- **typescript** - TypeScript
- **react** - React library
- **nodejs** - Node.js runtime
- **backend** - Backend development

### **Frontend & Styling**
- **frontend** - Frontend development
- **react** - React library
- **tailwind** - Tailwind CSS
- **css** - Cascading Style Sheets
- **styling** - UI styling
- **ui-programming** - User interface development

### **Operations & Tools**
- **cli** - Command-line interfaces
- **bash** - Bash shell scripting
- **unix** - Unix/Linux commands
- **linux** - Linux operating system
- **mac** - macOS
- **macos** - macOS operating system
- **windows** - Windows operating system
- **terminal** - Terminal/shell commands
- **commands** - System commands
- **cheatsheet** - Quick reference guides

### **Infrastructure & Networking**
- **api** - Application Programming Interfaces
- **rest** - REST architectures
- **microservices** - Microservices architecture
- **networking** - Network concepts

### **Finance & Economics**
- **finance** - Financial topics
- **investment** - Investment guides
- **trading** - Trading concepts
- **derivatives** - Financial derivatives
- **economy** - Economics
- **equities** - Stock market
- **options** - Options trading
- **futures** - Futures trading

### **General & Reference**
- **reference** - Reference material
- **setup-guide** - Setup instructions
- **cheatsheet** - Quick reference guides
- **planning** - Planning and strategy
- **productivity** - Productivity tips
- **general** - General topics
- **technology** - Technology overview

## 📊 Tag Statistics

| Category | Count |
|----------|-------|
| Security & Authentication | 10 |
| Cloud & DevOps | 8 |
| Programming Languages | 6 |
| Frontend & Styling | 6 |
| Operations & Tools | 12 |
| Infrastructure & Networking | 4 |
| Finance & Economics | 8 |
| General & Reference | 7 |
| **Total** | **61** |

## 🎯 How to Use Tags

### Finding Content by Tag
1. Go to **[Browse by Tags](/tags-search)** page
2. Click on any tag to see all pages with that tag
3. Use the search box to filter tags
4. Click on a page card to navigate

### Adding Tags to New Pages

When creating a new documentation page, include relevant tags in the frontmatter:

```markdown
---
title: Your Page Title
sidebar_position: 1
tags:
  - tag1
  - tag2
  - tag3
description: Page description
---
```

**Best practices:**
- Use 3-5 tags per page
- Use lowercase with hyphens (e.g., `ui-programming` not `UI Programming`)
- Reference the [Complete Tags Reference](#tag-categories) above
- Add consistent tags across related pages

### Tag Naming Conventions

- **Specific over general** — Use `kubernetes` instead of just `cloud`
- **Use hyphens for multi-word tags** — `api-design`, not `api design`
- **Singular form preferred** — `certificate` not `certificates`
- **Consistent spelling** — Check this page before inventing new tags!

## 📚 Pages by Tag

### Most Populated Tags

**security** (9 pages)
- API Authentication Techniques
- Certificates - Zero to Hero
- Google OAuth Setup Guide
- Java mTLS Guide
- Cloud Providers Overview
- Kubernetes Cheatsheet
- OpenShift Cheatsheet
- And more...

**kubernetes** (3 pages)
- Kubernetes Cheatsheet
- Kube vs OpenShift
- OpenShift Objects

**devops** (4 pages)
- OpenShift Cheatsheet
- Kubernetes Cheatsheet
- CRC Container
- Cloud Providers Overview

**cheatsheet** (8 pages)
- Kubernetes Cheatsheet
- OpenShift Cheatsheet
- Tailwind CSS Cheatsheet
- Unix Cheatsheet
- Windows Cheatsheet
- macOS Cheatsheet
- And more...

## 🔍 Advanced Tag Usage

### Related Tags

Tags that are often used together:

- **kubernetes + devops + containers** — Container orchestration
- **security + oauth + authentication** — Auth systems
- **api + rest + backend** — API development
- **react + typescript + tailwind** — Modern frontend
- **aws + cloud + devops** — Cloud infrastructure

### Tag Grouping for Navigation

Use these tag combinations to find specialized content:

| Topic | Tags |
|-------|------|
| **API Security** | api, security, oauth, jwt |
| **Kubernetes Setup** | kubernetes, devops, containers, cli |
| **React Development** | react, front end, typescript, tailwind |
| **Cloud Deployment** | cloud, devops, ci-cd, containers |
| **Trading Basics** | trading, derivatives, options, finance |

---

## 💡 Tips for Tag Discovery

1. **Start with a topic** (e.g., "kubernetes") and browse related pages
2. **Use search** to find tags matching your interest
3. **Look at tag counts** — popular tags indicate well-covered topics
4. **Check tag combinations** — find related content across the site
5. **Subscribe to tag updates** (if using RSS or feed readers with tag filters)

---

*Last updated: February 20, 2026*
*For questions or tag suggestions, please contribute to the documentation.*
