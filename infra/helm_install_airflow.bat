helm install airflow apache-airflow/airflow ^
    -f ../airflow/custom_values.yaml ^
    --debug