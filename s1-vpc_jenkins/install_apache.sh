#!/bin/bash

yum -y update
yum -y install httpd

myip=`curl ifconfig.co`

cat <<EOF > /var/www/html/index.html
<html>
<body style="background-color:purple"">
<center>
<h2>Build by Terraform! <br><b style="color:red">Using external script!</b></h2>
<h3>WebServer with IP: $myip</h3> 
<b>Version 1.0</b>
</center>
</body>
</html>
EOF

sudo service httpd start
chkconfig httpd on