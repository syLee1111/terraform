 #!/bin/bash
USERS="bespin"
GROUP="bespin"
for i in $USERS; do
/usr/sbin/adduser $${i};
/bin/echo $${i}:$${i}1! | chpasswd;
done

echo "$USERS ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
sed -i "/wheel/s/$/,$USERS/g" /etc/group
sed -i "/adm/s/$/,$USERS/g" /etc/group

cp -a /etc/ssh/sshd_config /etc/ssh/sshd_config_old
sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

yum install -y httpd
echo "AWS Terraform Test" >> /var/www/html/index.html
systemctl start httpd