#! /bin/bash
# Atualização do sistema
sudo yum update -y
# Instalação e inicialização do Docker
sudo yum install docker -y
sudo service docker start
sudo systemctl enable docker.service
sudo usermod -aG docker ec2-user
# Instalação do Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
sudo chmod +x /usr/local/bin/docker-compose
# Configuração do NFS
sudo mkdir /mnt/efs
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-093a34d287a90fdf5.efs.us-east-1.amazonaws.com:/ /mnt/efs
sudo echo "fs-093a34d287a90fdf5.efs.us-east-1.amazonaws.com:/ /mnt/efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" >> /etc/fstab
# Instalação do git
sudo yum install git -y
git clone https://github.com/lucasasantos292/aws-e-docker
# Inicialização dos conteiners
cd aws-e-docker/docker\ compose/
docker-compose up -d
