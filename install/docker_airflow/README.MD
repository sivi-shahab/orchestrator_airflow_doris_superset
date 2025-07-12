===========Installation Guide for Docker Airflow============

1. Assume you already install docker and docker compose

2. Execute this command from your terminal inside this directory path:
docker build -t airflow-spark:2.9.2 .

3.Execute this command from your terminal inside this directory path:
a. sudo chown -R 1000:1000 logs dags plugins
b. chmod 777 logs
c. docker-compose run --rm airflow-init \
  airflow users create \
    --username admin \
    --firstname Admin \
    --lastname User \
    --role Admin \
    --email admin@example.com \
    --password admin
d. docker-compose build airflow-scheduler
e. docker-compose up -d
note:
docker exec -it $(docker ps -qf "name=airflow-webserver") bash
airflow users list
if empty user, make new user
airflow users create \
  --username admin \
  --firstname Admin \
  --lastname User \
  --role Admin \
  --email admin@example.com \
  --password admin




4. Open the Airflow Web UI through 'localhost:8088'

5. Put your DAG inside the `dags` folder
