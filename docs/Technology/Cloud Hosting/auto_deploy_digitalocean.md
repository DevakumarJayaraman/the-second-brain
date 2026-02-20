---
title: Auto-Deploy to DigitalOcean
sidebar_position: 4
displayed_sidebar: technologySidebar
tags:
  - cicd
  - github-actions
  - digitalocean
  - devops
  - deployment
---

# 🚀 Auto-Deploy to DigitalOcean with GitHub Actions

Set up a CI/CD pipeline that automatically builds and deploys your site to DigitalOcean every time changes are merged to the `master` branch.

---

## 🤔 How It Works

> 🏭 **Analogy:** Think of GitHub Actions as a robot factory worker. Every time you merge code to `master`, the robot wakes up, builds the latest version of your site, ships it to your server, and verifies everything looks good — all without you lifting a finger.

```
Developer merges PR to master
          │
          ▼
GitHub Actions triggers automatically
          │
          ├── 1. Checkout code
          ├── 2. Install dependencies (npm ci)
          ├── 3. Build the site (npm run build)
          ├── 4. SSH into DigitalOcean Droplet
          ├── 5. Deploy new version to server
          ├── 6. Reload Nginx
          └── 7. Verify site is live ✅
               (Rollback if anything fails ↩️)
```

---

## 🔑 Step 1 — Generate a Dedicated Deploy SSH Key

Create a **separate SSH key pair** just for deployments (never reuse your personal key):

```bash
# Run this on your LOCAL machine
ssh-keygen -t ed25519 -C "github-deploy-key" -f ~/.ssh/github_deploy_key

# This creates two files:
# ~/.ssh/github_deploy_key      ← Private key (goes into GitHub Secrets)
# ~/.ssh/github_deploy_key.pub  ← Public key (goes onto your server)
```

---

## 🖥️ Step 2 — Add the Public Key to Your Server

SSH into your DigitalOcean Droplet and authorize the deploy key:

```bash
ssh root@YOUR_DROPLET_IP

# On the server, add the public key to authorized_keys
echo "PASTE_YOUR_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys

# Ensure correct permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

Alternatively, from your local machine:

```bash
ssh-copy-id -i ~/.ssh/github_deploy_key.pub root@YOUR_DROPLET_IP
```

---

## 🔐 Step 3 — Add GitHub Repository Secrets

Your workflow needs three secrets to connect to DigitalOcean securely. Never hardcode these in your code.

1. Go to your GitHub repo → **Settings → Secrets and variables → Actions → New repository secret**
2. Add these three secrets:

| Secret Name | Value | Example |
|---|---|---|
| `DROPLET_SSH_KEY` | Content of your **private** key file | `-----BEGIN OPENSSH PRIVATE KEY-----\n...` |
| `DROPLET_IP` | Your Droplet's IP address | `152.42.157.67` |
| `DROPLET_USER` | SSH user on your Droplet | `root` |

To get the private key content:

```bash
cat ~/.ssh/github_deploy_key
# Copy the entire output including the BEGIN/END lines
```

---

## ⚙️ Step 4 — The GitHub Actions Workflow

This repository already includes the workflow at `.github/workflows/deploy.yml`. It runs automatically on every push to `master` or `main`.

### What the workflow does

| Step | What Happens |
|---|---|
| **Checkout** | Downloads the latest code |
| **Setup Node.js** | Installs Node 20 with npm cache |
| **Install dependencies** | Runs `npm ci` (clean install) |
| **Build** | Runs `npm run build` to generate static files |
| **Setup SSH** | Writes the private key from secrets and adds the server to `known_hosts` |
| **Create directories** | Creates versioned deploy folders on the server |
| **Save previous version** | Remembers the last deploy for rollback |
| **Deploy files** | Uses `rsync` to efficiently copy only changed files |
| **Set permissions & reload** | Fixes file ownership and reloads Nginx |
| **Verify** | Checks the site returns HTTP 200 |
| **Rollback** *(on failure)* | Reverts to the previous version if any step fails |
| **Cleanup** | Removes the SSH key from the runner |

### Versioned deploys (zero-downtime)

Each deployment creates a new versioned folder:

```
/applications/second-brain/
├── versions/
│   ├── v_20260218_120000/   ← previous version
│   └── v_20260220_093045/   ← current version
├── latest -> versions/v_20260220_093045   ← symlink (what Nginx serves)
└── .backups/
    ├── current_version
    └── previous_version
