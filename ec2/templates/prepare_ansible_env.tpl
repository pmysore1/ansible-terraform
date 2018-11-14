#!/bin/bash
#

function log { logger -i -t "install_ansible_tower" -s -- "$1" 2> /tmp/console; }

function die {
    [ -n "$1" ] && log "$1"
    log "Failed to install AWX (Opensource version of Anisble Tower)"'!'
    exit 1
}



# Enable continuous release (CR) repository if some paskage from EPEL are dependant on newer release
sudo yum -y install git gettext docker nodejs npm gcc-c++ bzip2
sudo pip install ansible
sudo pip install docker-py


su ${aws_ec2_user} -c 'cd ; sudo git clone https://github.com/pmysore1/ansible-nginxandtomcat.git; sudo chown -R ${aws_ec2_user} ~/ansible-nginxandtomcat;'

export ANSIBLE_HOSTS=~/ansible-nginxandtomcat/aws_dyn_inventory/ec2.py
export EC2_INI_PATH=~/ansible-nginxandtomcat/aws_dyn_inventory/ec2.ini
export ANSIBLE_CONFIG=~/ansible-nginxandtomcat/ansible.cfg
#ssh-agent bash
#ssh-add ~/poc-anisble-tower-cognosante.pem

su ${aws_ec2_user} -c 'aws s3 cp ${s3_pem_file_path}/${s3_pem_file_name} ~/ --sse --region us-gov-west-1;'
su ${aws_ec2_user} -c 'cd sudo chown -R ${aws_ec2_user} ~/${s3_pem_file_name};'
su ${aws_ec2_user} -c 'chmod 400 ~/${s3_pem_file_name};'

su ${aws_ec2_user} -c 'ssh-agent bash;'
su ${aws_ec2_user} -c 'ssh-add ~/${s3_pem_file_name};'

#log "Installation of AWS is complete."
exit 0