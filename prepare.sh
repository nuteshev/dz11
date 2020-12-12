cd ~
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
yum install -y -q yum-utils links device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-compose -y -q
systemctl start docker
groupadd admin
useradd dockeradmin
useradd notadmin
echo "Otus2019"| sudo passwd --stdin dockeradmin
echo "Otus2019"| sudo passwd --stdin notadmin
usermod -aG admin dockeradmin
usermod -aG admin vagrant
sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service

cat <<'EOF' >> /usr/local/bin/test_login.sh
#!/bin/bash
if [[ $(date +%a)=="Sat"  || $(date +%a)=="Sun" ]]; then
        if [[ -n `getent group admin | grep $PAM_USER` ]]; then
                exit 0;
        else
                exit 1;
        fi

fi
exit 0
EOF
chmod +x /usr/local/bin/test_login.sh
sed  -i '/pam_nologin.so/a account required pam_exec.so /usr/local/bin/test_login.sh' /etc/pam.d/sshd
usermod -aG docker dockeradmin
cat <<'EOF' >> /etc/sudoers.d/dockeradmin
dockeradmin ALL=(ALL) NOPASSWD: /bin/systemctl restart docker
dockeradmin ALL=(ALL) NOPASSWD: /bin/systemctl start docker
dockeradmin ALL=(ALL) NOPASSWD: /bin/systemctl stop docker
EOF
