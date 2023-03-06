<h1 align="Center">
AWS e Docker
</h1>

Atividade prática com AWS e Docker do estágio em DevSecOps da empresa [Compass UOL](http://compass.uol) para fixar os conhecimentos sobre essas tecnologias. Para execução serão utilizadas aplicações dos conceitos de Docker, Docker Compose e Load Balancer, para subir uma aplicação Wordpress com banco de dados MySQL.

# Índice
* [Descrição](#descrição-da-atividade)
* [Passos iniciais](#passos-iniciais)
* [Criação Grupos de Segurança](#grupos-de-segurança)
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

## Criação do Load Balancer
4. criei um Target group para instancias, coloquei a VPC padrao, e nas configurações avançadas do Health check coloquei no código de sucesso o 200,302
5. Na parte de registrar targets eu coloquei a instancia que eu quero e só
6. Criei um Application Load Balancer e coloquei o schema dele para ser Internet-facing. Selecionei a VPC padrão, e o SG dele é o que criei para ele no passo 1. Nos listeners coloquei o target group que criei no passo 4
7. depois só colocar o docker-compose para rodar na EC2, ver com o docker ps se ta up
8. e por ultimo, entrar no target group para ver como ta o estado do target que foi colocado no passo 5
9. se ele tiver Health, é só ir no Load Balancer e pegar o DNS que ele da, jogar no google e ele deve acessar a tela do wordpress

## Criação da Instância EC2

Para criação da sua instância ec2, navegue até a [Console AWS](https://console.aws.amazon.com/) e faça seu login. Acesse a página ec2 e execute uma nova instância.

