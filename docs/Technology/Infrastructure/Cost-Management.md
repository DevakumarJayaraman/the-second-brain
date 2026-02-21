---
title: Infrastructure Cost Management
sidebar_position: 5
---

# Infrastructure Cost Management

## Overview

Infrastructure is often the largest controllable expense in tech and finance. For JPMorgan, Goldman Sachs, Google, or Amazon, a 5% infrastructure cost reduction = hundreds of millions in savings.

This guide covers how enterprises manage and optimize infrastructure costs.

---

## The Cost Management Framework

### Strategy Layer
```
Understand costs → Set targets → Optimize allocation
```

### Governance Layer
```
Chargeback → Accountability → Behavioral change
```

### Operations Layer
```
Reserved instances → Auto-scaling → Consolidation
```

### Culture Layer
```
Engineering incentives → Cost awareness → Shared ownership
```

---

## Part 1: Understanding Your Infrastructure Costs

### Cost Attribution Model

Who pays for what?

**Traditional (No accountability):**
```
Total cost: $3B
Allocated: To executive leadership only
Result: No incentive to optimize
```

**Modern (Full chargeback):**
```
Trading desk A: $500M
Trading desk B: $400M
Risk management: $300M
Operations: $200M
Support functions: $100M
Analytics: $150M
New initiatives: $350M
Total: $2B on-prem + $1B cloud
```

**Benefits of transparency:**
- Engineers see the cost of their choices
- Desks compete on efficiency
- Infrastructure becomes strategic, not just utility

### Cost Categories

**Total Infrastructure Cost = Fixed + Variable + Overhead**

#### Fixed Costs (70-80% on-prem, 0% cloud)

| Cost | Annual | Notes |
|:-----|:-------|:-------|
| **Real estate (buildings)** | $600M | Data center floor space |
| **Salaries (permanent staff)** | $800M | DBAs, sysadmins, architects |
| **Depreciation (servers)** | $1.2B | Amortized over 5-7 years |
| **Contracts (major vendors)** | $200M | Oracle, Cisco, Microsoft licenses |

**JPMorgan on-prem fixed costs: ~$2.8B/year** (hard to change in &lt;1 year)

#### Variable Costs (30-50% on-prem, high in cloud)

| Cost | Variability | Notes |
|:-----|:-----------|:-------|
| **Power/cooling** | +10-20% per server | $300 per server per year |
| **Data transfer** | ±30% | Depends on business volume |
| **Cloud services** | ±40% | Scales with usage |
| **Staffing (contractors)** | ±50% | Added for projects |

#### Overhead (10-15%)

- Management & processes
- Tools & monitoring
- Insurance & compliance
- Facilities management

**Total flexibility: ~30-40% of infrastructure costs** (rest is locked in)

---

## Part 2: Cost Optimization Techniques

### Technique 1: Reserved Instances (Cloud)

**Reserve capacity ahead, get discount:**

```
AWS EC2 m7i.xlarge pricing:

On-demand (pay as you go):
  Month 1: $180
  Month 2: $180
  ... (12 months)
  Year 1 total: $2,160

1-year reserved:
  Upfront: $1,300
  Monthly: $0
  Year 1 total: $1,300
  SAVINGS: $860 (40%)

3-year reserved:
  Upfront: $1,650
  Monthly: $0
  Year 1 total: $1,650 (first year)
  Year 2 total: $1,650
  Year 3 total: $1,650
  3-year total: $4,950
  vs On-demand 3-year: $7,776
  SAVINGS: $2,826 (36%)
```

**For enterprise scale:**

1,000 servers × $2,160/year on-demand = $2.16B/year

With 3-year reserved instances = **$1.38B/year** (36% savings = $780M/year)

**Gotcha:** Requires forecasting. If you overestimate, you're stuck.

**Best practice:** Reserve 70% baseline, on-demand for spikes

### Technique 2: Spot Instances (70% discount in AWS)

Use "spare capacity" at huge discount, but AWS can revoke it:

