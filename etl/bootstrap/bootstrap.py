from airflow.providers.postgres.hooks.postgres import PostgresHook
import logging


def bootstrap_needed():

    hook = PostgresHook(postgres_conn_id="open_meteo")

    forecast_count, observed_count = hook.get_first(
        """
        SELECT
            (SELECT COUNT(*) FROM raw.weather_forecast),
            (SELECT COUNT(*) FROM raw.weather_observed)
        """
    )

    logging.info(
        "Forecast rows: %s | Observed rows: %s",
        forecast_count,
        observed_count,
    )

    # Banco vazio: executar bootstrap
    if forecast_count == 0 and observed_count == 0:
        logging.info(
            "RAW tables are empty. Bootstrap will be executed."
        )
        return True

    # Banco já populado: não executar
    if forecast_count > 0 and observed_count > 0:
        logging.info(
            "RAW tables already contain data. Bootstrap skipped."
        )
        return False

    # Estado inconsistente
    raise ValueError(
        f"Inconsistent RAW tables. "
        f"Forecast rows={forecast_count}, "
        f"Observed rows={observed_count}."
    )
