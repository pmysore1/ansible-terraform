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
sudo pip install docker-py boto3
sudo yum -y install java-1.8.0-openjdk-devel.x86_64
sudo yum -y remove java-1.7.0-openjdk


su ${aws_ec2_user} -c 'cd ; sudo git clone https://github.com/pmysore1/ansible-jenkins.git; sudo chown -R ${aws_ec2_user} ~/ansible-jenkins;'
su ${aws_ec2_user} -c 'cd ~/ansible-jenkins; /usr/local/bin/ansible-playbook -b --become-method=sudo -i hosts site.yml;'
#cd

su ${aws_ec2_user} -c 'aws s3 cp ${s3_pem_file_path}/${s3_pem_file_name} ~/ --sse --region us-gov-west-1;'
su ${aws_ec2_user} -c 'cd sudo chown -R ${aws_ec2_user} ~/${s3_pem_file_name};'
su ${aws_ec2_user} -c 'chmod 400 ~/${s3_pem_file_name};'

su ${aws_ec2_user} -c 'ssh-agent bash;'
su ${aws_ec2_user} -c 'ssh-add ~/${s3_pem_file_name};'

#log "Installation of AWS is complete."
exit 0