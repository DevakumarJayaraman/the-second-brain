---
title: Server Types Comparison
sidebar_position: 7
---

# Server Types Comparison: Physical, VM, Cloud & Design Trade-offs

**Quick Guide (10 mins)** - Different server architectures used by JPMorgan, Goldman Sachs, Google, Amazon, and what matters for cost and performance.

---

## The Server Spectrum

```
Cost/Control Spectrum:

Physical Servers ──→ Virtualized/Bare Metal ──→ Cloud VMs ──→ Containers
(You own)           (You rent hardware)        (Shared hw)   (Smallest unit)

Physical: $100K upfront, 100% control
Bare metal cloud: $1K/month rental, 100% control
Cloud VM: $100-500/month, shared hardware
Containers: $10-100/month, highly abstracted
```

---

## Server Type 1: Physical Servers

### What It Is
You buy and own the hardware. JPMorgan, Goldman Sachs core systems run here.

### Example Hardware (Enterprise Server)

**Dell PowerEdge R7515 (typical high-end server):**

| Component | Specs | Cost |
|:----------|:------|:-----|
| **Processors** | 2× AMD EPYC 7002 (64 cores each) | $20K |
| **Total cores** | 128 cores (256 with hyperthreading) | |
| **Memory** | 768GB DDR4 | $15K |
| **Storage** | 8× NVMe SSD (7.2TB total) | $5K |
| **Power supply** | 2× 1600W redundant | $2K |
| **Chassis/cooling** | Enterprise-grade | $3K |
| **Network** | 4× 25Gbps NICs | $2K |
| **Total hardware cost** | | **~$47K** |

**Add to total cost:**
- Shipping/installation: $2K
- 5-year maintenance contract: $5K/year = $25K
- Electricity (256W TDP × 5 years × $0.10/kWh): $11K
- Datacenter floor space ($500/sq ft, 2 sq ft): $5K
- **Total 5-year cost per server: ~$90-100K**

### Depreciation & Economics

```
NPV over 5 years:

Purchase: $47K (year 1)
Maintenance: $5K × 5 = $25K
Power: $11K
Space: $5K
Disposal: -$2K (salvage)
──────────────
Total: $86K over 5 years
Annual cost: $17.2K/year
```

### Cost Per Core/Year

```
128 cores × 5 years = 640 core-years
$86K / 640 = $134/core/year

For comparison (we'll get to VMs below):
Cloud VM with 4 cores: ~$200/month = $2,400/year
Per core: $600/year (4.5x more expensive!)
```

### Why Banks Use Physical Servers

✅ **Latency:** On-prem latency less than 1ms (vs cloud 5-20ms)  
✅ **Control:** Full hardware customization  
✅ **Cost at scale:** $134/core-year vs $600/core-year in cloud  
✅ **Compliance:** Keep data on your hardware  
✅ **Predictable performance:** No noisy neighbors  

❌ **Downside:** Need 6,000+ staff to maintain

---

## Server Type 2: Bare Metal Cloud (Rented Physical)

### What It Is
You rent a physical server from cloud provider. AWS, Azure, GCP all offer this.

**AWS Example: `c7i.metal` (Bare Metal Compute)**

| Spec | Value | Cost |
|:-----|:-------|:------|
| **Processor** | Intel Xeon Platinum 8480H | |
| **Cores** | 96 cores | |
| **Memory** | 192 GB DDR5 | |
| **Price (on-demand)** | $3.88/hour = **$2,800/month** | |
| **Price (1-year reserved)** | $1,900/month (32% discount) | |
| **Price (3-year reserved)** | $1,480/month (47% discount) | |

### Cost Comparison to Physical

```
Physical server:
  5-year cost: $86K = $1,437/month (depreciated)

AWS c7i.metal (bare metal cloud):
  On-demand: $2,800/month (95% more expensive)
  Reserved 1-yr: $1,900/month (32% more expensive)
  Reserved 3-yr: $1,480/month (3% more expensive)
```

### When Banks Use Bare Metal

✅ **Short-term scaling:** Don't want to buy hardware  
✅ **New initiatives:** Proof-of-concept infrastructure  
✅ **Disaster recovery:** Backup capacity (rarely used)  
✅ **Geographic expansion:** Test markets  

