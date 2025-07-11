# Projek Freedom Open Source - Building Data Pipeline using Airflow & Doris

 ![Alt text](https://github.com/projekdos/orchestrator_workshop_airflow_doris_batch1/blob/main/image/header.png)

This hands-on workshop Prepared by Frederik Stefanus & Wandhana Kurnia that participants can learn :

 - Introduction to Data Pipelines with Apache Airflow
 - Mapping Data Sources Using ERD
 - Ingesting and Transforming CSV, JSON Data with Doris SQL
 - Automating Load & Transform Scripts in Doris
 - Building Medallion Architecture (Raw, Refined, Business Layer)
 - Datasets: Equity, Crypto, and Forex Trade Exchange (dummy data)

## Pipeline Anatomy

This architecture follows the Medallion (Bronze-Silver-Gold) structure with clear data flow across layers for structured (CSV) and semi-structured data (JSON). It enables end-to-end transformation from raw data to actionable insights.

  ![Alt text](https://github.com/projekdos/orchestrator_workshop_airflow_doris_batch1/blob/main/image/pipeline-anatomy.png)

# Quiz Challenge

![Alt text](https://github.com/projekdos/orchestrator_workshop_airflow_doris_batch1/blob/main/image/coingecko.avif)
![Alt text](https://github.com/projekdos/orchestrator_workshop_airflow_doris_batch1/blob/main/image/quiz-json.png)

## Coingecko Crypto Analytics – Data Pipeline Quiz

This challenge tests your skills in building a complete **data pipeline** using top-1000 crypto token data from **[Coingecko](https://www.coingecko.com/)**.

### 🔍 About Cryptocurrency Analytics

With thousands of tokens traded globally, investors and analysts rely on **crypto analytics** to track market trends, identify top-performing tokens, and assess volatility.  

This quiz simulates a **real-world use case**: building a data pipeline that processes token data and produces insights

1. Read Source File
   - Analyze **quiz/files/coingecko_grouped_top_1000_tokens.json** structure & fields.

2. Understand Pipeline Mapping
   - Read & Analyze **quiz/mapping/Mapping-Quiz-Coingecko_Crypto_Analytics.xlsx**
   - Define Bronze (raw), Silver (cleaned), Gold (business insights).

3. Create DDL in Doris
   - Design tables for Bronze, Silver, and Gold layers based on Mapping.

4. Stream Load to Bronze
   - Use Doris **STREAM LOAD** to ingest raw JSON.

5. SQL ETL (Silver & Gold)
   - Extract fields, clean data (Silver) based on Mapping.
   - Aggregate insights (Gold) based on Mapping.

6. Build Airflow DAG
   - Automate Bronze → Silver → Gold with Airflow.

7. Add Visualization [Is a Plus] 
 Create dashboards using Data Visualization Tools. eg: MatplotLib, Looker Studio, or Power BI.

8. Push to GitHub + Document
   - Include DDL, SQL, DAGs, and a clear **README.md**.

9. Email Submission
   - Send GitHub link to:
     **info@projekdos.com**, **projek.freedomopensource@gmail.com**

10. Win by Speed + Accuracy
   - First correct submission gets the prize.

Your job is to transform raw market data into **actionable insights** for traders, analysts, or BI dashboards.

# Business Partnership & Collaboration Contact

Contact:
 - Email: info@projekdos.com
 - Whatsapp: +6281385368844 (Admin)
 - Linkedin: https://www.linkedin.com/company/projek-dos/
 - Youtube: https://www.youtube.com/@wndktech

 ![Alt text](https://github.com/projekdos/orchestrator_workshop_airflow_doris_batch1/blob/main/image/projeckDos2-fullcolor-white.png)