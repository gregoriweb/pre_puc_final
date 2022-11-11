teste 1 - K8s 1.2.1, helm chart 1.7.0, arquivo ney, funcionou
	helm install airflow apache-airflow/airflow -f .\custom_values_gregori.yaml -n airflow-170-gregori --create-namespace --version 1.7.0 --debug

	kubectl get svc -n airflow-170-gregori

# Deploy EKS - Cluster de máquinas Kubernetes 
`eksctl create cluster ^
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
    --nodegroup-name=ng-kbgregori`
	

# Deletar o cluster 
  - Antes deletar o loadbalancer 
      Buscar svcs
      `kubectl get svc -n namespace`
      Deletar svc loadbalance (com ipexterno)
      `kubectl delete svc airflow-webserver -n airflow16`
    
    Ou

      Deletar o helm
      `helm delete airflow --namespace airflow`

  - Remover o cluster
    `eksctl delete cluster --region=us-east-2 --name=kbgregori`

# Show kubernetes contexts 
`kubectl.exe config get-contexts`

# show current context
`kubectl config current-context`

# Swith kubernetes contexts 
`kubectl config use-context airflow-user@kbgregori2.us-east-2.eksctl.io`

# Show cluster pods, svc, pvc no namespace airflow
`kubectl get pods,svc,pvc -n airflow`

# Show svcs para depois deletar os loadbalancers antes de derrubar o cluster
`kubectl get svc --all-namespaces`

# Gerar yaml helm
`helm show values apache-airflow/airflow >> custom_values.yaml`

# Instalar airflow do helm (arquivo do professor funciona, o gerado do show values não)
`helm install airflow apache-airflow/airflow -f infra\custom_values.yaml -n airflow --create-namespace --version 1.7.0 --debug`

# Deletar helm
`helm delete airflow --namespace airflow`