```
m7i.xlarge:
  On-demand: $180/month
  Spot: $50/month
  Savings: 72%
```

**Use cases:**
- Batch analytics jobs (fault-tolerant)
- Machine learning training (can retry)
- Dev/test environments
- NOT suitable for: Trading systems, core databases

**Example:**
```
Netflix uses ~20% spot instances
On 500,000 total compute instances:
  100,000 instances spot @ $50/month = $5M/month
  400,000 instances on-demand @ $180/month = $72M/month
  Total compute: $77M/month

Without spot (all on-demand): $90M/month
Savings: $13M/month = $156M/year (17% total savings)
```

### Technique 3: Consolidation & Rightsizing

**Problem Example:**
```
Dev VM running 24/7:
  2 vCPU, 8 GB RAM
  Cost: $69/month
  
Actual usage:
  Business hours only
  Peak: 1 vCPU, 4 GB RAM needed
  
Solution:
  Downsize to t3.medium: $25/month
  Auto-stop outside 9AM-5PM: -80% (only pay $5/month)
  Annual savings per server: $768
  
For 100 such servers: $76,800/year
For 1,000 such servers: $768,000/year
```

**Common rightsizing wins:**

| Issue | Typical Waste | Fix | Savings |
|:-----|:------------|:----|:--------|
| **Over-provisioned dev/test** | 50% + capacity | Right-size | 30-50% |
| **Unused/idle servers** | 100% waste | Delete/archive | 5-10% of total |
| **Wrong instance type** | 20-40% waste | Better matching | 10-20% |
| **Always-on when not needed** | 60-80% waste | Auto-shutdown | 30-50% |

**JPMorgan example:**

In 2020, consolidated 10,000 idle servers:
- Servers: 10,000 × $15K/year capex (~$150M)
- Personnel: 50 people needed to maintain (~$10M)
- **Total savings: ~$160M**

### Technique 4: Data Transfer Optimization

**Problem:**
```
Data egress (out of cloud): $0.09/GB

Netflix transferring 1PB/month to users:
1,000,000 GB × $0.09 = $90M/month = $1.08B/year
```

**Solution 1: Use CDN (Content Delivery Network)**
```
CloudFront (AWS CDN): $0.085/GB (slight savings)
BUT: Massively faster delivery, better user experience
→ More important than the 5% cost saving
```

**Solution 2: Compress data**
```
Example: Video metadata download

Original: 100GB/day = $9M/year
Compressed (gzip): 95% reduction = 5GB/day = $450K/year
Savings: $8.55M/year

Cost to implement compression: ~$100K engineering
ROI: 200x in first year
```

**Solution 3: Keep data in cloud**
```
Don't download to on-prem for analysis
Instead: Analyze in cloud (expensive compute, cheap data access)
Example: Using AWS S3 with Athena (SQL on S3)
  vs downloading to on-prem (=$1B+ data transfer)
```

**Global cloud providers' data transfer optimization:**

| Company | Monthly data out | Strategy |
|:--------|:-----------------|:---------|
| **Netflix (1.5B users)** | ~5PB | CDN + compression + streaming tech |
| **YouTube/Google** | ~10PB+ | Own backbone + peering deals |
| **Meta/Facebook** | ~15PB+ | Direct connections to ISPs |
| **AWS customers** | Aggregate 100PB+ | CloudFront + optimization incentives |

### Technique 5: Auto-Scaling

**Benefit:**
```
Pay only for what you use
```

**Example: E-commerce infrastructure**

```
Black Friday traffic: 500,000 simultaneous users
Regular traffic: 10,000 simultaneous users

Without auto-scaling:
  Size infrastructure for 500K
  Cost: $5M/year
  Utilization: 95% idle most of year

With auto-scaling:
  Normal load: 50 servers = $100K/month
  Black Friday: 1,000 servers = $2M for 3 days
  Average: $100K/month × 11 months + $2M × 1 month = $1.2M/year
  Savings: $3.8M/year (76%)
```

