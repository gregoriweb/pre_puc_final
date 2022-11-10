Rem rodar script da pasta ./infra (caminho -f .yaml relativo)
helm install airflow apache-airflow/airflow ^
    -f ../airflow/custom_values.yaml ^
    --debug