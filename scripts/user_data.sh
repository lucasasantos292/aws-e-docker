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
