---
title: Nginx Setup & Subdomain Hosting
sidebar_position: 3
displayed_sidebar: technologySidebar
tags:
  - nginx
  - hosting
  - subdomain
  - cloud
  - devops
---

# ⚙️ Nginx Setup & Subdomain Hosting

Learn how to install Nginx, serve static sites, and host multiple apps on one server using subdomains like `second-brain.dkbrainhub.com`.

---

## 🤔 What Is Nginx?

Nginx (pronounced "engine-x") is a web server that receives HTTP requests and routes them to the right place.

> 🏨 **Analogy:** Your cloud server is a hotel building. Nginx is the front desk receptionist. When a guest arrives asking for `second-brain.dkbrainhub.com`, the receptionist checks which room (app/folder) to send them to.

One Nginx instance can serve **many different sites and apps** on the same server — each identified by its hostname/subdomain.

---

## 📦 Step 1 — Install Nginx

SSH into your server:

```bash
ssh root@YOUR_SERVER_IP
```

Install Nginx on Ubuntu/Debian:

```bash
apt update
apt install nginx -y

# Start and enable on boot
systemctl start nginx
systemctl enable nginx

# Verify it's running
systemctl status nginx
```

Open your browser and visit `http://YOUR_SERVER_IP` — you should see the **Nginx default welcome page**.

---

## 📁 Step 2 — Understand the Key Files & Folders

```
/etc/nginx/
├── nginx.conf                  # Main config (don't touch unless you know what you're doing)
├── sites-available/            # All site config files live here (enabled or not)
│   ├── default                 # Default site (disable this)
│   └── second-brain            # Your app's config file
└── sites-enabled/              # Symlinks to active configs in sites-available
    └── second-brain -> ../sites-available/second-brain

/var/www/                       # Default web root (store your apps here)
└── second-brain/               # Static files for second-brain.dkbrainhub.com
    └── index.html
```

> 🔑 **Key idea:** Nginx reads only files in `sites-enabled/`. To activate a config, you symlink it from `sites-available/` to `sites-enabled/`.

---

## 🌐 Step 3 — Create Your First Site Config

### 3a — Create the web root folder

```bash
mkdir -p /var/www/second-brain

# Add a test page
echo '<h1>Hello from second-brain.dkbrainhub.com!</h1>' > /var/www/second-brain/index.html

# Set ownership so Nginx can read the files
chown -R www-data:www-data /var/www/second-brain
chmod -R 755 /var/www/second-brain
```

### 3b — Create the Nginx config file

```bash
nano /etc/nginx/sites-available/second-brain
```

Paste this configuration:

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name second-brain.dkbrainhub.com;

    root /var/www/second-brain;
    index index.html;

    # Gzip compression — speeds up page loads
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml;

    # Cache static assets for 1 year (images, fonts, JS, CSS)
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Handle client-side routing (React, Vue, Docusaurus SPAs)
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    server_tokens off;   # Don't reveal Nginx version in error responses

    error_page 404 /404.html;
}
```

### 3c — Enable the site and reload Nginx

```bash
# Create a symlink to enable the site
ln -s /etc/nginx/sites-available/second-brain /etc/nginx/sites-enabled/

# Disable the default placeholder site
rm -f /etc/nginx/sites-enabled/default

# Test your configuration for syntax errors
nginx -t

# Reload Nginx (zero-downtime — no restart needed)
systemctl reload nginx
```

Visit `http://second-brain.dkbrainhub.com` — your site is live! 🎉

---

## 🏘️ Step 4 — Host Multiple Apps on One Server

This is where subdomains shine. Each app gets its own config file and subdomain.

> 🏢 **Analogy:** One apartment building, multiple tenants. Each tenant (app) has their own front door (subdomain) and room (folder).

### Adding a second app: `api.dkbrainhub.com`

