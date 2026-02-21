---
title: Cloud Infrastructure
sidebar_position: 3
---

# Cloud Infrastructure

## Overview

Cloud infrastructure means renting compute, storage, and networking from providers like AWS, Azure, and GCP. Pay for what you use, scale instantly, minimal operational burden.

**Who uses it:** Amazon, Google, Meta, Netflix, Uber, Microsoft, most startups and modern tech companies

**Why tech companies prefer cloud:**
- **Elasticity:** Scale from 1 to 1 million users instantly
- **No capex required:** Pay-as-you-go model
- **Global reach:** Data centers in 30+ regions worldwide
- **Innovation:** New features released constantly
- **Operational simplicity:** Provider handles infrastructure

---

## Cloud Providers: AWS, Azure, GCP

### Market Share & Scale (2024)

| Provider | Market Share | Annual Revenue | Est. Infrastructure Spend |
|:---------|:------------|:---------------|:-------------------------|
| **AWS** | 32% | $92B | Major player, 30+ regions |
| **Azure** | 23% | $71B | Growing, 60+ regions |
| **GCP** | 11% | $33B | Specialized in data/ML |
| **Others** | 34% | Various | Alibaba, Oracle, IBM, etc |

### AWS: The Market Leader

**Annual cost for typical enterprise customer on AWS:**

| Workload Size | Monthly Cost | Annual Cost |
|:-------------|:------------|:-----------|
| **Startup** (1-10 servers worth) | $5K - 20K | $60K - $240K |
| **Scaleup** (100 servers worth) | $100K - 500K | $1.2M - $6M |
| **Enterprise** (1,000 servers worth) | $1M - 5M | $12M - $60M |
| **Large enterprise** (10,000+ servers) | $10M - 50M+ | $120M - $600M+ |

**Largest AWS customers (estimated annual spend):**

| Company | Est. Annual AWS Cost | Use Cases |
|:--------|:-------------------|:----------|
| **Netflix** | $1.5B | Video streaming, ML, analytics |
| **Airbnb** | $800M | Booking, search, analytics |
| **Zillow** | $600M | Real estate search, maps |
| **Adobe** | $750M | Cloud services, SaaS |
| **BMW** | $500M | Manufacturing, connected cars |
| **Expedia** | $450M | Travel booking, search |

**Netflix's AWS Footprint Example:**

Netflix uses AWS exclusively and spends ~$1.5B/year:

```
EC2 (compute):       500M/year
RDS (databases):     300M/year
S3 (storage):        250M/year
DynamoDB/NoSQL:      150M/year
Lambda/serverless:   100M/year
Data transfer:       100M/year
Other services:      100M/year
Total:               ~$1.5B/year
```

For Netflix's scale (200M+ subscribers), this is:
- **$7.50 per subscriber per year** in AWS infrastructure

---

## AWS Service Pricing: Real Examples

### Compute Services (EC2)

| Instance Type | vCPU | Memory | Price/month (on-demand) | Use Case |
|:-------------|:-----|:-------|:----------------------|:---------|
| `t3.micro` | 1 | 1 GB | $10.50 | Dev/test, tiny apps |
| `t3.large` | 2 | 8 GB | $69 | Small production app |
| `m7i.xlarge` | 4 | 16 GB | $180 | General purpose |
| `m7i.2xlarge` | 8 | 32 GB | $360 | Medium workload |
| `c7i.4xlarge` | 16 | 32 GB | $750 | Compute-intensive |
| `r7i.4xlarge` | 16 | 128 GB | $1,050 | Memory-intensive (DB) |

**Annual cost:**
- 1,000 m7i.xlarge servers = **$2.16B/year**
- With reserved instances (3-year, pay upfront) = **$1.35B/year** (37% discount)

### Storage (S3)

| Tier | Price/GB/month | Best For |
|:----|:--------------|:---------|
| **Standard** | $0.023 | Frequently accessed data |
| **Infrequent Access** | $0.0125 | Data accessed &lt; 1x/month |
| **Glacier** | $0.004 | Archive, rarely accessed |
| **Glacier Deep Archive** | $0.00099 | Long-term compliance backup |

**Example: Netflix storing video**

Netflix stores ~5EB (5 million TB) in S3:

```
Cost calculation:
5 million TB × $0.023/GB/month × 12 months
= 5,000,000 TB × 1,000 GB/TB × $0.023 × 12
= 5 billion GB × $0.023 × 12
= ~$1.38B/year just for storage
```

Plus data retrieval, data transfer out = **$1.5B+ annually**

### Database Services

| Service | Monthly Cost (1TB database) | Notes |
|:--------|:---------------------------|:------|
| **RDS (SQL Database)** | $5K - $20K | Multi-AZ high availability |
| **DynamoDB (NoSQL)** | $2K - $10K | Pay by request or provisioned |
| **Redshift (Data warehouse)** | $3K - $15K | Analytics, columnar database |
| **Aurora (High-performance SQL)** | $6K - $25K | MySQL/PostgreSQL compatible |

**JPMorgan on AWS example** (they use AWS for specific workloads):

Estimated AWS spend for risk analytics: $500M - $800M/year

This includes:
- RDS/Aurora for transactional data
- S3 for data lake
- Analytics tools
- Machine learning services

### Networking & Data Transfer

This is often an **underestimated cost:**

| Scenario | Cost |
|:---------|:-----|
| **Data out to internet** | $0.09/GB |
| **Data between regions** | $0.02/GB |
| **CloudFront CDN** | $0.085/GB |
| **VPN/Direct Connect** | $36/month + data charges |

**Real impact:**
- A company transferring 1PB/month to internet = **$90M/year**
- Netflix pays heavily for video delivery despite CloudFront optimization

---

## Azure: Microsoft's Cloud

