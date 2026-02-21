---
title: Banks vs Tech Companies Infrastructure
sidebar_position: 6
---

# Infrastructure Comparison: Banks vs Tech Companies

## The Great Divergence

Banks and tech companies approach infrastructure completely differently. Same problem (run software at scale), opposite solutions.

---

## Quick Comparison Table

| Aspect | Banks | Tech Companies |
|:-------|:------|:---------------|
| **Location** | 60-70% on-prem | 95%+ cloud |
| **Capital model** | Heavy capex | OpEx/subscription |
| **Control priority** | Maximum | Flexibility |
| **Compliance burden** | 80% of decisions | 10% of decisions |
| **Latency tolerance** | Microseconds matter | Milliseconds OK |
| **Cost driver** | Fixed capacity | Variable consumption |
| **Disaster recovery** | Multiple full DCs | Cloud regions |
| **Staffing model** | 6,000-7,000 per company | 50-200 per major company |

---

## Deep Dive: JPMorgan vs Google

### JPMorgan Chase (Bank)

**Infrastructure Profile:**

| Metric | Value | Notes |
|:-------|:-------|:-------|
| **Annual spend** | $3.3B | Largest in finance |
| **On-premise percentage** | 60% | Core assets controlled |
| **Cloud percentage** | 40% | Growing rapidly |
| **Total servers** | 50,000+ | Across multiple DCs |
| **Data centers** | 5-7 | Geographically distributed |
| **Primary location** | New York metro | Trading, core systems |
| **Redundancy** | Active-active in metros | Millisecond failover |

**Architecture Vision:**

```
On-Premise (60% = $2B/year)
├─ Core trading systems
│  ├─ Equity trading
│  ├─ Fixed income
│  ├─ Derivatives engines
│  └─ Risk management
├─ Payment systems
│  ├─ ACH processing
│  ├─ Wire transfers
│  └─ Card infrastructure
├─ Customer data
│  ├─ Accounts
│  ├─ Transactions
│  └─ Compliance records
└─ Legacy systems
   └─ Decades-old systems too critical to replace

Cloud (40% = $1.3B/year)
├─ New applications (greenfield)
├─ Analytics & big data
├─ Machine learning
├─ Development/testing
├─ Disaster recovery backups
├─ APIs & digital services
└─ Analytics for non-core decisions
```

**Key Characteristics:**

1. **Stability over innovation**
   - Systems run for years without updates
   - Changes tested extensively before deployment
   - Downtime costs millions/minute

2. **Security-first design**
   - Air-gapped networks
   - No internet connection for core systems
   - Complete audit log of every access

3. **Regulatory compliance**
   - Every system in regulated tier
   - Regular capital allocation to compliance tech
   - Stress testing requirements drive redundancy

4. **Latency obsession**
   - Microseconds = money
   - Own private cables between DCs
   - Direct partnerships with exchanges

### Google (Tech Company)

**Infrastructure Profile:**

| Metric | Value | Notes |
|:-------|:-------|:-------|
| **Annual spend** | $15-20B | Estimated (much of own infra) |
| **Cloud percentage** | 100% | All owned cloud |
| **Publicly available capacity** | GCP (Google Cloud Platform) |  |
| **Total servers** | 2,000,000+ | Globally distributed |
| **Data centers** | 30+ | Spread across continents |
| **Primary locations** | Multiple (none special) | Distributed for resilience |
| **Redundancy** | Multi-region automatic** | Transparent autofailover |

**Architecture Vision:**

```
Global Cloud (100%)
├─ Search & Ad delivery
│  ├─ Query processing (distributed)
│  ├─ Ad matching (custom silicon)
│  ├─ Results ranking (ML models)
│  └─ Global cache
├─ YouTube delivery
│  ├─ Video transcoding
│  ├─ Streaming (multi-bitrate)
│  ├─ Recommendation engine
│  └─ CDN distribution
├─ Cloud products (GCP)
│  ├─ Compute Engine
│  ├─ BigQuery (analytics)
│  ├─ Spanner (distributed DB)
│  └─ Kubernetes (container orchestration)
├─ Internal services
│  ├─ Email (Gmail, corporate)
│  ├─ Docs/Sheets (collaboration)
│  ├─ Drive (storage)
│  └─ Analytics
└─ Infrastructure
   ├─ Custom silicon (TPUs, etc.)
   ├─ Direct fiber optic backbone
   ├─ Custom switches & routers
   └─ Proprietary control software
```