**Technology:**
- **Kubernetes:** Auto-scales applications across clusters
- **AWS ASG:** Auto Scaling Groups scale EC2 instances
- **Azure VMSS:** Virtual Machine Scale Sets
- **Spot fleet:** Auto-scale across spot + on-demand

---

## Part 3: FinOps (Financial Operations) Framework

Modern approach to managing cloud costs: **FinOps**

### FinOps Pillars

1. **Awareness:** Everyone understands cloud costs
2. **Optimization:** Active cost reduction
3. **Accountability:** Chargeback to business units

### FinOps Team Structure

```
CFO (budget owner)
└── Cloud Financial Officer / FinOps lead
    ├── Cloud architects (optimization)
    ├── Engineers (implementation)
    └── Finance (tracking)
```

### FinOps Tools

| Tool | Function | Cost |
|:-----|:---------|:-----|
| **CloudHealth** | AWS cost analysis | $10K-50K/year |
| **Flexera** | Multi-cloud cost mgmt | $50K-200K/year |
| **Apptio** | Cloud ROI analysis | $100K-500K/year |
| **Cast AI** | Kubernetes optimization | $5K-100K/year |
| **CloudZero** | Unit economics (cost per feature) | $20K-100K/year |
| **Kubecost** | Kubernetes cost tracking | Free-$50K/year |

### Example: JPMorgan FinOps Approach

**Goal:** Reduce cloud spend 15% while improving performance

**Process:**

1. **Month 1: Awareness**
   - audit all cloud resources
   - Find idle resources, underutilized servers
   - Findings: $200M wasted annually

2. **Month 2: Quick wins**
   - Kill idle instances: $50M
   - Right-size: $75M
   - Reserved instances: $40M
   - Delete unused snapshots/backups: $15M
   - Subtotal: $180M (90% of waste)

3. **Month 3-6: Medium-term optimization**
   - Auto-scaling implementation: $20M additional
   - Data transfer optimization: $10M additional
   - Consolidation: $5M additional
   - Subtotal: $35M

4. **Month 6+: Continuous improvement**
   - Quarterly reviews: -5% annually
   - Engineering incentives: drives behavior change
   - Chargeback: departments control their costs

**Total savings: $200M+** (in cloud portion only)

---

## Part 4: Cost vs Performance Trade-off

### The Optimization Question

**Always ask:**
```
Am I saving money or just making things slower/riskier?
```

### Bad Optimization Examples ❌

| Mistake | Cost Saved | Performance Lost |
|:--------|:----------|:-----------------|
| **Delete all backups** | $50M | System can't recover from disaster |
| **Use cheapest servers** | 20% | 50% slower, higher error rates |
| **Minimize redundancy** | 30% | Single point of failure |
| **Reduce monitoring** | $5M | Can't detect issues until they're critical |

### Good Optimization Examples ✅

| Move | Cost Saved | Benefit |
|:-----|:----------|:--------|
| **Consolidate to power-efficient servers** | 15% | Same performance, lower power |
| **Use cloud for analytics instead of on-prem** | 20% | Faster insights, real-time analysis |
| **Compress data in flight** | 30% + lower latency | Faster + cheaper |
| **Delete truly unused resources** | 5-10% | Cleaner, easier to manage |

---

## Part 5: Industry Benchmarks

### How much should infrastructure cost?

**On-premise (CapEx + OpEx):**

| Industry | % of Revenue | Notes |
|:---------|:-----------|:------|
| **Tech (high infrastructure)** | 8-15% | Amazon, Google, Meta |
| **Banking (on-prem heavy)** | 2-4% | JPMorgan, Goldman, Citi |
| **Fintech (cloud-first)** | 3-8% | Robinhood, Stripe, Square |
| **IT Services** | 4-8% | Accenture, Deloitte |
| **Retail** | 0.5-1.5% | Walmart, Target |

**Example:**
```
JPMorgan revenue: $120B/year
Infrastructure spend: $3.3B/year
Percentage: 2.75% (on lower end)

Google revenue: $282B/year
Infrastructure spend: $15-20B/year (estimated)
Percentage: 5-7% (higher, but also data center heavy)
```

