# Anotações Desafio Final Ney

# Pré-requisitos

## Pré-requisitos instalação locais

* **Instalar kubectl**
* **Instalar Helm**
* **Instalar eksctl**
* **Instalar awscli**\
	Linha de comando para autenticar na aws\
    aws --version para mostrar versão
	 
## Pré-requisitos configuração AWS
* **IAM**\
    Criar o usuário `airflow-user` para utilização dos recuros AWS\
	Chaves de acesso: Access Key ID e Secret Access Key em Security Credentials\
    Setar as devidas permissões do usuário

* **awscli**\
  rodar “aws configure” para criar conexão com a aws\
	Preencher AWS Access Key ID e Secret Access Key do usuário\
	Definir default region: us-east-2\
	Definir Default output: json



# Implementação Airflow/Kubernetes
## 1. Deploy cluster K8s na AWS (EKS) 
O comando demora de 15 a 20 minutos para terminar.
```bat
eksctl create cluster ^ 
    --version=1.21 ^
    --name=kbgregori ^
    --timeout=60m ^
    --managed ^
    --instance-types=m5.xlarge ^
    --alb-ingress-access --node-private-networking ^
    --region=us-east-2 ^
    --nodes-min=2 --nodes-max=3 ^
    --full-ecr-access ^
    --asg-access ^
    --nodegroup-name=ng-kbgregori
```
>   Só funcionou com a opção `--version=1.21`.
>   Para quebrar linhas em unix tracar `^` por `\`

## 2. Atualizar o .yaml do professor com os dados corretos

* **Variáveis de ambiente Airflow:**\
    AIRFLOW__LOGGING__REMOTE_BASE_LOG_FOLDER
    
    Atualizar o s3 para os logs do airflow

```yaml
  - name: AIRFLOW__LOGGING__REMOTE_BASE_LOG_FOLDER
    value: 's3://bucket/af_logs/'
```

* **Git Sync:**\
    Atualizar o repositório das dags

* **Web Server - DefaulUser**:\
    Atualizar as informações de usuário admin\
    (não usar senha verdadeira, atualizar depois)

## 3. Instalar o Airflow no kubernetes com o Helm Chart

## 1. Baixar o Helm do Airflow para a máquina:

`helm repo add apache-airflow https://airflow.apache.org`

## 2. Realizar a instalação do Airflow:

```bat
@echo Inicio: %date% %time%
helm install airflow apache-airflow/airflow ^
    -f airflow\custom_values.yaml ^
    -n airflow ^
    --create-namespace ^
    --version 1.6.0 ^
    --timeout 5m ^
    --debug
@echo Completed: %date% %time%
```
> atualizar `-f caminho.yaml`

> `--version 1.6.0` força a utilização do helm chart 1.6.0\
    versão atual é a 1.7.0. Utilizar a 1.7.0 também funciona


# Configuração Airflow

* **Acessar o airflow:**\
    Rodar `kubectl get svc -n airflow`
    
    Copiar o endereço do serviço loadbalancer (IP externo)

    No navegador colocar o endereço copiado e adicionar a porta 8080

    `http://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-xxxxxxxxx.us-east-2.elb.amazonaws.com:8080`

    Realizar o login com usuário e senha default definidos no yaml

* **Senha do admin:**\
    Utilizar o profile do usuário para atualizar a senha

* **Varíaveies de ambiente:**\
    Em Admin/Connections\
    Adicionar a variável `aws_access_key_id` com valor correpondente para o usuário aws `airflow-user`\
    Adicionar a variável `aws_secret_access_key` com valor correspondete para o usuário aws `airflow-user`

* **Connection para o remote log:**\
  Em Admin/Connections\
 Preencher Connection Id com `my_aws`\
 Preencher Connection Type com `Amazon Web Services`
 Preencher `login` com access-key-id do usuário `airflow-user`\
 Preencher `password` com secret-access-key do usuário `airflow-user`


# Deploy Dag

* Push do codigo para o GitHub

* Verificar a subnet para o emr
    

## Problemas

## 1. Versão Kubernetes 1.2.3 não compatível esta forma de deploy



### .yaml gerado por mim não funciou
    Segui as intruções para gerar um .yaml, este não funcionou.
    A versão do helm chart era a 1.7.0. Sempre deu timeout
    Solução não encontrada.

### .yaml professor - Timeout Helm Intall
    Tentantiva com o .yaml do professor também falhou.

    Solução:
    Helm install depois de rodar o eksctl create cluster com a 
    opção --version 1.21 (versão kubernetes) setada.

    Testei testei tanto usando o hc 1.7.0 e 1.6.0, ambos
    funcionaram usando o .yaml do professor.
    
    Obs:
    Tentei rodar hc install com meu .yaml na versão k8s 1.21 e também não funcinou.
    Não gerei .yaml com a versão 1.6.0 do hc, nem comparei os arquivos

> O problema pode estar relacionado ao driver CSI do Amazon EBS. Não me aprofundei
