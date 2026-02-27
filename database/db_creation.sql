CREATE DATABASE dim_fact_db;
CREATE USER 'airflow'@'%' IDENTIFIED BY 'airflow';
GRANT ALL PRIVILEGES ON dim_fact_db.* TO 'airflow'@'%';
FLUSH PRIVILEGES;

USE dim_fact_db;
SHOW TABLES;