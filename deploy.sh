#!/bin/bash

#===============================================================================
# DOCUSAURUS DEPLOYMENT SCRIPT FOR DIGITALOCEAN
#===============================================================================
# This script builds and deploys your Docusaurus site to a DigitalOcean droplet
#
# PREREQUISITES:
# 1. SSH key configured for passwordless login to your droplet
# 2. nginx (or another web server) installed on the droplet
# 3. Update the configuration variables below
#
# USAGE:
#   ./deploy.sh              # Full build and deploy
#   ./deploy.sh --skip-build # Deploy existing build (skip npm build)
#   ./deploy.sh --dry-run    # Show what would happen without executing
#===============================================================================

set -e  # Exit on any error

#-------------------------------------------------------------------------------
# CONFIGURATION - UPDATE THESE VALUES FOR YOUR SETUP
#-------------------------------------------------------------------------------

# DigitalOcean Droplet Configuration
DROPLET_IP="152.42.157.67"           # e.g., "164.92.123.456"
DROPLET_USER="root"                     # Usually "root" or your sudo user
SSH_KEY_PATH="~/.ssh/id_rsa"           # Path to your SSH private key

# Domain Configuration
DOMAIN_NAME="second-brain.dkbrainhub.com"  # Your subdomain for the site
NGINX_SITE_NAME="second-brain"             # Name for nginx config file

# Remote Server Paths
REMOTE_WEB_ROOT="/applications/second-brain"  # Where to deploy on the server
REMOTE_BACKUP_DIR="/backups/applications/second-brain"     # Backup directory on server

# Local Paths
LOCAL_PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCAL_BUILD_DIR="${LOCAL_PROJECT_DIR}/build"

# Web Server (nginx or apache)
WEB_SERVER="nginx"                       # "nginx" or "apache2"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

#-------------------------------------------------------------------------------
# HELPER FUNCTIONS
#-------------------------------------------------------------------------------

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_config() {
    if [[ "$DROPLET_IP" == "YOUR_DROPLET_IP" ]]; then
        log_error "Please update DROPLET_IP in the script configuration!"
        echo ""
        echo "Edit this script and update these variables:"
        echo "  DROPLET_IP=\"your.droplet.ip.address\""
        echo "  DROPLET_USER=\"your_username\""
        echo "  SSH_KEY_PATH=\"path/to/your/ssh/key\""
        exit 1
    fi
}

#-------------------------------------------------------------------------------
# MAIN DEPLOYMENT FUNCTIONS
#-------------------------------------------------------------------------------

build_site() {
    log_info "Building Docusaurus site..."
    cd "$LOCAL_PROJECT_DIR"
    
    # Install dependencies if node_modules doesn't exist
    if [ ! -d "node_modules" ]; then
        log_info "Installing dependencies..."
        npm install
    fi
    
    # Build the site
    npm run build
    
    if [ -d "$LOCAL_BUILD_DIR" ]; then
        log_success "Build completed successfully!"
        log_info "Build size: $(du -sh "$LOCAL_BUILD_DIR" | cut -f1)"
    else
        log_error "Build failed - build directory not found"
        exit 1
    fi
}

test_ssh_connection() {
    log_info "Testing SSH connection to droplet..."
    
    if ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 -o BatchMode=yes \
        "${DROPLET_USER}@${DROPLET_IP}" "echo 'Connection successful'" 2>/dev/null; then
        log_success "SSH connection verified!"
    else
        log_error "Cannot connect to droplet via SSH"
        echo ""
        echo "Please check:"
        echo "  1. Droplet IP is correct: $DROPLET_IP"
        echo "  2. SSH key exists: $SSH_KEY_PATH"
        echo "  3. SSH key is added to droplet's authorized_keys"
        echo ""
        echo "To add your SSH key to the droplet:"
        echo "  ssh-copy-id -i ${SSH_KEY_PATH}.pub ${DROPLET_USER}@${DROPLET_IP}"
        exit 1
    fi
}

setup_remote_directories() {
    log_info "Setting up remote directories..."
    
    ssh -i "$SSH_KEY_PATH" "${DROPLET_USER}@${DROPLET_IP}" << EOF
        # Create directories if they don't exist
        mkdir -p ${REMOTE_WEB_ROOT}
        mkdir -p ${REMOTE_BACKUP_DIR}
        
        # Set proper permissions
        chown -R www-data:www-data ${REMOTE_WEB_ROOT} 2>/dev/null || true
EOF
    
    log_success "Remote directories ready!"
}

