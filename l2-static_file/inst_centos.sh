#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl ifconfig.co`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform! <br>Using external script!" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on