Goldman Sachs uses ~10-20% bare metal cloud for analytics workloads that don't need microsecond latency.

---

## Server Type 3: Cloud Virtual Machines

### What It Is
Multiple VMs share one physical server. Your VM is just kernel-level isolation.

**AWS EC2 m7i.xlarge (General Purpose VM):**

| Spec | Value | Cost |
|:-----|:-------|:------|
| **Processor** | Intel Xeon (shared) | |
| **vCPU** | 4 cores (from shared physical) | |
| **Memory** | 16 GB | |
| **Price (on-demand)** | $0.251/hour = **$180/month** | |
| **Price (1-year reserved)** | $120/month (33% discount) | |
| **Price (3-year reserved)** | $95/month (47% discount) | |

### How Physical Servers are Split

One physical server (128 cores) is divided among ~30-40 VMs:

```
Physical Server (128 cores, 768GB)
├─ VM 1 (4 cores) - $180/month - Banking app
├─ VM 2 (4 cores) - $180/month - Analytics
├─ VM 3 (8 cores) - $360/month - Databases
├─ VM 4 (2 cores) - $90/month - Caching
├─ ... (30+ VMs total)
└─ VM 30 (4 cores) - $180/month - Testing

Physical server utilization: 85-95%
Provider revenue: $180 × 30 = $5,400/month
This pays for the physical server ($3,500/month) + profit + overhead
```

### Cost Per Core/Month

```
m7i.xlarge: $180/month for 4 vCPU
Per core: $45/month = $540/year (4x more expensive than physical!)
```

### The Sharing Trade-off

| What you lose | Impact |
|:-------------|:--------|
| **Dedicated cores** | 5-15% performance variance (noisy neighbor) |
| **Memory bandwidth** | Shared memory bus |
| **Network latency** | Goes through virtualization layer |
| **Predictability** | Not guaranteed performance |

| What you gain | Impact |
|:------------|:--------|
| **Flexibility** | Scale up/down instantly |
| **No capex** | Don't buy servers |
| **Elasticity** | Pay only for what you use |
| **No maintenance** | Provider handles hardware |

### Who Uses Cloud VMs

