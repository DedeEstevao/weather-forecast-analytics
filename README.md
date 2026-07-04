
# Weather Forecast Analytics

> End-to-end Data Engineering project for weather forecasting analytics and forecast quality monitoring.

## Overview

**Weather Forecast Analytics** is an end-to-end data pipeline designed to ingest, transform, store, and visualize weather forecast data while evaluating the quality of predictions against observed weather conditions.

The project demonstrates a modern Data Engineering workflow using containerized services, orchestration, dimensional data modeling, and Business Intelligence dashboards.

---
## Project Highlights

- End-to-end weather data pipeline
- Automated orchestration with Apache Airflow
- Layered PostgreSQL data warehouse
- Forecast verification using observed weather data
- Interactive Apache Superset dashboards
- Dockerized development environment
---
# Architecture

The solution follows a modern end-to-end data engineering architecture, orchestrating weather data ingestion, transformation, storage, and visualization through a layered PostgreSQL warehouse and Apache Superset dashboards.

![Architecture](docs/images/Architecture.png)

---
# Tech Stack

| Component             | Technology              |
| --------------------- | ----------------------- |
| Programming Language  | Python                  |
| Orchestration         | Apache Airflow          |
| Database              | PostgreSQL              |
| Business Intelligence | Apache Superset         |
| Containerization      | Docker & Docker Compose |
| Transformations       | SQL                     |
| Version Control       | Git & GitHub            |

---
# Project Structure

<p align="left">
  <img src="docs/images/tree.png" alt="Project Structure" 
width="400">
</p>



---
# Pipeline Airflow

<p align="center">
  <img src="docs/images/pipeline.drawio.svg" alt="Weather Forecast Analytics Architecture" width="650">
</p>

---
# Data Pipeline

The pipeline performs the following steps:

1. Extract weather forecast data
2. Extract observed weather data
3. Load raw datasets into PostgreSQL
4. Transform and standardize the data
5. Build analytical marts
6. Generate forecast quality metrics
7. Visualize results in Superset dashboards

---
# Data Model
The data model follows a layered architecture designed to ensure data quality, traceability, and efficient analytical reporting. Weather data progresses through multiple stages, from raw API ingestion to business-ready datasets consumed by Apache Superset dashboards.

The architecture is organized into four logical layers:

## RAW

The RAW layer stores the original responses retrieved from the Open-Meteo API without any business transformations.

It preserves the complete JSON payload together with ingestion metadata, providing:

Complete data lineage
Historical traceability
Payload deduplication using hashes
Reliable reprocessing capabilities

**Tables**  

- raw.weather_forecast
- raw.weather_observed

## STAGING

The STAGING layer transforms raw JSON payloads into structured relational tables.

During this stage, nested weather variables are extracted, standardized, validated, and prepared for downstream analytical processing.

**Tables**

- staging.weather_forecast
- staging.weather_observed

## MART

The MART layer contains curated datasets designed for analytical consumption.

It includes:

Weather Forecast — standardized forecast records.
Weather Forecast Verification — comparison between forecast and observed weather conditions, including forecast timing, lead time, and forecast verification metrics.

**Tables**

- mart.weather_forecast
- mart.weather_forecast_verification

## ANALYTICS

The ANALYTICS layer provides business-oriented datasets optimized for dashboards and reporting.

The Weather Daily dataset aggregates daily forecast information, including temperature statistics, precipitation probability, and rainfall metrics, enabling fast dashboard queries in Apache Superset.

**Tables**

- analytics.weather_daily

Design Note: The separation between RAW, STAGING, MART, and ANALYTICS follows modern data engineering practices, improving maintainability, auditability, and scalability while keeping analytical datasets optimized for business intelligence and forecast verification.

<p align="center">
  <img src="docs/images/Data Warehouse Weather.drawio.svg" alt="Weather Forecast Analytics 
Architecture" width="650">
</p>

These two analytical tables, each optimized for a specific business purpose:

### Weather Forecast Verification
 This table stores the comparison between forecasted and observed weather conditions, enabling forecast quality assessment through error metrics such as temperature and rainfall deviations. It also includes forecast timing information (model run, forecast time, and lead time) to support forecast verification analysis.

