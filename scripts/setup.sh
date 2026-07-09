#!/bin/bash

set -e

#############################################
# Weather Forecast Analytics
# Project Setup Script
#############################################

PROJECT_NAME="Weather Forecast Analytics"

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

if ! docker info >/dev/null 2>&1; then
    echo
    echo "ERROR: Docker is not running."
    echo "Start Docker Desktop (Windows) or Docker Engine (Linux)"
    exit 1
fi

echo "Docker is running."
echo

#############################################
# Check Docker Compose
#############################################

if ! docker compose version >/dev/null 2>&1; then
    echo "ERROR: Docker Compose is not installed."
    exit 1
fi

echo "Docker Compose found."
echo

#############################################
# Move to docker directory
#############################################

cd docker

#############################################
# Initialize Airflow database
#############################################

echo "Initializing Airflow metadata database..."

docker compose --profile init up airflow-init

echo

#############################################
# Create Airflow admin user
#############################################

echo "Checking Airflow administrator user..."

if docker compose run --rm airflow-webserver \
    airflow users list | grep -q "^admin\b"; then

    echo "✓ Administrator user already exists."

else

    echo "Creating administrator user..."

    docker compose run --rm airflow-webserver \
        airflow users create \
            --username admin \
            --password admin \
            --firstname Admin \
            --lastname User \
            --role Admin \
            --email admin@example.com

    echo "✓ Administrator user created."
    
#############################################
# Start services
#############################################

echo "Starting services..."

docker compose up -d

echo

#############################################
# Wait a little
#############################################

sleep 10

#############################################
# Finish
#############################################

echo
echo "======================================================"
echo "Environment successfully initialized!"
echo "======================================================"
echo
echo "Services"
echo "--------"
echo "Airflow  : http://localhost:8080"
echo "Superset : http://localhost:8088"
echo
echo "Credentials"
echo "-----------"
echo "Username : admin"
echo "Password : admin"
echo
echo "Enjoy!"