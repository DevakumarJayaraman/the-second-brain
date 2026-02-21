---
title: On-Premise Infrastructure
sidebar_position: 2
---

# On-Premise Infrastructure

## Overview

On-premise (on-prem) infrastructure means owning and operating your own data centers. Companies maintain physical servers, networks, storage, cooling systems, security, and staffing.

**Who uses it heavily:** JPMorgan, Goldman Sachs, Morgan Stanley, Bank of America, other major banks

**Why banks chose on-prem:**
- **Security & Control:** Full control over data and systems
- **Compliance:** Meet strict regulatory requirements (SEC, NIST, SOX)
- **Legacy Systems:** Decades-old trading systems too critical to move
- **Latency:** Microseconds matter in trading—on-prem eliminates cloud latency
- **Cost predictability:** Fixed costs, no surprise cloud bills

---

## Architecture Components

### 1. Data Center Infrastructure

```
Physical Building
├── Servers (compute)
├── Storage (SAN, NAS)
├── Networking (switches, routers, firewalls)
├── Cooling systems (CRAC, CRAH)
├── Power systems (generators, UPS, redundant feeds)
└── Security (access control, surveillance, guards)
```

### 2. Geographic Redundancy

Large banks operate 2-5 data centers:

**JPMorgan:**
- Primary DC: New York metro area
- Secondary DC: New Jersey
- Tertiary DC: Regional hub (Chicago, Texas, etc.)
- Disaster recovery: Different geography

**Typical setup:**
- **Active-Active:** Multiple DCs process transactions simultaneously
- **Active-Passive:** Secondary takes over if primary fails
- **Geographic diversity:** Protects against regional disasters

### 3. Network Architecture

```
External Internet
↓
DDoS Protection / WAF Layer
↓
Load Balancers (Active-Active)
↓
API Gateway / Proxy Tier
↓
Application Servers (clustered)
↓
Database Layer (with replication)
↓
Storage Layer (SAN/NAS with redundancy)
```

---

## Cost Structure: JPMorgan Example

**JPMorgan's estimated annual infrastructure spending:** $3-4 billion/year

### Cost Breakdown

| Category | % of Total | Annual Cost | Notes |
|:---------|:----------|:-----------|:-------|
| **Servers & Hardware** | 30% | $900M - $1.2B | Replacement cycles, maintenance |
| **Personnel (IT staff)** | 25% | $750M - $1B | DBAs, sysadmins, network engineers |
| **Real Estate (data centers)** | 15% | $450M - $600M | Building rent, floor space |
| **Networking/Connectivity** | 12% | $360M - $480M | WAN, ISP, DCI (data center interconnect) |
| **Cooling/Power** | 10% | $300M - $400M | Electricity, AC systems |
| **Software licenses** | 5% | $150M - $200M | OS, databases, middleware |
| **Disaster recovery/backup** | 3% | $90M - $120M | Backup systems, offsite storage |

### Cost Per Transaction

JPMorgan processes ~**2 million transactions per minute** during peak hours.

**Infrastructure cost per transaction:** ~$0.00001 - $0.0002 (1-20 millionths of a dollar)

For a $100M trade, infrastructure cost is roughly **$1-20** in infrastructure per transaction.

---

## Complete Inventory: Major Bank On-Prem Infrastructure

### Hardware Components

| Component | Quantity (JPMorgan est) | Purpose | Cost |
|:----------|:----------------------|:--------|:-----|
| **High-end servers** | 50,000+ | Processing, databases, caching | $500K - $2M each |
| **Storage arrays (SAN)** | 200+ | Database storage, backups | $500K - $5M per system |
| **Network switches** | 1,000+ | Network connectivity | $100K - $1M per switch |
| **Firewalls/security** | 500+ | Network security, DDoS protection | $100K - $500K per unit |
| **Load balancers** | 300+ | Traffic distribution | $100K - $500K per unit |

### Software & Platforms

- **Operating Systems:** Red Hat, Windows Server, Unix/Linux
- **Databases:** Oracle (expensive but critical), SQL Server, Sybase, in-house systems
- **Middleware:** WebLogic, WebSphere, Tibco, custom trading platforms
- **Monitoring:** Splunk, Datadog, New Relic equivalents
- **Version control & CI/CD:** Jenkins, Git, proprietary systems

