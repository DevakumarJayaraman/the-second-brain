---
title: Domain Name Registration
sidebar_position: 2
displayed_sidebar: technologySidebar
tags:
  - domain
  - dns
  - namecheap
  - hosting
  - cloud
---

# 🌐 Domain Name Registration

Everything you need to register a domain, pick the right registrar, and point it at your cloud server — in under 15 minutes.

---

## 🤔 What Is a Domain Name?

A domain name is your site's address on the internet (e.g., `dkbrainhub.com`).

> 📮 **Analogy:** Your server's IP address is like a house's GPS coordinates. A domain name is its street address — much easier to remember and share.

---

## 🏷️ Registrar Comparison

| Registrar | `.com` Price/yr | Free WHOIS? | UI | Best For |
|---|---|---|---|---|
| 🟠 **Namecheap** | ~$10–$14 | ✅ Yes | ⭐⭐⭐⭐⭐ Simple | Best value + privacy default |
| 🔵 **Cloudflare Registrar** | ~$10 (at-cost) | ✅ Yes | ⭐⭐⭐⭐ Clean | Cheapest renewal + built-in CDN |
| 🔶 **Google Domains** (now Squarespace) | ~$12 | ✅ Yes | ⭐⭐⭐⭐ Clean | Google ecosystem users |
| 🟢 **Porkbun** | ~$10–$11 | ✅ Yes | ⭐⭐⭐⭐ Friendly | Great value, free SSL included |
| 🔴 **GoDaddy** | ~$12–$20 | ❌ Paid add-on | ⭐⭐⭐ Complex | Avoid upsells; widely known |

> 💡 **Recommendation:** Use **Namecheap** for a beginner-friendly experience, or **Cloudflare Registrar** for the absolute lowest renewal cost with zero markup.

---

## 🚀 Step-by-Step: Register a Domain on Namecheap

### Step 1 — Search for Your Domain

1. Go to [namecheap.com](https://www.namecheap.com)
2. Type your desired domain name in the search bar (e.g., `dkbrainhub`)
3. Browse available TLDs (Top-Level Domains):

   | TLD | Typical Use | Approximate Cost/yr |
   |---|---|---|
   | `.com` | Universal, most trusted | $10–$14 |
   | `.dev` | Developer tools & sites | $12–$15 |
   | `.io` | Tech startups | $30–$50 |
   | `.net` | Network / tech services | $12–$16 |
   | `.org` | Non-profits, communities | $10–$14 |
   | `.xyz` | Budget, experimental | $1–$4 |

4. Click **Add to Cart** next to your chosen domain

### Step 2 — Configure Your Purchase

1. In the cart, **uncheck any auto-added extras** you don't need (hosting, email, etc.)
2. Ensure **WhoisGuard** (WHOIS privacy) is set to **Free** — it should be by default on Namecheap
3. Choose **1 year** to start (you can auto-renew later)
4. Click **Confirm Order**

### Step 3 — Create an Account & Pay

1. Create a Namecheap account with your email
2. Complete the checkout ($10–$14 for most `.com` domains)
3. Verify your email — ICANN requires this within 15 days or your domain gets suspended

### Step 4 — Verify You Own It

Check your domain in the Namecheap dashboard:

```
Namecheap Dashboard → Domain List → your-domain.com ✅ Active
```

---

## 🔗 Point Your Domain to Your Cloud Server

Now you need to tell the internet that `your-domain.com` should go to your server's IP address. This is done with **DNS records**.

### Option A — Use Namecheap's Built-in DNS (Easiest)

1. In Namecheap, go to **Domain List → Manage → Advanced DNS**
2. Add an **A Record**:

   | Type | Host | Value | TTL |
   |---|---|---|---|
   | `A` | `@` | `152.42.157.67` (your server IP) | Automatic |
   | `A` | `www` | `152.42.157.67` | Automatic |
   | `A` | `second-brain` | `152.42.157.67` | Automatic |

   - `@` means the root domain (`dkbrainhub.com`)
   - `www` covers `www.dkbrainhub.com`
   - `second-brain` creates the subdomain `second-brain.dkbrainhub.com`

3. Save changes — DNS propagation takes **5 minutes to 48 hours** (usually under 30 minutes)

### Option B — Use Cloudflare DNS (Recommended for Performance)

Cloudflare's free DNS is faster and adds DDoS protection:

1. Create a free account at [cloudflare.com](https://www.cloudflare.com)
2. Click **Add a Site** → enter your domain → choose the **Free plan**
3. Cloudflare will scan existing records automatically
4. Add your A records as shown above
5. In Namecheap, update your **Nameservers** to the two Cloudflare nameservers shown (e.g., `aria.ns.cloudflare.com`)
6. Save — takes up to 24 hours to switch

> 🛡️ **Bonus with Cloudflare:** Enable the orange cloud (proxy mode) on your A records to get free CDN + DDoS protection + HTTPS.

---

## ✅ Verify DNS Is Working

```bash
# Check if your domain resolves to the correct IP
nslookup second-brain.dkbrainhub.com

# Or with dig
dig second-brain.dkbrainhub.com +short

# Or use the browser
curl -I http://second-brain.dkbrainhub.com
```

Expected output should show your server IP.

---

## 🔒 Free SSL with Let's Encrypt

Once your domain points to your server, you can get a free HTTPS certificate in 30 seconds:

```bash
# On your server (Ubuntu)
apt install certbot python3-certbot-nginx -y
certbot --nginx -d second-brain.dkbrainhub.com
```

Certbot automatically renews the certificate every 90 days.

---

## 💡 Quick Tips

- **Register early** — domain squatters buy popular names. Register yours before announcing your project.
- **Enable auto-renew** — forgetting to renew means losing your domain. Enable it in Namecheap settings.
- **WHOIS privacy** — always enable it (free on Namecheap). Prevents spam to your personal email/address.
- **TTL settings** — use low TTL (e.g., 300 seconds) when first setting up so DNS changes propagate fast.
- **Don't use GoDaddy for renewals** — renewal prices are much higher. Transfer to Namecheap or Cloudflare after the first year.

---

## 📚 Resources

| Resource | Link |
|---|---|
| Namecheap | [namecheap.com](https://www.namecheap.com) |
| Cloudflare Registrar | [cloudflare.com/products/registrar](https://www.cloudflare.com/products/registrar/) |
| Porkbun | [porkbun.com](https://porkbun.com) |
| DNS propagation checker | [dnschecker.org](https://dnschecker.org) |
| What's My DNS | [whatsmydns.net](https://www.whatsmydns.net) |

---

*Last updated: February 2026*
