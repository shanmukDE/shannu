# Snowflake Data Engineering & Analytics Platform

GitHub-ready reference project demonstrating automated ingestion from AWS S3 into Snowflake, incremental processing, dbt transformations, dimensional modeling, data quality, Power BI-ready marts, and secure sharing.

## Architecture

`AWS S3 -> Snowflake Stage/Snowpipe -> RAW -> Stream/Task -> STAGING -> dbt -> ANALYTICS -> Power BI / Secure Share`

The sample domain is retail orders with customers, products, and order lines. JSON order events land in `RAW.ORDERS_RAW`; CSV reference data lands in customer and product tables.

## Repository structure

- `snowflake/`: roles, warehouse, database, stages, Snowpipe, Streams, Tasks, secure views, and sharing
- `dbt/`: staging, intermediate, dimension, fact, and reporting models plus tests
- `sample_data/`: small local files that can be uploaded to the configured S3 prefixes
- `.github/workflows/`: dbt CI validation

## Prerequisites

- Snowflake account with permission to create databases, warehouses, roles, storage integrations, and pipes
- AWS S3 bucket and IAM role trusted by Snowflake
- Python 3.10+
- dbt-snowflake

## Setup

1. Copy `.env.example` to `.env` and fill in local values. Never commit `.env`.
2. Replace the placeholders in `snowflake/01_storage_integration.sql`.
3. Run SQL files `00` through `05` as an administrator. After creating the storage integration, update the AWS IAM trust policy with the returned Snowflake IAM user ARN and external ID.
4. Upload `sample_data/orders/*.json` to `s3://<bucket>/orders/` and the CSV files to their matching prefixes.
5. Copy `dbt/profiles.yml.example` to `~/.dbt/profiles.yml` and export the required environment variables.
6. Run:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cd dbt
dbt deps
dbt debug
dbt build
```

## Validation queries

```sql
SELECT * FROM SNOWFLAKE_DEMO.ANALYTICS.FCT_ORDERS ORDER BY ORDER_TS DESC;
SELECT * FROM SNOWFLAKE_DEMO.ANALYTICS.RPT_DAILY_SALES ORDER BY ORDER_DATE DESC;
SELECT * FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
  TABLE_NAME => 'SNOWFLAKE_DEMO.RAW.ORDERS_RAW',
  START_TIME => DATEADD('hour', -24, CURRENT_TIMESTAMP())
));
```

## Security

No passwords, private keys, account identifiers, or AWS secrets belong in this repository. GitHub Actions expects Snowflake configuration in repository secrets.