### Staffing Model

For JPMorgan's infrastructure:

| Role | Count (est) | Annual cost |
|:-----|:-----------|:-----------|
| Database Administrators (DBA) | 500 | $80M |
| System Administrators | 800 | $100M |
| Network Engineers | 400 | $60M |
| Security Engineers | 300 | $50M |
| Infrastructure architects | 200 | $40M |
| **Total IT staff** | **15,000+** | **$2B+** |

Note: JPMorgan employs ~15,000 technology staff total, with ~6,000-7,000 in infrastructure/operations.

---

## On-Prem vs Cloud: Cost Comparison

### For JPMorgan's Trading Infrastructure

Assume: 50,000 servers, 2PB storage, 10Gbps+ networking

**On-Premise Annual Cost:**
- Hardware depreciation: $1.2B (5-year lifecycle)
- Personnel: $800M
- Facilities: $600M
- Power/cooling: $400M
- Networking: $300M
- **Total:** **~$3.3B annually**

**Cost per server:** ~$66,000/year

**Equivalent Cloud Cost (AWS estimate):**
- Compute (50,000 x m7i.xlarge): ~$2.2B/year
- Storage (2PB): ~$50M/year
- Networking & data transfer: ~$400M/year
- Premium for SLA/redundancy: +30% = $780M
- **Total:** **~$3.4B annually**

**Result:** Almost identical cost. On-prem slightly cheaper due to:
- Bulk hardware purchases
- Leveraging existing facilities
- Full depreciation of older systems

But cloud provides:
- Flexibility (add/remove resources in minutes)
- No capex upfront required
- Less operational burden

---

## On-Prem Advantages & Disadvantages

### Advantages ✅

| Advantage | Example |
|:----------|:--------|
| **Lowest marginal cost at scale** | After billions invested, adding servers is cheap |
| **Complete data control** | Meets regulatory requirements |
| **Latency optimization** | Microsecond-level control |
| **Customization** | Build exactly what you need |
| **Long-term cost predictability** | Fixed costs, no surprise bills |
| **Leverage existing investments** | Amortized over 20+ year buildings |

### Disadvantages ❌

| Disadvantage | Impact |
|:-----------|:--------|
| **High upfront capex** | Billions required before service starts |
| **Inflexibility** | Adding capacity takes months of planning |
| **Operational complexity** | Requires expert teams, vendor management |
| **Staffing burden** | 6,000-7,000 people needed just for infrastructure |
| **Innovation slower** | Custom systems take years to build |
| **Disaster recovery costs** | Maintaining 2-3 full DCs is expensive |
| **Technology obsolescence** | Servers become obsolete faster than lifespan |

---

## Real Example: Goldman Sachs Infrastructure

Goldman Sachs, like JPMorgan, maintains extensive on-prem infrastructure:

### Estimated Setup

- **Primary data center:** New York metro
- **Backup locations:** 2-3 additional data centers
- **Network:** Proprietary mega-network for trading
- **Estimated spend:** $2.5-3.5B annually

### Why Goldman Didn't Go Full Cloud

1. **Legacy trading systems:** Decades-old systems critical to revenue
2. **Regulatory:** SEC/CFTC compliance easier with controlled infrastructure
3. **Latency:** Microsecond advantage is worth billions in trading
4. **Market resilience:** Financial crisis taught them: control your infrastructure

---

## Modern On-Prem: Hybrid Approach

Even JPMorgan and Goldman now operate **hybrid:**

- **Core trading systems:** On-prem only
- **Risk management:** On-prem primary, cloud backup
- **Data analytics:** Mix of on-prem and cloud
- **New applications:** Cloud-first approach
- **Disaster recovery:** May use cloud for DR

---

## Key Takeaways

1. **On-prem is still dominant in finance** for good reasons (control, latency, compliance)
2. **Cost isn't the main driver**—control and security are
3. **Hybrid is the future**—not pure on-prem or pure cloud
4. **Staffing is hidden cost**—6,000+ people needed
5. **Long-term commitment**—can't easily exit