```bash
# Create folder and add content
mkdir -p /var/www/api
echo '{"status": "ok"}' > /var/www/api/index.html
chown -R www-data:www-data /var/www/api

# Create Nginx config
cat > /etc/nginx/sites-available/api << 'EOF'
server {
    listen 80;
    listen [::]:80;

    server_name api.dkbrainhub.com;

    root /var/www/api;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

# Enable it
ln -s /etc/nginx/sites-available/api /etc/nginx/sites-enabled/

# Reload
nginx -t && systemctl reload nginx
```

### Adding a third app: `portfolio.dkbrainhub.com`

```bash
mkdir -p /var/www/portfolio
# ... copy your app files here ...
chown -R www-data:www-data /var/www/portfolio

cat > /etc/nginx/sites-available/portfolio << 'EOF'
server {
    listen 80;
    listen [::]:80;

    server_name portfolio.dkbrainhub.com;

    root /var/www/portfolio;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx
```

### What it looks like when you have multiple apps

```
Server IP: 152.42.157.67

second-brain.dkbrainhub.com  →  /var/www/second-brain/   (Docusaurus docs site)
api.dkbrainhub.com           →  /var/www/api/             (REST API or JSON files)
portfolio.dkbrainhub.com     →  /var/www/portfolio/       (Personal portfolio)
blog.dkbrainhub.com          →  /var/www/blog/            (Static blog)
```

All served by the **same single server** and **same Nginx** — no extra cost!

---

## 🔒 Step 5 — Add HTTPS with Let's Encrypt (Free SSL)

Once your DNS is pointing to your server, get a free SSL certificate:

```bash
# Install Certbot
apt install certbot python3-certbot-nginx -y

# Get certificate for one subdomain
certbot --nginx -d second-brain.dkbrainhub.com

# Or get certificates for multiple subdomains at once
certbot --nginx \
  -d second-brain.dkbrainhub.com \
  -d api.dkbrainhub.com \
  -d portfolio.dkbrainhub.com

# Certbot auto-renews every 90 days. Test renewal:
certbot renew --dry-run
```

After running Certbot, your Nginx config is automatically updated to redirect HTTP → HTTPS.

---

## 🔁 Proxy Pass — Running Node.js / Python Apps

If your app runs on a local port (e.g., Node.js on port 3000), use Nginx as a **reverse proxy**:

```nginx
server {
    listen 80;
    server_name app.dkbrainhub.com;

    location / {
        proxy_pass http://localhost:3000;   # Forward to your local app
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

> 🔌 **Analogy:** Nginx acts as a power strip — the outside world plugs into Nginx (port 80/443), and Nginx plugs into whichever internal socket (port) your app is running on.

---

## 🧰 Useful Nginx Commands

```bash
nginx -t                       # Test config for syntax errors
systemctl reload nginx         # Reload config (zero downtime)
systemctl restart nginx        # Full restart
systemctl status nginx         # Check if running
nginx -v                       # Show version

# View live access logs
tail -f /var/log/nginx/access.log

# View live error logs
tail -f /var/log/nginx/error.log

# List all enabled sites
ls -la /etc/nginx/sites-enabled/
```

---

## 🗺️ Full Architecture Overview

```
Internet
    │
    ▼
Your Domain (dkbrainhub.com)
    │  DNS A record → 152.42.157.67
    ▼
DigitalOcean Droplet (152.42.157.67)
    │  Port 80 (HTTP) / 443 (HTTPS)
    ▼
Nginx (reverse proxy / web server)
    ├── second-brain.dkbrainhub.com  →  /var/www/second-brain/
    ├── api.dkbrainhub.com           →  localhost:3000 (Node.js)
    └── portfolio.dkbrainhub.com     →  /var/www/portfolio/
```

---

## 📚 Resources

| Resource | Link |
|---|---|
| Nginx Docs | [nginx.org/en/docs](https://nginx.org/en/docs/) |
| DigitalOcean Nginx Guide | [How To Install Nginx on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-22-04) |
| Certbot (Let's Encrypt) | [certbot.eff.org](https://certbot.eff.org) |
| Nginx Config Generator | [nginxconfig.io](https://www.digitalocean.com/community/tools/nginx) |

---

*Last updated: February 2026*