### Weather Daily
 This table provides daily aggregated weather statistics derived from forecast data, including average, minimum, and maximum temperature, precipitation probability, and rainfall totals. This dataset is optimized for business reporting and daily weather dashboards.

The model follows a layered data architecture in PostgreSQL, where raw weather data is standardized and transformed before being exposed through analytical datasets consumed by Apache Superset dashboards.



---
# 📈 Dashboards

Apache Superset is used to provide interactive dashboards for weather monitoring, forecast exploration, and forecast verification.

All dashboards support interactive filtering by City and Forecast Date, allowing users to explore weather conditions and forecast verification results dynamically.

The dashboards are built on the analytical datasets generated by the pipeline and enable users to:

- Monitor daily weather conditions by city
- Analyze forecast temperature trends
- Explore precipitation forecasts
- Compare precipitation probability across locations
- Evaluate forecast quality using verification metrics

## Weather Forecast Analysis
Built on the **analytics.weather_daily** provides an overview of weather conditions across multiple cities.

### KPIs

* Average Maximum Temperature (°C)
* Average Minimum Temperature (°C)
* Average Rain (mm)

### Visualizations

* Maximum Temperature by City (°C)
* Minimum Temperature by City (°C)
* Precipitation by City (mm)
* Precipitation Probability by City (%)

<p align="center">
  <img src="docs/images/forecast-overview.jpg" alt="Weather Forecast Analytics 
Architecture" width="650">
</p>

## Forecast Model Performance Analysis

The Forecast Verification Dashboard provides a comprehensive evaluation of forecast performance by comparing predicted weather conditions against observed measurements.

Built on the **mart.weather_forecast_verification dataset**, it enables users to monitor forecast quality, identify systematic biases, and analyze how forecast accuracy changes across cities and forecast lead times.

This dashboard supports forecast verification, model performance analysis, and continuous monitoring of prediction quality, providing actionable insights for evaluating weather forecasting reliability.


### Mean Absolute Temperature Error (MAE)

Measures the average magnitude of prediction errors.

```
MAE = AVG(ABS(predicted_temperature - observed_temperature))
```

Lower values indicate better model performance.


### Mean Absolute Rain Error

Measures the average difference between predicted and observed precipitation.

```
MAE_rain = AVG(ABS(predicted_rain - observed_rain))
```

### Temperature Forecast Bias

Measures whether the model systematically overestimates or underestimates temperature.

```
Bias = AVG(predicted_temperature - observed_temperature)
```

Interpretation:

* Positive → model tends to overestimate temperature
* Negative → model tends to underestimate temperature
* Zero → unbiased predictions


### Visualizations


  * Forecast vs Observed Comparison - Side-by-side comparison of forecasted and observed 
temperature and rainfall across multiple cities.
  * Lead Time Analysis – Evaluation of forecast error as the forecast horizon increases, helping 
assess model degradation over time.
  * City-Level Performance – Comparison of forecast errors between cities, highlighting spatial 
differences in forecast performance.


<p align="center">
  <img src="docs/images/model-performance-analysis.jpg" alt="Weather Forecast Analytics 
Architecture" width="650">
</p>

---
# Learning Objectives

This project demonstrates practical experience with:

* ETL pipeline development
* Workflow orchestration
* SQL-based data transformations
* Analytical data modeling
* Business Intelligence dashboards
* Forecast quality monitoring
* Containerized development environments

---
# Future Improvements

* dbt integration for data transformations
* Automated data quality tests
* CI/CD pipeline
* Unit and integration testing
* Cloud deployment

---
# Running Locally

### Instalation

1. Clone the repository.
2. Navigate to the `docker` directory.
3. Start PostgreSQL and initialize Airflow:
   ```bash
   docker compose --profile init up airflow-init
   ```
4. Start all services:
   ```bash
   docker compose up -d
   ```
5. Available Services:

    After the containers are running, the following services are available:

    | Service | URL | Purpose |
    |----------|-----|---------|
    |   **Apache Airflow** | http://localhost:8080 | Pipeline orchestration and monitoring |
    |   **Apache Superset** | http://localhost:8088 | Weather analytics and forecast verification   dashboards |
    |   **PostgreSQL** | localhost:5432 | Layered analytical data warehouse |


---
# Author

Data Engineering portfolio project focused on modern data pipelines, analytics, and forecast quality evaluation.

