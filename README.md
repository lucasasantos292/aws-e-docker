<h1 align="Center">
AWS e Docker
</h1>

Atividade prática com AWS e Docker do estágio em DevSecOps da empresa [Compass UOL](http://compass.uol) para fixar os conhecimentos sobre essas tecnologias. Para execução serão utilizadas aplicações dos conceitos de Docker, Docker Compose e Load Balancer, para subir uma aplicação Wordpress com banco de dados MySQL.

# Índice
* [Descrição](#descrição-da-atividade)
* [Criação Grupos de Segurança](#grupos-de-segurança)
* [Criação da Instância](#criação-da-instância-ec2)
* [Configuração do NFS](#configuração-do-nfs)
* [Criação do Load Balancer](#criação-do-load-balancer)
* [Docker Compose](#docker-compose)
* [Criação dos Conteiners](#criação-dos-conteiners)



# Descrição da Atividade


1. Instalação e configuração do DOCKER ou
CONTAINERD no host EC2;

* Ponto adicional para o trabalho utilizar a instalação via script de Start Instance (user_data.sh)
2. Efetuar Deploy de uma aplicação Wordpress
com:

* container de aplicação
* container database Mysql
    
3. configuração da utilização do serviço EFS
AWS para estáticos do container de aplicação
Wordpress
4. configuração do serviço de Load Balancer
AWS para a aplicação Wordpress


# Desenvolvimento da Atividade

## Grupos de Segurança
* Grupo de segurança da instância

Dentro de uma mesma VPC(Virtual Private Cloud) utilize o Security Group default ou, alternativamente, crie um novo Security Group para a intância que executará os conteiners. 
Libere apenas a porta 22 para poder acessar a sua instância via ssh, e as portas HTTP/80/8080 para rodar o wordpress. 

* Grupo de Segurança Load Balancer

Crie mais um grupo de segurança para o Load Balancer com apenas a regra de origem HTTP para qualquer IP.

Agora, deixe as portas HTTP do Security Group da instância liberadas apenas para o Security Group Criado para o Load Balancer.

 ![](/images/sg-instancia.png)

 ## Criação da Instância EC2

Para criação da sua instância ec2, navegue até a [Console AWS](https://console.aws.amazon.com/) e faça seu login. Acesse a página ec2 e execute uma nova instância.
Na área de dados avançados, cole o conteúdo do arquivo [_user_data.sh_](/scripts/user_data.sh) no campo _Dados do Usuário_. Este arquivo é um _script_ que será executado na inicialização da instância.

## Configuração do NFS

No _script user_data.sh_ há o comando para montar e tornar automático o NFS em caso de reinicialização da instância:

```bash
sudo mkdir /efs
sudo echo "ID_FILESYSTEM:/ /PONTO_DE_MONTAGEM nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" >> /etc/fstab
sudo mount -a
```

## Criação do Load Balancer

Para criação do Load Balancer, utilize a mesma VPC onde está o Security Group e crie um Target Group para anexar sua instância. Nas configurações avançadas do Target Group, em Health Check, coloque no código de sucesso o código de retorno HTTP 200.

Depois de criado, registre a sua instância para que ela possa ser verificada e acessada pelo Load Balancer.


Agora, Crie um Application Load Balancer e coloque o Schema Internet-facing, para que possa ser acessado pela internet. Selecione a VPC utilizada até então, selecione o Security Group criado para ele e em _Listeners_ selecione o Target Group criado anteriormente.

## Docker Compose

No arquivo [_user_data.sh_](/scripts/user_data.sh) há os passos para instalação do Docker e Docker Compose, que são basicamente os comandos:
```bash
# Instalação e inicialização do Docker
sudo yum install docker -y
sudo service docker start
sudo systemctl enable docker.service
sudo usermod -aG docker ec2-user
# Instalação do Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
sudo chmod +x /usr/local/bin/docker-compose
```
Para testarmos o funcionamento do Docker Compose, podemos rodar o comando `docker-compose --version`.

## Criação dos Conteiners

Escolha um diretório e execute o comando
```bash
vim docker-compose.yml
```
ou utilize um outro editor de texto de sua preferência.

Um arquivo _docker-compose_ contem as instruções para criação de conteiners de maneira conjunta, neste caso, temos a criação de um conteiner Wordpress e um banco de dados MySql.
```yaml
version: '3.1'

services:

  wordpress:
    image: wordpress
    restart: always
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: exampleuser
      WORDPRESS_DB_PASSWORD: examplepass
      WORDPRESS_DB_NAME: exampledb
    volumes:
      - /wordpress:/var/www/html

  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_DATABASE: exampledb
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
      MYSQL_RANDOM_ROOT_PASSWORD: '1'
    volumes:
      - /db:/var/lib/mysql

volumes:
  wordpress:
  db:
```
Salve o arquivo _docker-compose.yml_ e execute o comando `docker-compose up -d`. Dessa forma irão subir os conteiners. 

Na tela do [Load Balancer](#criação-do-load-balancer), acesse o link DNS, você verá a tela inicial do Wordpress.
![](/images/wordpress.png)

