#! /bin/bash
# ======================================================================
# SCRIPT NAME: web_server.sh

# PURPOSE: Provision web server for static website

# AUTHOR				DATE			DETAILS
# --------------------- --------------- --------------------------------
# Onanuga Oreoluwa	 2022-06-22	  Initial version

# ======================================================================
RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

function set_up(){
    cd /var/www
    sudo mkdir webpage_folder
    cd webpage_folder
    sudo tee -a index.html <<EOF
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My webserver</title>
</head>
<body>
    <h1>I am provisioning a web_server using nginx</h1>
</body>
</html>
EOF
#Set server up
    cd /etc/nginx/sites-enabled
    sudo touch webpage
    sudo tee -a webpage <<EOF
server {
listen 82;
listen [::]:82;

server_name example.ubuntu.com;

root /var/www/webpage_folder;
index index.html;

location / {
try_files $uri $uri/ =404;}
}
EOF
    sudo service nginx restart
    curl http://localhost:82
}

#checking to use apt or yum
if [[ -n "command -v apt" ]]; then
    echo -e "${GREEN}apt is used here${ENDCOLOR}"
    #Install nginx
    echo "Installing nginx";sudo apt install nginx
    #Move to folder to keep static file
    set_up

elif [[ -n "command -v yum" ]]; then
    echo -e "${GREEN}yum is used here${ENDCOLOR}"
    sudo yum install -y nginx
    set_up
else
    echo "${RED}Type not known${ENDCOLOR}"
fi

echo "Happy Coding!"