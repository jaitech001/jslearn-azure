#!/bin/bash
# Update package lists and install Nginx
sudo apt-get update -y
sudo apt-get install nginx -y

# Configure Nginx to serve dynamic system information on access
cat << 'EOF' | sudo tee /var/www/html/index.nginx-debian.html > /dev/null
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Nginx on Azure VM</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f4f6f9;
            color: #333;
        }
        .container {
            max-width: 600px;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        h1 { color: #0078d4; }
        .info-box {
            background: #f0f4f8;
            padding: 15px;
            border-left: 5px solid #0078d4;
            margin-top: 20px;
        }
        .meta-item { font-size: 1.1em; margin: 10px 0; }
        .bold { font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Nginx Successfully Installed!</h1>
        <p>This page dynamically updates with server and access metrics upon page load.</p>
        
        <div class="info-box">
            <div class="meta-item"><span class="bold">VM Hostname:</span> <!--SERVER_HOSTNAME--></div>
            <div class="meta-item"><span class="bold">Current Server Date:</span> <!--SERVER_DATE--></div>
            <div class="meta-item"><span class="bold">Your Access Time:</span> <span id="access-time">Loading...</span></div>
        </div>
    </div>

    <script>
        // Display the client-side exact date & time of access
        const now = new Date();
        document.getElementById('access-time').innerText = now.toLocaleString();
    </script>
</body>
</html>
EOF

# Fetch the hostname and current date to inject into the template placeholder
HOSTNAME=$(hostname)
CURRENT_DATE=$(date '+%A, %B %d, %Y')

# Replace the server-side placeholders in the HTML template
sudo sed -i "s/<!--SERVER_HOSTNAME-->/$HOSTNAME/g" /var/www/html/index.nginx-debian.html
sudo sed -i "s/<!--SERVER_DATE-->/$CURRENT_DATE/g" /var/www/html/index.nginx-debian.html

# Restart Nginx to apply changes safely
sudo systemctl restart nginx
