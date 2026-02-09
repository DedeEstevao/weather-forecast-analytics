import hashlib
import json
import logging
import requests
from airflow.providers.postgres.hooks.postgres import PostgresHook

logger = logging.getLogger(__name__)


def extract_open_meteo(latitude: float, longitude: float) -> dict:
    logger.info("Extraindo dados da API Open-Meteo")

    url = (
        "https://api.open-meteo.com/v1/forecast"
        f"?latitude={latitude}"
        f"&longitude={longitude}"
        "&hourly=temperature_2m,precipitation"
    )

    response = requests.get(url, timeout=30)
    response.raise_for_status()

    return response.json()


def load_open_meteo(
    latitude: float,
    longitude: float,
    payload: dict,
    postgres_conn_id: str = "postgres_default",
):
    logger.info("Carregando dados Open-Meteo no Postgres")

    pg_hook = PostgresHook(postgres_conn_id=postgres_conn_id)

    payload_str = json.dumps(payload, sort_keys=True)
    payload_hash = hashlib.sha256(payload_str.encode()).hexdigest()

    insert_sql = """
            INSERT INTO raw.open_meteo_forecast
            (latitude, longitude, payload, payload_hash)
            VALUES (%s, %s, %s, %s)
            ON CONFLICT (latitude, longitude, payload_hash) DO NOTHING;

        """

    pg_hook.run(
        insert_sql,
        parameters=(
            latitude,
            longitude,
            payload_str,
            payload_hash
        ),
    )

    logger.info("Carga Open-Meteo finalizada com sucesso")