setup_nginx_config() {
    log_info "Checking nginx configuration for ${DOMAIN_NAME}..."
    
    # Check if nginx config already exists
    NGINX_EXISTS=$(ssh -i "$SSH_KEY_PATH" "${DROPLET_USER}@${DROPLET_IP}" \
        "test -f /etc/nginx/sites-available/${NGINX_SITE_NAME} && echo 'yes' || echo 'no'")
    
    if [ "$NGINX_EXISTS" = "yes" ]; then
        log_success "Nginx configuration already exists!"
        return 0
    fi
    
    log_info "Creating nginx configuration for ${DOMAIN_NAME}..."
    
    ssh -i "$SSH_KEY_PATH" "${DROPLET_USER}@${DROPLET_IP}" << NGINX_EOF
        # Create nginx configuration
        cat > /etc/nginx/sites-available/${NGINX_SITE_NAME} << 'INNER_EOF'
server {
    listen 80;
    listen [::]:80;
    
    server_name ${DOMAIN_NAME};
    
    root ${REMOTE_WEB_ROOT};
    index index.html;
    
    # Gzip compression for better performance
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    
    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Handle client-side routing (SPA/Docusaurus)
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    # Disable server version in response
    server_tokens off;
    
    # Error pages
    error_page 404 /404.html;
    location = /404.html {
        internal;
    }
}
INNER_EOF

        # Replace placeholders with actual values
        sed -i "s|\${DOMAIN_NAME}|${DOMAIN_NAME}|g" /etc/nginx/sites-available/${NGINX_SITE_NAME}
        sed -i "s|\${REMOTE_WEB_ROOT}|${REMOTE_WEB_ROOT}|g" /etc/nginx/sites-available/${NGINX_SITE_NAME}
        
        # Enable the site if not already enabled
        if [ ! -L /etc/nginx/sites-enabled/${NGINX_SITE_NAME} ]; then
            ln -s /etc/nginx/sites-available/${NGINX_SITE_NAME} /etc/nginx/sites-enabled/${NGINX_SITE_NAME}
            echo "Site enabled in nginx"
        fi
        
        # Test nginx configuration
        nginx -t
NGINX_EOF
    
    log_success "Nginx configuration created and enabled!"
}

backup_current_deployment() {
    log_info "Backing up current deployment..."
    
    BACKUP_NAME="backup_$(date +%Y%m%d_%H%M%S)"
    
    ssh -i "$SSH_KEY_PATH" "${DROPLET_USER}@${DROPLET_IP}" << EOF
        if [ -d "${REMOTE_WEB_ROOT}" ] && [ "\$(ls -A ${REMOTE_WEB_ROOT})" ]; then
            cp -r ${REMOTE_WEB_ROOT} ${REMOTE_BACKUP_DIR}/${BACKUP_NAME}
            echo "Backup created: ${BACKUP_NAME}"
            
            # Keep only last 5 backups
            cd ${REMOTE_BACKUP_DIR}
            ls -dt backup_* 2>/dev/null | tail -n +6 | xargs rm -rf 2>/dev/null || true
        else
            echo "No existing deployment to backup"
        fi
EOF
    
    log_success "Backup completed!"
}

deploy_files() {
    log_info "Deploying files to DigitalOcean droplet..."
    
    # Use rsync for efficient file transfer
    rsync -avz --delete \
        -e "ssh -i ${SSH_KEY_PATH}" \
        "${LOCAL_BUILD_DIR}/" \
        "${DROPLET_USER}@${DROPLET_IP}:${REMOTE_WEB_ROOT}/"
    
    log_success "Files deployed successfully!"
}

set_permissions() {
    log_info "Setting file permissions..."
    
    ssh -i "$SSH_KEY_PATH" "${DROPLET_USER}@${DROPLET_IP}" << EOF
        chown -R www-data:www-data ${REMOTE_WEB_ROOT}
        find ${REMOTE_WEB_ROOT} -type d -exec chmod 755 {} \;
        find ${REMOTE_WEB_ROOT} -type f -exec chmod 644 {} \;
EOF
    
    log_success "Permissions set!"
}

