from datetime import datetime

from airflow import DAG
from airflow.operators.python import ShortCircuitOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

from etl.bootstrap.bootstrap import bootstrap_needed
from etl.common.datasets import (
    raw_forecast_dataset,
    raw_observed_dataset,
)

with DAG(
    dag_id="bootstrap_open_meteo_raw",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    template_searchpath=["/opt/airflow/bootstrap-data"],
) as dag:

    check_bootstrap = ShortCircuitOperator(
        task_id="check_bootstrap_needed",
        python_callable=bootstrap_needed,
    )

    load_forecast = SQLExecuteQueryOperator(
        task_id="load_raw_forecast",
        conn_id="open_meteo",
        sql="raw_forecast.sql",
        outlets=[raw_forecast_dataset],
    )

    load_observed = SQLExecuteQueryOperator(
        task_id="load_raw_observed",
        conn_id="open_meteo",
        sql="raw_observed.sql",
        outlets=[raw_observed_dataset],
    )

    check_bootstrap >> load_forecast >> load_observed
