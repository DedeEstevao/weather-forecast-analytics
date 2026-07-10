# ===============================
# Airflow base image
# ===============================
ARG AIRFLOW_VERSION=2.9.0
ARG PYTHON_VERSION=3.10

FROM apache/airflow:${AIRFLOW_VERSION}-python${PYTHON_VERSION}

ARG AIRFLOW_VERSION

# Copia project dependecies
COPY requirements.txt /requirements.txt

# Install Python dependencies using the official Airflow constraints
RUN pip install --no-cache-dir \
    --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-3.10.txt" \
    -r /requirements.txt

# PYTHONPATH para importar etl/, sql/, etc
ENV PYTHONPATH=/opt/airflow
