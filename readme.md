**[Thanks Projek Freedom Open Source](https://github.com/projekdos/orchestrator_workshop_airflow_doris_batch1)**

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