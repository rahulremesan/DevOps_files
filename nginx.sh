#!/bin/bash

if [ "$(id -u)" -eq 0 ]; then
    echo "User is a superuser. Proceeding with the script..."
else
    echo "You need to run this script as a superuser (root)."
    exit 1
fi

WEBSITE_URL="https://www.tooplate.com/zip-templates/2132_clean_work.zip"
DIR="2132_clean_work"

echo "Updating the system"
apt update
apt list --upgrade -y

echo "Installing Nginx...."
apt install nginx -y 2>&1 | tee -a log.txt

wget "$WEBSITE_URL"
unzip "$DIR".zip

echo "Clearing the everything"
cp -r "$DIR"/* /var/www/html/
rm -rf "$DIR" "$DIR".zip

echo "Configuring Nginx..."
cat <<EOL >/etc/nginx/sites-available/my_website
server {
    listen 8001; 
    server_name localhost;

    location / {
        root /var/www/html/;
        index index.html;
    }
}

# server {
#     listen 443; 
#     server_name mykitchen.com; 



#     location / {
#         root /var/www/html/;
#         index index.html;
#     }
# }
EOL

ln -s /etc/nginx/sites-available/my_website /etc/nginx/sites-enabled/

echo "Testing Nginx configuration..."
nginx -t >>log.txt

echo "Reloading Nginx to apply the changes..."
systemctl reload nginx >>log.txt

echo "Starting Nginx service..."
systemctl start nginx

echo "Enabling Nginx to start on boot..."
systemctl enable nginx