### Cost Per User (SaaS)

| Service | Annual Cost per User | Infrastructure % |
|:--------|:-------------------|:-----------------|
| **Slack** | $80-120 (per user estimated) | ~15% (~$12-18) |
| **Salesforce** | $165 (per user) | ~20% (~$33) |
| **Zoom** | $120-220 per user | ~8-10% (~$10-20) |
| **Spotify** | ~$10 per user per year* | ~15% (~$1.50) |

*Free users subsidized by paid users (12:1 ratio), so true cost higher

---

## Part 6: Cost Optimization Roadmap (12 Months)

### Q1: Assessment & Quick Wins (30% savings from waste)

**Months 1-3:**
- Audit all infrastructure
- Find idle resources
- Identify misconfigurations
- Expected savings: 10-15% of cloud spend

**Actions:**
- Delete unused resources
- Turn off dev/test on weekends
- Consolidate databases
- Eliminate duplicate systems

### Q2: Structural Changes (20% additional savings)

**Months 4-6:**
- Implement reserved instances
- Auto-scaling for variable loads
- Data transfer optimization
- Expected savings: Additional 5-10%

**Actions:**
- Purchase 1-year reserved instances for baseline
- Set up auto-scaling policies
- Implement compression
- Analyze data flows

### Q3: Architectural Optimization (15% additional savings)

**Months 7-9:**
- Redesign inefficient systems
- Migrate to more cost-efficient architectures
- Consolidate tools/platforms
- Expected savings: Additional 3-8%

**Actions:**
- Rebuild expensive components
- Consolidate databases
- Reduce observability tool spending

### Q4: Continuous Optimization (5% additional savings)

**Months 10-12:**
- Establish FinOps culture
- Implement chargeback
- Create incentives for cost-conscious engineering
- Expected savings: Ongoing 1-3%/quarter

---

## Part 7: Common Cost Mistakes

### Mistake 1: Not Measuring by Unit Economics

**Bad:** "Our cloud cost is $10M/month"  
**Good:** "Our cloud cost is $0.05 per transaction" or "$1,000 per customer"

**Why?** Business scales, infrastructure should scale proportionally. Gross cost tells you nothing.

### Mistake 2: Ignoring Data Transfer Costs

Budget example:
```
Compute: $100M (budget: $120M ✓)
Storage: $20M (budget: $25M ✓)
Data transfer: $50M (budget: $10M ✗✗✗)
```

Data transfer often overlooked until bill arrives.

**Fix:** Explicitly budget for data egress in cost models

### Mistake 3: Consolidating Services Too Aggressively

Killed too much redundancy = outages = revenue loss

```
Saved: $10M/year on redundant database
Lost: $500M/day downtime × 1 day = way worse
```

Optimize, don't sacrifice resilience.

### Mistake 4: No Governance = Cost Creep

Everyone launches infrastructure without approval:

```
Year 1: $100M (controlled)
Year 2: $150M (+50%, no one sure why)
Year 3: $200M (+33%, spiraling)
```

**Fix:** Require cost approval for any infrastructure >$100K

### Mistake 5: Treating Cloud as Cheap

Cloud is not cheaper at massive scale, just more flexible.

```
Mistake: "Cloud is cheaper, move everything"
Reality: JPMorgan's on-prem and cloud costs nearly identical
Lesson: Choose based on flexibility needs, not cost
```

---

## Key Takeaways

1. **Infrastructure costs are 30-40% optimizable** without sacrifice
2. **Chargeback incentivizes cost-conscious behavior** more than edicts
3. **Wasted capacity is the biggest opportunity:** Kill unused resources first
4. **Reserved instances: automatic 30-40% savings** for predictable loads
5. **Data transfer costs are often forgotten** in budgets
6. **FinOps tools pay for themselves** within months
7. **Optimization vs performance trade-off is critical**—don't break things to save pennies
8. **Culture change is harder than technical optimization**