✅ **Tech companies** (Google, Meta, Amazon internal apps)  
✅ **Startups** (no money for physical servers)  
✅ **Variable workloads** (scale up during peaks)  
✅ **Dev/test** (don't need production performance)  

❌ **Banks rarely use cloud VMs for core trading** (performance sensitive)

---

## Server Type 4: ECS (Elastic Container Service)

### What It Is
Serverless containers managed by AWS. You containerize your application, and ECS handles resource allocation, scaling, and orchestration. You don't manage VMs directly—you just define container tasks.

**AWS ECS Example: Flask API in Docker container**

| Aspect | Value | Cost |
|:-------|:-------|:-------|
| **Container image size** | 500 MB (Flask app) | |
| **Memory required** | 512 MB per task | |
| **vCPU required** | 0.25 (1/4 of a core) | |
| **Price (on-demand)** | $0.04/hour = **$29/month per task** | |
| **Price (Fargate Spot)** | $0.012/hour = **$9/month per task** | |
| **Auto-scale tasks** | 1-100 depending on load | |

### How ECS Works

```
ECS Cluster Architecture:

┌─────────────────────────────────────┐
│     AWS ECS (You don't see servers) │
├─────────────────────────────────────┤
│ ┌──────────┐ ┌──────────┐ ┌───────┐│
│ │Container1│ │Container2│ │ ...   ││
│ │(Flask)   │ │(Node.js) │ │       ││
│ └──────────┘ └──────────┘ └───────┘│
│                                     │
│ (Underlying EC2/Fargate abstracted) │
└─────────────────────────────────────┘

You specify:
├─ Container image (Docker)
├─ vCPU needed per task
├─ Memory needed per task
└─ Min/max number of tasks

ECS handles:
├─ Finding capacity
├─ Scaling up/down
├─ Load balancing
└─ Task placement
```

### Cost Per Container Task

```
m7i.xlarge VM (4 vCPU, 16GB):
  Cost: $180/month = $45/vCPU/month

ECS task (0.25 vCPU, 512MB):
  Cost: $29/month = $116/vCPU/month
  
Wait, that's more expensive per vCPU!
Why? Abstraction layer overhead + managed service markup
```

### ECS Pricing Model (Fargate)

```
Cost = (vCPU-hours + Memory-GB-hours) × hourly rate

Example: Task runs for 30 days
├─ CPU: 0.25 vCPU × 24 hours × 30 days = 180 vCPU-hours = $0.80
├─ Memory: 0.5 GB × 24 hours × 30 days = 360 GB-hours = $0.04
└─ Total: $0.84/day = $25/month

Plus data transfer, storage, load balancing costs
Total with everything: ~$29-40/month per task
```

### When Banks/Tech Use ECS

✅ **Microservices architecture** (many small tasks)  
✅ **Variable workload** (scale tasks automatically)  
✅ **Stateless applications** (web API, workers)  
✅ **No infrastructure management** (focus on code)  

❌ **Stateful systems** (databases, caches - need persistent storage)  
❌ **Very low latency** (container creation adds 1-2 seconds)  
❌ **Massive throughput** (per-task overhead too high)  

**Who uses it:**
- Netflix microservices
- Uber backend APIs
- Stripe payments
- Most modern tech companies for non-critical services

---

## Physical vs VM: Head-to-Head Comparison

### Cost Comparison: Detailed Breakdown

#### Scenario: Running a Production Application

**Option 1: Physical Server (JPMorgan approach)**

```
1× Dell PowerEdge R7515
├─ Hardware: $47K
├─ OS/License: Linux (free)
├─ Maintenance (5 years): $25K
├─ Power/cooling: $11K
├─ Datacenter space: $5K
├─ Network: $2K
└─ Total 5-year cost: $90K = $18K/year

Specs you get:
├─ 128 cores (64 physical + HT)
├─ 768 GB memory
├─ <1ms latency
├─ 100% dedicated performance
└─ Cost per core-year: $140
```

**Option 2: Cloud VMs (Netflix approach)**

```
30× m7i.xlarge (to match 128 cores total)
├─ Each VM: 4 vCPU, 16 GB memory
├─ Cost per VM: $95/month (reserved 3-year)
├─ Total: 30 × $95 = $2,850/month = $34,200/year
├─ 3-year cost: $102,600
├─ 5-year cost: $204,000 (assuming same rate continues)
└─ Cost per core-year: $540

Specs you get:
├─ 120 total vCPU (30 × 4)
├─ 480 GB total memory (30 × 16 GB)
├─ 5-20ms latency
├─ Shared performance (noisy neighbors)
└─ Instant scaling (add/remove VMs)
```

**Option 3: ECS Containers (Microservices approach)**

```
100× ECS tasks (0.25 vCPU each = 25 vCPU total capacity)
├─ Each task: $9/month (Spot), $29/month (on-demand)
├─ Average load: 50 tasks = $15/month average = $180/year
├─ Peak load: 100 tasks = $29/month = $348/year
├─ Annual average cost: ~$250/year
├─ Much lower than VMs!

But:
├─ Only 25 vCPU capacity (vs 120 for VMs)
├─ Task startup: 1-2 seconds (vs running VM)
├─ Best for bursty, variable load
└─ Not suitable for sustained high compute
```

### Performance Comparison

| Metric | Physical | Cloud VM | ECS |
|:-------|:---------|:---------|:----|
| **Latency** | &lt;1ms | 5-20ms | 50-100ms |
| **Latency consistency** | Guaranteed | 85-95% | 70-80% |
| **Startup time** | Days (install) | 1-2 minutes | 1-2 seconds |
| **Scaling speed** | Months (buy hardware) | 1-3 minutes (launch VM) | 10-30 seconds |
| **Noisy neighbor impact** | None (dedicated) | 5-15% variance | 10-20% variance |
| **Customization** | 100% (you control all) | 50% (OS level) | 10% (container only) |
| **Worst-case CPU steal** | 0% | 5-10% | 10-15% |

### Operational Overhead Comparison

| Task | Physical | Cloud VM | ECS |
|:-----|:---------|:---------|:----|
| **Patching OS** | Your team | Cloud provider | Cloud provider |
| **Hardware replacement** | Your team | Never (provider's job) | Never (provider's job) |
| **Power management** | Your team | Never | Never |
| **Network config** | Your team | Web console | Web console |
| **Monitoring** | Install agents | Pre-integrated | Pre-integrated |
| **Disaster recovery** | Your team | Snapshots/regions | Auto in multi-AZ |
| **Scaling** | Buy more servers | Click button | Auto or click |

### Real Data: Netflix Case Study

Netflix runs **5 billion hours watched per month** entirely on AWS.

**Architecture:**
```
Physical servers: 0% (everything cloud)
VMs (EC2): 85%
Containers (ECS): 12%
Databases (RDS): 3%

Cost breakdown:
├─ EC2 (VMs): $45-50M/month
├─ ECS: $5-8M/month
├─ Storage/Data: $20M/month
├─ Other: $10M/month
└─ Total: ~$90M/month = $1.08B/year
```

**Why Netflix chose this:**
1. Elasticity more important than per-unit cost
2. Need to scale from 1M to 100M users instantly
3. Geographically distributed (need multi-region)
4. Can implement sophisticated caching (reduces server needs)

**If Netflix used physical servers:**
```
Would need 500K servers for peak, only use 100K during off-peak
Capital cost: $24B upfront (vs cloud pay-as-you-go)
Also: 3-month lead time to add capacity (vs instant with cloud)
Missing: Ability to fail over instantly to another region
```

### Real Data: JPMorgan Case Study

JPMorgan runs **$120B annual revenue** with hybrid infrastructure.

**Architecture:**
```
Physical servers: 60%
├─ Core trading systems
├─ Risk/compliance
└─ Legacy systems already paid for

Cloud VMs (AWS): 30%
├─ New applications
├─ Analytics workloads
└─ Disaster recovery

ECS/Containers: 10%
├─ APIs and microservices
├─ New development
└─ Testing environments

Total annual infrastructure: $3.3B
├─ On-prem (physical): $2.0B
├─ Cloud (VM + ECS): $1.3B
```

**Why JPMorgan keeps physical:**
1. Microsecond latency worth billions in trading
2. Decades of investment already amortized
3. Regulatory comfort with owned hardware
4. Trading systems too critical to redesign

**If JPMorgan went 100% cloud:**
1. Cost would be ~$4.2B/year (+27%)
2. Latency would add 10-20ms (loses millisecond advantage)
3. Performance variance unacceptable for trading
4. Regulatory approval challenges
5. Not worth the extra $900M/year in costs

---

## Physical vs VM: Quick Decision Matrix

### Use Physical Servers If:

```
Latency required:              < 1ms ✓
Annual computing hours:        > 40 hours/day ✓
Expected lifespan:             > 4 years ✓
Scale:                         > 500 cores ✓
Performance variance max:      < 5% ✓
```

**Result: Physical is 30-50% cheaper**
**Examples:** JPMorgan trading, Goldman Sachs risk

### Use Cloud VMs If:

```
Latency required:              10-100ms OK ✓
Variable load:                 2-5x variance ✓
Expected lifespan:             < 3 years ✓
Scale:                         100-10,000 cores ✓
Geographic distribution:       Multi-region needed ✓
Staffing:                      No on-prem team ✓
```

**Result: VMs more flexible, similar total cost**
**Examples:** Most SaaS companies, tech startups

### Use ECS/Containers If:

```
Latency:                       100ms+ OK ✓
Workload:                      Bursty, spiky ✓
Scale:                         < 100 cores avg, peaks to 1000 ✓
Design:                        Microservices ✓
Team:                          Cloud-native ✓
Cost:                          Variable per-request ✓
```

**Result: ECS cheapest for variable loads**
**Examples:** Stripe, Uber microservices, modern fintechs

---

## Cost-Benefit Summary Table

For **100 cores of compute, 5-year commitment**:

| Type | Startup | Monthly | 5-Year | Per Core-Year | Best For |
|:-----|:--------|:--------|:-------|:-------------|:---------|
| **Physical** | $50K | $1,437 | $86K | $134 | Sustained, latency-sensitive |
| **Bare Metal Cloud** | $0 | $1,900 | $114K | $149 | Flexibility, short-term |
| **Cloud VM** | $0 | $750 | $45K | $540 | Scaling, variable load |
| **ECS (avg)** | $0 | $200 | $12K | $400 | Bursty, microservices |
| **ECS (peak)** | $0 | $1,000 | $60K | $2,000 | Handles 5x peaks |

**Key insight:** Physical wins on per-core cost, but VMs/ECS win on flexibility and no upfront capex.

---

## Server Type 4: Specialized Server Architectures

### Unix/Linux Physical Servers

**Used by:** JPMorgan, Goldman, Google (their own servers)

```
Typical High-Performance Unix Server:
├─ OS: Linux (Red Hat Enterprise)
├─ CPU: AMD EPYC or Intel Xeon (64+ cores)
├─ Memory: 256-1024 GB
├─ Storage: NVMe SSDs (extreme speed)
├─ Purpose: Databases, analytics, trading systems
└─ Cost: $50-100K
```

**Performance characteristics:**
- **Barebone latency:** Sub-millisecond (essential for trading)
- **Throughput:** 10M+ operations/second
- **Reliability:** 99.99%+ uptime (design for 10+ years)

### Windows Server (Enterprise)

**Used by:** Microsoft, financial institutions with legacy .NET

**AWS EC2 r7i.4xlarge Windows:**

| Metric | Value |
|:-------|:-------|
| **vCPU** | 16 cores |
| **Memory** | 128 GB |
| **Price** | $2.65/hour = **$1,900/month** |
| **License cost** | Embedded (or +$400/month if paying separately) |

**More expensive than Linux** because:
```
Linux m7i.4xlarge: $720/month
Windows r7i.4xlarge: $1,900/month (+164%)
Reason: SQL Server / Outlook / Exchange licensing included
```

### GPU Servers (Machine Learning)

**Used by:** Google (Tensor), Meta (custom silicon), banks (risk calculations)

**AWS p4d.24xlarge (GPU machine):**

| Component | Specs | Cost |
|:----------|:------|:------|
| **GPUs** | 8× NVIDIA H100 GPUs | |
| **vCPU** | 96 cores | |
| **Memory** | 1,152 GB | |
| **Price** | $32.77/hour = **$23,600/month** | |

**Used for:**
- ML model training (expensive, temporary)
- Risk calculations (1000x faster than CPU)
- Real-time predictions

**Economics:**
```
GPU server: $23,600/month (pay only when training)
Run 1 job/week on it: 12 hours/week usage
Effective cost: $23,600 × (12/168) = $1,686/month
Cost per hour: $32.77 (while running)

Alternative: CPU-only equivalent
8 CPU servers: $180 × 8 × 4 weeks = $5,760/month
Much slower (100x), more cores needed
```

---

## Hardware Thread Types Explained

### Physical Cores vs Logical Cores (vCPU)

```
Intel Xeon Platinum (typical trading server):
├─ Physical cores: 32 per socket
├─ Hyperthreading: 2 threads per core
└─ Logical cores: 64 per socket

A single core can run 2 threads simultaneously
Cost: Hyperthreading adds 5-10% cost, but seems "free" to users
Reality: Threads share execution units, slight contention
```

### How vCPU is Allocated in Cloud

```
Physical server: 128 logical cores
Cloud provider allocates:
├─ Per VM: 4 vCPU = 4/128 of physical capacity
├─ But: You share actual hardware with 30+ other VMs
├─ Guarantee: AWS promises 100% vCPU time (their problem if oversold)
└─ Reality: You get ~95% of promised performance, competitors' peaks steal 5%
```

---

## Complete Cost Comparison Table

### For 1,000 Servers Over 5 Years

| Server Type | Unit Cost/Month | 5-Year Total | Per Core-Year |
|:-----------|:----------------|:------------|:-------------|
| **Physical (owned)** | $1,437 (depreciated) | $86M | $134 |
| **Bare metal cloud** | $1,900 (reserved) | $114M | $149 |
| **Cloud VM (m7i.xlarge)** | $95 (reserved) | $5.7M | $540 |
| **Spot VM (m7i.xlarge)** | $30 (spot) | $1.8M | $172 |

**Analysis:**
```
Physical and bare metal cost almost identical at scale
Cloud VM is 4x more expensive per core
But: VM flexibility often justifies the cost
Spot instances nearly match physical for non-critical workloads
```

---

## Design Comparison: CPU/Memory/Threads

### Trading System (Bank) Design

**Requirement:** Process 10M transactions/second with less than 1ms latency

```
Physical Server Choice:
├─ CPU: 32 physical cores (64 with HT)
├─ Memory: 512 GB (in-memory database)
├─ Network: 25Gbps (low latency)
├─ Storage: NVMe SSD (sub-1ms access)
├─ Threading: All 64 threads used (1 thread per transaction type)
└─ Cost: $47K per server, need 50 servers = $2.35M

Why this design?
- Each thread handles 10M/64 = 156K transactions/second
- In-memory DB avoids disk latency
- 512GB memory holds entire order book + history
- Dedicated servers avoid noisy neighbors
```

### Analytics (Tech Company) Design

**Requirement:** Process 1PB data with 10-second query response

```
Cloud VM Choice:
├─ VM type: 100× (4 vCPU, 16GB) cluster
├─ Total: 400 vCPU, 1.6TB memory (distributed)
├─ Storage: S3 (remote, pays per GB)
├─ Threading: Auto-scaled, 1000s of threads across cluster
├─ Cost: $95 × 100 = $9,500/month = $114K/year

Why this design?
- Distributed approach: no single large server
- Scale horizontally (add VMs) vs vertically
- S3 cheaper than local storage ($0.023/GB/month)
- Can stop VMs when query done (save money)
- Flexible: can use 50 VMs or 500 depending on load
```

### Hybrid Design (Modern Bank)

**JPMorgan's real setup:**

```
Core trading (on-prem):
└─ Physical: 64-core servers, 512GB memory, dedicated threads

Risk analytics (cloud):
├─ Cloud VM: m7i.4xlarge (16 vCPU), scales to 100 VMs
├─ Data: Streamed from on-prem (not cached)
├─ Latency acceptable: 100ms+ OK for analytics

Dev/test (cloud):
├─ Cheap VM: t3.medium (2 vCPU), scale down to 0 after hours
├─ Cost: $20/month per VM, can delete instantly
└─ Used: Developers, testing, experiments
```

---

## Quick Decision Framework

**Use Physical Servers if:**
- Latency critical (&lt;1ms required)
- High throughput (10M+ ops/sec)
- Long-term commitment (5+ years)
- Scale is large (1000+ servers)

**Use Bare Metal Cloud if:**
- Need control but don't want to buy
- Uncertain about long-term needs
- Willing to pay 30% more than physical
- Disaster recovery / burst capacity

**Use Cloud VMs if:**
- Variable workload (peak vs. baseline)
- Short-term (dev, testing, prototypes)
- Global distribution needed
- Willing to pay 4x per core

**Use Spot Instances if:**
- Fault-tolerant (can lose the instance)
- Batch processing (ML training, analytics)
- Temporary spikes
- Want 70% discount

---

## Real Example: Netflix Infrastructure

Netflix processes **5 billion hours watched/month** entirely on AWS cloud VMs.

**Netflix setup:**
```
Compute: ~500,000 vCPUs across AWS
├─ Regular VM: m7i.xlarge ($180/month) = 80% of fleet
├─ Spot instances: Same hardware ($50/month) = 15% of fleet
├─ GPU: p3.8xlarge for ML = 5% of fleet
└─ Total monthly: ~$90M for compute alone

Why cloud (not physical)?
- Elasticity: Need 200K vCPU on Friday night, 100K Sunday morning
- Physical would need all 200K all year = 2x cost
- Cloud scales automatically

Netflix could use bare metal for 20% savings
But flexibility worth the premium
```

---

## Key Takeaways (TL;DR)

1. **Physical servers: $134/core-year** (best for permanent, high-performance)
2. **Bare metal cloud: $149/core-year** (physical with flexibility premium)
3. **Cloud VMs: $540/core-year** (4x more, but flexible)
4. **Spot instances: $172/core-year** (near physical cost, fault-tolerant only)
5. **Banks use physical for core systems** (latency + control critical)
6. **Tech companies use cloud VMs** (elasticity more important than cost)
7. **Hybrid is standard now** (physical for core, cloud for everything else)
8. **vCPU isn't "real" core** (you share with 30+ neighbors on shared hardware)
9. **Per-core cost improves with reserved instances** (commit to 1-3 years = 30-47% discount)
