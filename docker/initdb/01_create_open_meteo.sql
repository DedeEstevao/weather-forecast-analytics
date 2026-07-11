SELECT 'CREATE DATABASE open_meteo'
WHERE NOT EXISTS (
    SELECT 1
    FROM pg_database
    WHERE datname = 'open_meteo'
)\gexec
