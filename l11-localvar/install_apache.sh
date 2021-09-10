#!/bin/bash

yum -y update
yum -y install httpd

myip=`curl ifconfig.co`

cat <<EOF > /var/www/html/index.html
<html>
<body>
<center>
<h2>Build by Terraform! <br>Using external script!"</h2>
<h3>WebServer with IP: $myip</h3> 
<b>Version 1.0</b>
</center>
</body>
</html>
EOF

sudo service httpd start
chkconfig httpd on