restart_webserver() {
    log_info "Restarting ${WEB_SERVER}..."
    
    ssh -i "$SSH_KEY_PATH" "${DROPLET_USER}@${DROPLET_IP}" << EOF
        # Test configuration first
        if [ "${WEB_SERVER}" = "nginx" ]; then
            nginx -t && systemctl restart nginx
        elif [ "${WEB_SERVER}" = "apache2" ]; then
            apache2ctl configtest && systemctl restart apache2
        fi
        
        # Verify it's running
        systemctl status ${WEB_SERVER} --no-pager | head -5
EOF
    
    log_success "${WEB_SERVER} restarted successfully!"
}

verify_deployment() {
    log_info "Verifying deployment..."
    
    # Wait a moment for the server to fully restart
    sleep 2
    
    # Check if site is accessible via domain
    HTTP_STATUS_DOMAIN=$(curl -s -o /dev/null -w "%{http_code}" "http://${DOMAIN_NAME}" 2>/dev/null || echo "000")
    
    if [ "$HTTP_STATUS_DOMAIN" = "200" ]; then
        log_success "Site is live at http://${DOMAIN_NAME}! (HTTP $HTTP_STATUS_DOMAIN)"
    elif [ "$HTTP_STATUS_DOMAIN" = "000" ]; then
        log_warning "Could not reach http://${DOMAIN_NAME} - DNS may not be configured yet"
        log_info "Make sure you have an A record: ${DOMAIN_NAME} -> ${DROPLET_IP}"
        
        # Fallback: check via IP
        HTTP_STATUS_IP=$(curl -s -o /dev/null -w "%{http_code}" "http://${DROPLET_IP}" 2>/dev/null || echo "000")
        if [ "$HTTP_STATUS_IP" = "200" ]; then
            log_success "Site is accessible via IP: http://${DROPLET_IP}"
        fi
    else
        log_warning "Site returned HTTP $HTTP_STATUS_DOMAIN - may need investigation"
    fi
}

