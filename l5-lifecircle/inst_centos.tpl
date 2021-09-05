#!/bin/bash
yum -y update
yum -y install httpd

myip=`curl ifconfig.co`

cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by power of Terraform</h2>
Owner ${f_name} ${l_name} <br>

%{ for x in names ~}
Hello to ${x} from ${f_name}<br>
%{ endfor ~}

</html>
EOF

sudo service httpd start
chkconfig httpd on