```

Nginx points to `/applications/second-brain/latest`. Switching versions is instant — just update the symlink.

---

## 🏗️ Step 5 — Configure Nginx to Serve the Versioned Deploy

On your server, point Nginx's `root` directive at the `latest` symlink:

```nginx
# /etc/nginx/sites-available/second-brain
server {
    listen 80;
    listen [::]:80;

    server_name second-brain.dkbrainhub.com;

    root /applications/second-brain/latest;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # ... (gzip, caching, security headers — see Nginx guide)
}
```

```bash
# Enable and reload
ln -s /etc/nginx/sites-available/second-brain /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx
```

---

## ▶️ Step 6 — Trigger Your First Deployment

You can trigger the workflow in two ways:

### Automatically (recommended)
Merge any PR to `master` — the workflow starts within seconds.

### Manually (for testing)
1. Go to your repo on GitHub
2. Click **Actions** tab
3. Select **Deploy to DigitalOcean**
4. Click **Run workflow → Run workflow**

---

## 🔄 How Rollback Works

If any step in the deployment fails, the **Rollback on failure** step automatically runs:

```bash
# What the rollback step does on the server:
PREVIOUS=$(cat /applications/second-brain/.backups/previous_version)
rm -f /applications/second-brain/latest
ln -s /applications/second-brain/versions/$PREVIOUS /applications/second-brain/latest
systemctl reload nginx
```

> ↩️ **Analogy:** It's like a time machine. If the new delivery is broken, the receptionist (Nginx) immediately starts directing guests back to the previous good version.

---

## 🧪 Verify the Pipeline Is Working

After your first successful deployment:

```bash
# SSH into server and check the deployed files
ssh root@YOUR_DROPLET_IP
ls /applications/second-brain/versions/
readlink /applications/second-brain/latest
cat /applications/second-brain/.backups/current_version

# Check the site
curl -I http://second-brain.dkbrainhub.com
# Expected: HTTP/1.1 200 OK
```

---

## 📋 Checklist: Full Setup

- [ ] SSH key pair generated (`~/.ssh/github_deploy_key`)
- [ ] Public key added to server's `~/.ssh/authorized_keys`
- [ ] GitHub Secrets added: `DROPLET_SSH_KEY`, `DROPLET_IP`, `DROPLET_USER`
- [ ] `.github/workflows/deploy.yml` exists in your repo
- [ ] Nginx configured to serve `/applications/second-brain/latest`
- [ ] DNS A record pointing `second-brain.dkbrainhub.com` → Droplet IP
- [ ] First deployment triggered and verified ✅
- [ ] SSL certificate obtained (`certbot --nginx -d second-brain.dkbrainhub.com`)

---

## 🐛 Troubleshooting

| Problem | Solution |
|---|---|
| `Permission denied (publickey)` | Check the private key was copied correctly into `DROPLET_SSH_KEY` secret. Include all lines including `-----BEGIN` / `-----END`. |
| `Host key verification failed` | The workflow uses `ssh-keyscan` automatically. If it fails, SSH in manually once from the runner to accept the fingerprint. |
| `HTTP 502 Bad Gateway` | Nginx is running but the app hasn't deployed yet, or the symlink is broken. Check `readlink /applications/second-brain/latest`. |
| `rsync: connection unexpectedly closed` | SSH connection issue. Verify `DROPLET_IP` and `DROPLET_USER` secrets are correct. |
| Build fails locally but works in CI | Ensure `package-lock.json` is committed. The workflow uses `npm ci` which requires it. |

---

## 📚 Resources

| Resource | Link |
|---|---|
| GitHub Actions Docs | [docs.github.com/actions](https://docs.github.com/en/actions) |
| DigitalOcean SSH Docs | [How to Set Up SSH Keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-22-04) |
| GitHub Encrypted Secrets | [Using secrets in GitHub Actions](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions) |
| rsync Manual | [linux.die.net/man/1/rsync](https://linux.die.net/man/1/rsync) |

---

*Last updated: February 2026*