setup_ssl() {
    log_info "Checking SSL certificate for ${DOMAIN_NAME}..."
    
    # Check if certbot is installed
    CERTBOT_INSTALLED=$(ssh -i "$SSH_KEY_PATH" "${DROPLET_USER}@${DROPLET_IP}" \
        "command -v certbot &> /dev/null && echo 'yes' || echo 'no'")
    
    if [ "$CERTBOT_INSTALLED" = "no" ]; then
        log_info "Installing certbot..."
        ssh -i "$SSH_KEY_PATH" "${DROPLET_USER}@${DROPLET_IP}" << EOF
            apt-get update
            apt-get install -y certbot python3-certbot-nginx
EOF
    fi
    
    # Check if SSL is already configured
    SSL_EXISTS=$(ssh -i "$SSH_KEY_PATH" "${DROPLET_USER}@${DROPLET_IP}" \
        "test -d /etc/letsencrypt/live/${DOMAIN_NAME} && echo 'yes' || echo 'no'")
    
    if [ "$SSL_EXISTS" = "yes" ]; then
        log_success "SSL certificate already exists for ${DOMAIN_NAME}!"
        return 0
    fi
    
    # Check if domain resolves to this server before attempting SSL
    DOMAIN_RESOLVES=$(ssh -i "$SSH_KEY_PATH" "${DROPLET_USER}@${DROPLET_IP}" \
        "curl -s -o /dev/null -w '%{http_code}' --connect-timeout 5 http://${DOMAIN_NAME} 2>/dev/null || echo '000'")
    
    if [ "$DOMAIN_RESOLVES" = "000" ]; then
        log_warning "Cannot obtain SSL - DNS not configured yet for ${DOMAIN_NAME}"
        log_info "Once DNS is set up, run: ./deploy.sh --setup-ssl"
        return 1
    fi
    
    log_info "Obtaining SSL certificate from Let's Encrypt..."
    ssh -i "$SSH_KEY_PATH" "${DROPLET_USER}@${DROPLET_IP}" << EOF
        certbot --nginx -d ${DOMAIN_NAME} --non-interactive --agree-tos --email admin@${DOMAIN_NAME#*.} --redirect
EOF
    
    log_success "SSL certificate obtained and configured!"
}

show_nginx_config() {
    echo ""
    log_info "Sample nginx configuration for your site:"
    echo ""
    cat << 'NGINX_CONFIG'
# /etc/nginx/sites-available/second-brain

server {
    listen 80;
    listen [::]:80;
    
    server_name your-domain.com www.your-domain.com;
    # Or use: server_name _;  # for IP-based access
    
    root /var/www/second-brain;
    index index.html;
    
    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
    
    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Handle client-side routing (SPA)
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
}
NGINX_CONFIG
    echo ""
    echo "To set up nginx:"
    echo "  1. SSH into your droplet: ssh ${DROPLET_USER}@${DROPLET_IP}"
    echo "  2. Create config: sudo nano /etc/nginx/sites-available/second-brain"
    echo "  3. Enable site: sudo ln -s /etc/nginx/sites-available/second-brain /etc/nginx/sites-enabled/"
    echo "  4. Test & reload: sudo nginx -t && sudo systemctl reload nginx"
    echo ""
}

#-------------------------------------------------------------------------------
# MAIN SCRIPT
#-------------------------------------------------------------------------------

main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║        🚀 DOCUSAURUS DEPLOYMENT TO DIGITALOCEAN 🚀            ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    
    SKIP_BUILD=false
    DRY_RUN=false
    
    # Parse arguments
    for arg in "$@"; do
        case $arg in
            --skip-build)
                SKIP_BUILD=true
                ;;
            --dry-run)
                DRY_RUN=true
                ;;
            --help)
                echo "Usage: ./deploy.sh [options]"
                echo ""
                echo "Options:"
                echo "  --skip-build    Skip npm build (use existing build folder)"
                echo "  --dry-run       Show what would happen without executing"
                echo "  --help          Show this help message"
                echo "  --show-nginx    Show sample nginx configuration"
                echo "  --setup-ssl     Setup SSL certificate with Let's Encrypt"
                echo ""
                exit 0
                ;;
            --show-nginx)
                show_nginx_config
                exit 0
                ;;
            --setup-ssl)
                check_config
                test_ssh_connection
                setup_ssl
                exit 0
                ;;
        esac
    done
    
    # Check configuration
    check_config
    
    if [ "$DRY_RUN" = true ]; then
        log_warning "DRY RUN MODE - No changes will be made"
        echo ""
        echo "Would perform these actions:"
        echo "  1. Build site in: $LOCAL_BUILD_DIR"
        echo "  2. Connect to: ${DROPLET_USER}@${DROPLET_IP}"
        echo "  3. Setup nginx for: ${DOMAIN_NAME} (if not exists)"
        echo "  4. Backup current deployment"
        echo "  5. Deploy to: $REMOTE_WEB_ROOT"
        echo "  6. Restart: $WEB_SERVER"
        echo "  7. Attempt SSL setup (if DNS is configured)"
        echo ""
        exit 0
    fi
    
    # Start deployment
    START_TIME=$(date +%s)
    
    log_info "Starting deployment..."
    log_info "Target: ${DROPLET_USER}@${DROPLET_IP}:${REMOTE_WEB_ROOT}"
    echo ""
    
    # Step 1: Build (unless skipped)
    if [ "$SKIP_BUILD" = false ]; then
        build_site
    else
        log_warning "Skipping build (--skip-build flag)"
        if [ ! -d "$LOCAL_BUILD_DIR" ]; then
            log_error "Build directory not found! Run without --skip-build first."
            exit 1
        fi
    fi
    echo ""
    
    # Step 2: Test SSH connection
    test_ssh_connection
    echo ""
    
    # Step 3: Setup remote directories
    setup_remote_directories
    echo ""
    
    # Step 4: Setup nginx configuration (if not exists)
    setup_nginx_config
    echo ""
    
    # Step 5: Backup current deployment
    backup_current_deployment
    echo ""
    
    # Step 6: Deploy files
    deploy_files
    echo ""
    
    # Step 7: Set permissions
    set_permissions
    echo ""
    
    # Step 8: Restart web server
    restart_webserver
    echo ""
    
    # Step 9: Verify deployment
    verify_deployment
    echo ""
    
    # Step 10: Attempt SSL setup (will skip if DNS not ready)
    setup_ssl
    echo ""
    
    # Calculate duration
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                    ✅ DEPLOYMENT COMPLETE!                     ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    log_success "Deployment finished in ${DURATION} seconds"
    log_info "Your site should be live at: http://${DOMAIN_NAME}"
    log_info "                         or: http://${DROPLET_IP}"
    echo ""
    echo "📝 NEXT STEPS (if not already done):"
    echo "   1. Add DNS A record: ${DOMAIN_NAME} -> ${DROPLET_IP}"
    echo "   2. Once DNS propagates, run: ./deploy.sh --setup-ssl"
    echo ""
}

# Run main function
main "$@"
