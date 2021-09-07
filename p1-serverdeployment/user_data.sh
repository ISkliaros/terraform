yum -y update
yum -y install httpd

myip=`curl ifconfig.co`

cat <<EOF > /var/www/html/index.html
<html>
<body>
<h2>Build by Terraform! <br>Using external script!"</h2>
echo "<h3>WebServer with IP: $myip</h3> 
<b>Version 1.0</b>
</body>
</html>
EOF

sudo service httpd start
chkconfig httpd on