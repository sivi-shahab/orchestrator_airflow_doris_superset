FROM apache/airflow:2.9.2

USER root
# install OpenJDK 17
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# pindah ke user airflow sebelum pip install
USER airflow

# sekarang install Spark‐provider dan PySpark
RUN pip install --no-cache-dir \
    apache-airflow-providers-apache-spark==4.1.3 \
    pyspark==3.4.0 \
    findspark

# set Spark env
ENV SPARK_HOME=/home/airflow/.local/lib/python3.11/site-packages/pyspark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH
