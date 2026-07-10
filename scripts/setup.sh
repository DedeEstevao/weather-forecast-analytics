#!/bin/bash

set -e

# ==========================================================
# Weather Forecast Analytics
# Bootstrap script for local development environment.
# Compatible with Docker Compose V1 and V2.
# ==========================================================

PROJECT_NAME="Weather Forecast Analytics"
PROJECT_SLUG="weather-forecast-test"
echo
echo "======================================================"
echo "   ${PROJECT_NAME}"
echo "   Initializing development environment"
echo "======================================================"
echo
#############################################
# Check Docker
#############################################

echo "Checking Docker..."

if [ ! -d "docker" ]; then
    echo "ERROR: Please run this script from the project root directory."
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo
    echo "ERROR: Docker is not running."
    echo "Start Docker Desktop (Windows) or Docker Engine (Linux)"
    exit 1
fi

echo "Docker is running."

echo

#############################################
# Detect Docker Compose
#############################################

echo "Checking Docker Compose..."

if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    COMPOSE="docker compose"
else
    echo "ERROR: Docker Compose is not installed."
    exit 1
fi

echo "Using Docker Compose:"

$COMPOSE version
echo
echo "Docker project name: $PROJECT_SLUG"
echo

#############################################
# Move to docker directory
#############################################
echo "Changing to docker directory..."

cd docker

#############################################
# Initialize Airflow database
#############################################

echo "Initializing Airflow metadata database (first run only)..."

$COMPOSE -p "$PROJECT_SLUG" --profile init up airflow-init

echo "Airflow metadata database initialized."

echo "Waiting for PostgreSQL..."

sleep 5

echo
#############################################
# Create Airflow admin user
#############################################

echo "Checking Airflow administrator user..."

USERS=$($COMPOSE -p "$PROJECT_SLUG" run --rm airflow-webserver airflow users list 2>/dev/null || true)
if echo "$USERS" | grep -qw "admin"; then

    echo "✓ Administrator user already exists."

else

    echo "Creating administrator user..."

    $COMPOSE -p "$PROJECT_SLUG" run --rm airflow-webserver \
        airflow users create \
            --username admin \
            --password admin \
            --firstname Admin \
            --lastname User \
            --role Admin \
            --email admin@example.com

    echo "✓ Administrator user created."

fi

#############################################
# Start services
#############################################

echo "Starting services..."

$COMPOSE -p "$PROJECT_SLUG" up -d

echo
echo "Waiting for services to start..."
sleep 10

#############################################
# Finish
#############################################

echo
echo "======================================================"
echo "Environment successfully initialized!"
echo "======================================================"
echo
echo "Open your browser:"
echo
echo "Services"
echo "--------"
echo "Airflow  : http://localhost:8080"
echo "Superset : http://localhost:8088"
echo
echo "Default credentials"
echo "-------------------"
echo "Username : admin"
echo "Password : admin"
echo
echo
echo "Setup completed successfully."
echo "You can now access Airflow and Superset using the URLs above."