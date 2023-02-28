#! /bin/bash
# Atualização do sistema
sudo yum update -y
#instalação e inicialização do Docker
sudo yum install docker -y
sudo service docker start
sudo systemctl enable docker.service