### Pricing Comparison

Azure is roughly competitive with AWS but has different strengths:

| Service | AWS | Azure | Winner |
|:--------|:----|:------|:-------|
| **General compute (EC2/VMs)** | $180/month (m7i.xlarge) | $200/month (D4s v5) | AWS ✅ |
| **Database (RDS/SQL DB)** | $5-20K/month | $6-22K/month | Tie |
| **Networking egress** | $0.09/GB | $0.087/GB | Azure ✅ |
| **Enterprise agreements** | Standard | 20-40% discounts | Azure ✅ |
| **AI/ML services** | Developing | Very mature (GitHub Copilot, etc) | Azure ✅ |
| **Global regions** | 30 | 60+ | Azure ✅ |

### Large Azure Customers

| Company | Est. Annual Spend | Why Azure |
|:--------|:-----------------|:----------|
| **GitHub (Microsoft)** | $200M+ | Integrated with Microsoft stack |
| **GE Digital** | $300M+ | Hybrid with on-prem systems |
| **Thomson Reuters** | $250M+ | Enterprise SLAs |
| **Enterprise customers** | Various | Microsoft Office 365 integration |

---

## GCP: Google's Cloud

### Strengths

- **Data analytics:** BigQuery is industry-leading
- **Machine learning:** TensorFlow, Vertex AI, most advanced ML services
- **Pricing:** Generally 15-20% cheaper than AWS on compute
- **AI/ML workloads:** Most competitive for this niche

### GCP Pricing (Cheapest for Compute)

| Instance | Monthly Cost | vs AWS |
|:---------|:------------|:-------|
| **4 vCPU, 16GB RAM** | ~$140 | 20% cheaper |
| **32
 vCPU, 128GB RAM** | ~$1,100 | 15% cheaper |
| **Per-second billing** | Yes | AWS per-minute ❌ |

### Large GCP Customers

| Company | Est. Annual Spend | Why GCP |
|:--------|:-----------------|:---------|
| **Spotify** | $200M+ | Data analytics, BigQuery |
| **WhatsApp (Meta)** | $300M+ | Massive scale data processing |
| **The New York Times** | $100M+ | News processing, BigQuery |
| **Twitter (X) early years** | $50M+ | Initially chose GCP |

---

## Cloud Cost Comparison: Same Workload on AWS/Azure/GCP

### Scenario: Web Application with 1,000 Servers

**Compute:**
```
1,000 servers × $180/month (m7i.xlarge on AWS)
= $180,000/month = $2.16B/year

On Azure: $200,000/month = $2.4B/year (+11%)
On GCP: $140,000/month = $1.68B/year (-22%)
```

**Storage (1PB):**
```
AWS S3: 1,000,000 GB × $0.023/GB/month × 12 = $276M/year
Azure Blob: 1,000,000 GB × $0.018/GB/month × 12 = $216M/year (-22%)
GCP Cloud Storage: 1,000,000 GB × $0.020/GB/month × 12 = $240M/year (-13%)
```

**Database (10TB SQL):**
```
AWS RDS: $20K/month × 12 = $240K/year
Azure SQL DB: $22K/month × 12 = $264K/year (+10%)
GCP Cloud SQL: $18K/month × 12 = $216K/year (-10%)
```

**Network egress (100TB/month):**
```
AWS: 100TB × $0.09/GB × 12 = $10.8M/year
Azure: 100TB × $0.087/GB × 12 = $10.44M/year (-3%)
GCP: 100TB × $0.12/GB × 12 = $14.4M/year (-34%)*
*GCP more expensive for egress but cheaper overall
```

**Total Annual Cost:**
- **AWS: $2.46B/year**
- **Azure: $2.63B/year** (+7%)
- **GCP: $1.93B/year** (-22%)

---

## Cloud Advantages & Disadvantages

### Advantages ✅

| Advantage | Impact |
|:----------|:--------|
| **Zero capex** | Start small, pay only what you use |
| **Global instant deployment** | Launch in any region in seconds |
| **Infinite scalability** | No planning for capacity |
| **Managed services** | Database, search, analytics handled for you |
| **Innovation** | New services released weekly |
| **Disaster recovery built-in** | Automatic replication across zones |
| **No staffing needed** | 10 people can run what needs 100 on-prem |

### Disadvantages ❌

| Disadvantage | Impact |
|:-----------|:--------|
| **Network egress costs** | Unexpected data transfer bills |
| **Lock-in risk** | Hard to switch providers once committed |
| **Less control** | Can't customize hardware/kernel level |
| **Latency** | Adds 5-50ms vs on-prem control |
| **Compliance concerns** | Data may live outside your DC |
| **Cost at scale** | Once very large, cloud becomes expensive |
| **Noisy neighbor problem** | Shared infrastructure, performance varies |

---

## Hybrid Cloud: Best of Both Worlds

Most large organizations now use **hybrid:**

```
Cloud: New applications, Dev/test, analytics
On-prem: Legacy systems, high-security data, core trading
```

**Example adoption:**
- **Goldman Sachs:** 70% on-prem, 30% cloud (and growing)
- **JPMorgan:** 60% on-prem, 40% cloud (growing rapidly)
- **Google:** 100% cloud (they built it)
- **Microsoft:** 100% cloud (except legacy sales systems)

---

## Key Takeaways

1. **AWS is still the leader** but Azure/GCP competitive
2. **At scale (10,000+ servers), costs are 15-22% cheaper on GCP**
3. **On-prem and cloud costs nearly identical at JPMorgan scale**
4. **Cloud wins on flexibility, on-prem on control**
5. **Hybrid is the realistic target for most enterprises**
6. **Data transfer costs are often underestimated**
7. **Reserved instances save 30-40% for predictable workloads**
