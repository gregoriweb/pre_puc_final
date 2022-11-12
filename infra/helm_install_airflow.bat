@echo Inicio: %date% %time%

helm install airflow apache-airflow/airflow ^
    -f airflow_custom_values.yaml ^
    -n airflow7 ^
    --create-namespace ^
    --version 1.7.0 ^
    --timeout 5m ^
    --debug

@echo Completed: %date% %time%