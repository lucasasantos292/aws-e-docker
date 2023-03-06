<h1 align="Center">
AWS e Docker
</h1>

Atividade prática com AWS e Docker do estágio em DevSecOps da empresa [Compass UOL](http://compass.uol) para fixar os conhecimentos sobre essas tecnologias. Para execução serão utilizadas aplicações dos conceitos de Docker, Docker Compose e Load Balancer, para subir uma aplicação Wordpress com banco de dados MySQL.

# Índice
* [Descrição](#descrição-da-atividade)
* [Passos iniciais](#passos-iniciais)
* [Criação Grupos de Segurança](#grupos-de-segurança)
* [Criação da Instância](#criação-da-instância-ec2)
* [Configuração do NFS](#configuração-do-nfs)
* [Criação do Load Balancer](#criação-do-load-balancer)



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




# Passos iniciais

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


7. depois só colocar o docker-compose para rodar na EC2, ver com o docker ps se ta up
8. e por ultimo, entrar no target group para ver como ta o estado do target que foi colocado no passo 5
9. se ele tiver Health, é só ir no Load Balancer e pegar o DNS que ele da, jogar no google e ele deve acessar a tela do wordpress


