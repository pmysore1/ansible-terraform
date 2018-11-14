#!/bin/bash
#

function log { logger -i -t "install_ansible_tower" -s -- "$1" 2> /tmp/console; }

function die {
    [ -n "$1" ] && log "$1"
    log "Failed to install AWX (Opensource version of Anisble Tower)"'!'
    exit 1
}

#sudo yum -y install epel-release

# Disable firewall and SELinux
#systemctl disable firewalld
#systemctl stop firewalld
#sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
#setenforce 0
#reboot

# Enable continuous release (CR) repository if some paskage from EPEL are dependant on newer release
sudo yum -y install git gettext docker nodejs npm gcc-c++ bzip2
sudo pip install ansible
#sudo yum -y install python-docker-py
sudo pip install docker-py

#sudo apt -y install git gettext ansible docker nodejs npm gcc-c++ bzip2
#sudo apt -y install python-docker-py

#  Start and enable docker service
#sudo systemctl start docker
#sudo systemctl enable docker

#sudo service docker start

#su ec2-user -c 'cd ; mkdir awx; cd awx; sudo git clone https://github.com/ansible/awx.git; sudo chown -R ec2-user ~/awx; cd awx/installer/ ;'

#su ec2-user -c 'cd ~/awx/awx/installer; /usr/local/bin/ansible-playbook -b --become-method=sudo -i inventory ~/awx/awx/installer/install.yml;'
#cd
#mkdir awx
#cd awx

# Clone repository and deploy (it will take about 20 minutes)
#sudo git clone https://github.com/ansible/awx.git

#chown -R ec2-user ~/awx

#cd awx/installer/

#sudo ansible-playbook -i inventory install.yml
#ansible-playbook -b --become-method=sudo -i inventory install.yml

# Monitor migrations status (it will take about 10 minutes)
#docker logs -f awx_task

#log "Installation of AWS is complete."
exit 0