**Key Characteristics:**

1. **Scale + efficiency**
   - Billions of users daily
   - Automatic load balancing globally
   - Constantly optimizing for efficiency

2. **Own the entire stack**
   - Microchip design (custom CPUs, TPUs)
   - Network hardware (switches, routers)
   - Operating systems and databases
   - Result: Better cost/performance than anyone else

3. **Innovation velocity**
   - New services launched weekly
   - A/B testing on production
   - Fast feedback loops

4. **Global resilience**
   - No single point of failure
   - Regional outage doesn't affect service
   - Automatic failover (user doesn't notice)

---

## Cost Comparison: Same Workload

### Scenario: 100M Users, 1M Transactions/Day

#### JPMorgan Approach (Finance-style)

```
Data center infrastructure:
├─ 50,000 servers: $750M (capex) / $125M (annual depreciation)
├─ Networking: $200M
├─ Storage (SAN): $150M
├─ Facilities: $75M
├─ Redundant DC: $300M (capex) / $50M (annual)
├─ Staffing (2,000 people): $250M
└─ Software/licenses: $100M

Annual cost: ~$575M (including staff)
Cost per user: $5.75/year
Cost per transaction: $5,750
```

**Key insight:** Even at huge scale, fixed costs dominate. Adding 10M more users = minimal cost increase.

#### Google Approach (Tech-style)

```
Cloud infrastructure:
├─ Compute (1M servers worth): $800M
├─ Storage (100PB): $200M
├─ Networking/CDN: $150M
├─ Custom silicon ROI: $100M
├─ Staffing (100 people): $15M
└─ Tools & misc: $50M

Annual cost: ~$1.3B (initially higher due to GCP markup)
Cost per user: $13/year (public cloud pricing)
Cost per transaction: $13,000
```

**Key insight:** Variable costs mean you can scale up/down easily. But per-unit cost is ~2-3x higher initially.

#### Effective Cost at Their Scale

But Google runs **all of YouTube, Gmail, Search, Maps, Docs, etc.**:

**Among all products:**
```
Total revenue: $280B/year
Total infrastructure: $15-20B/year
Percentage: 5-7%
Cost per user (500M regular users): $30/year
```

Much better amortized across all products.

---

## Why This Divergence Exists

### Factor 1: Business Model

**Banks:**
```
Revenue = fixed fees + trading spreads + interest
Consistency > Growth
Cost control = directly affects profitability
Small increase in cost = immediately visible
```

**Tech:**
```
Revenue = advertising + subscriptions + APIs
Growth > Consistency
Cost control = important but can sacrifice for features
Massive growth often justifies cost increase
```

### Factor 2: Regulatory Environment

**Banks:**
```
SEC/CFTC regulate infrastructure
"Where is data stored?" matters legally
"How is it protected?" is a compliance question
Systems must be audited constantly
→ Prefer on-prem (full control)
```

**Tech:**
```
Much lighter regulation
GDPR is main constraint
Encryption handles most issues
Distributed infrastructure actually helps compliance
→ Prefer cloud (global distribution)
```

### Factor 3: Latency Requirements

**Banks:**
```
Trading: Microseconds = money
Electronic Communication Network (ECN) connections must be &lt;1ms
Own private cables between exchanges and data centers
Cost: $500M+ for low-latency infrastructure
Justifiable because microsecond advantage = billions in revenue
```

**Tech:**
```
Search results: Milliseconds = user experience
100ms delay = users perceive slowness
Still acceptable on cloud (only adds 5-20ms)
Not worth $500M investment
```

### Factor 4: Legacy System Burden

**Banks:**
```
Trading systems built in 1990s-2000s
Converting to cloud = 5+ year project
Risk of breaking something critical = too high
Cost: Maintaining old + building new simultaneously
Solution: Hybrid (eventually)
```

**Tech:**
```
Systems built on cloud-native principles from start
No legacy burden
Can optimize microservices continuously
Moving between clouds is easier (though still costly)
```

### Factor 5: Data Gravity

**Banks:**
```
Petabytes of historical transaction data
Moving this to cloud = expensive ($billions in data transfer)
Analysis better done on-prem where data is
Keep data in DC, query from cloud = costs still high
Decision: Keep data on-prem, cloud supplements
```

**Tech:**
```
Data is the product, not the obstacle
Google/Facebook: Designed to move data globally
Data gravity less relevant
Better to have data in cloud where analysis happens
```

---

## Infrastructure Metrics Comparison

### Performance Metrics

| Metric | JPMorgan | Google |
|:-------|:---------|:-------|
| **Latency (mean)** | &lt;1ms on-prem queries | 100-200ms globally |
| **Latency (p99)** | &lt;10ms | &lt;500ms |
| **Availability** | 99.99% (4-nines) | 99.95% |
| **Failover time** | &lt;100ms | Automatic, instant |

Note: JPMorgan's stricter SLA is because microseconds matter. Google's is sufficient for user-facing services.

### Efficiency Metrics

| Metric | JPMorgan | Google |
|:-------|:---------|:-------|
| **Power usage efficiency** | 1.8-2.0 (less efficient) | 1.10-1.15 (world class) |
| **Server utilization** | 30-40% (reserved capacity) | 70-80% (tightly packed) |
| **Cost per server/year** | $75K+ | $45K (amortized) |
| **Depreciation** | 5-7 years | 3-5 years |

Google wins on efficiency because dedicated infrastructure allows extreme optimization. JPMorgan accepts lower efficiency for reliability.

### Staffing: The Hidden Cost

| Metric | JPMorgan | Google |
|:-------|:---------|:-------|
| **Infrastructure staff** | 7,000+ | 500-1,000 |
| **Infrastructure spend** | $3.3B | $15-20B + staff |
| **Servers per staff** | 7 servers/person | 2,000 servers/person |
| **Cost per staff** | $471K/salary | $1.5M+ (comp + overhead) |

Google's personnel are dramatically better productivity (leveraging automation, cloud self-service).

JPMorgan needs many hands-on staff due to complexity of on-prem systems.

---

## Hybrid Future: Who's Moving Where?

### Banks Moving to Cloud

**JPMorgan target (10 year plan):**
- 2024: 60/40 on-prem/cloud split
- 2030: 40/60 on-prem/cloud split
- 2035: 20/80 on-prem/cloud split (core only remains on-prem)

**Goldman Sachs target:**
- Currently: 70/30 on-prem/cloud
- 2030: 50/50 target
- They're slower due to more trading (latency-sensitive)

**Why cloud adoption:**
- New generation of engineers expect cloud
- Leverage AWS/Azure for innovation
- Reduce staffing burden
- Cost eventually becomes competitive

### Tech Companies Considering On-Prem

**Facebook/Meta:**
- Built custom data centers (Open Compute Project)
- Hybrid with heavy on-prem focus
- Why: Extreme scale, want capex control

**Amazon:**
- AWS dominates cloud business
- But owns massive on-prem infrastructure
- Why: Retail operations need dedicated capacity

**Apple:**
- Builds custom chips (silicon)
- Own data centers for iCloud
- Why: Privacy + control for consumer data

---

## The Future: Convergence

Both models will likely **converge on hybrid:**

```
2030 Vision:

Bank of the future:
├─ Core trading (latency-critical): On-prem / Private cloud
├─ Risk & compliance (regulatory): Hybrid (encrypted cloud)
├─ Client services (growth area): Public cloud
├─ Analytics (AI/ML): Public cloud
└─ Legacy systems: Gradual retirement

Tech company of the future:
├─ Core services: Custom on-prem datacenters (efficiency)
├─ Expansion markets: Public cloud
├─ Disaster recovery: Multi-cloud
└─ Bursty workloads: Spot instances & serverless
```

---

## Key Takeaways

1. **Banks prefer on-prem, tech prefers cloud**—fundamentally different business models
2. **JPMorgan: $2B/year for full ownership vs Google: $0.3B/year for equivalent scale** (via public cloud)
3. **On-prem staff requirements are massive (7,000+)**—hidden cost for banks
4. **Latency & regulatory issues drive on-prem adoption**—not just cost
5. **Hybrid is becoming standard**—nobody going full one way
6. **Cloud efficiency is better at scale**—but requires different architecture
7. **Data gravity is real**—petabytes hard to move
8. **Future is specialized infrastructure**—not generic cloud
