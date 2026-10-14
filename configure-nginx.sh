#!/bin/bash

# Update apt cache.
sudo apt-get update

# Install Nginx.
sudo apt-get install -y nginx

# Set the home page.
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head><title>Azure VM</title></head>
<body>
  <h1>Welcome to Azure!</h1>
  <h2>Hostname: <strong>$(hostname)</strong></h2>
  <h2>Current Date/Time: <strong>$(date)</strong></h2>
</body>
</html>
EOF