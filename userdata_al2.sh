#!/bin/bash

# Update system
sudo yum update -y

# Enable EPEL and install necessary tools
sudo amazon-linux-extras enable epel -y
sudo yum install -y epel-release
sudo yum install -y git nginx docker curl python3 python3-pip
sudo amazon-linux-extras install nginx1.12 -y

# Enable and start services
sudo systemctl enable nginx --now
sudo systemctl enable docker --now
sudo usermod -aG docker ec2-user

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# App folder setup
mkdir -p /home/ec2-user/myapp
cd /home/ec2-user/myapp

# Clone app repos 
# don't clone if the directory already exists, otherwise you get error that path already exists  
if [ ! -d "nodeapp-iba" ]; then
  git clone https://github.com/adnan495r/nodeapp-iba.git
fi
if [ ! -d "reactapp" ]; then
  git clone https://github.com/adnan495r/reactapp.git
fi

# Create Docker Compose file
cat <<EOF > /home/ec2-user/myapp/docker-compose.yml
version: '3'
services:
  backend:
    build:
      context: ./nodeapp-iba
      dockerfile: Dockerfile_nodeapp
    container_name: backend
    ports:
      - "5000:5000"

  frontend:
    build:
      context: ./reactapp
      dockerfile: Dockerfile_reactapp
    container_name: frontend
    ports:
      - "300:80"
EOF

# Set permissions and run docker-compose
chown -R ec2-user:ec2-user /home/ec2-user
su - ec2-user -c "/usr/local/bin/docker-compose -f /home/ec2-user/myapp/docker-compose.yml up -d"

# Set up Nginx reverse proxy
cat <<EOF | sudo tee /etc/nginx/conf.d/nodeapp.conf
server {
    listen 80;
    server_name aali-al2.devops42.online;

    location /api/ {
        proxy_pass http://127.0.0.1:5000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location / {
        proxy_pass http://127.0.0.1:300/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Restart Nginx with test
sudo nginx -t && sudo systemctl restart nginx

# Allow some time for DNS to propagate (optional but helpful)
sleep 60

# Issue SSL certificate with Certbot
sudo yum install -y certbot python3-certbot-nginx
sudo certbot --nginx -d aali-al2.devops42.online --non-interactive --agree-tos -m adnan495r@gmail.com
sudo certbot renew --dry-run