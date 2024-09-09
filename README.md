Welcome to your new dbt project!

## Instructions to setup the repo locally
- Take the `profiles.yml` file from someone who has set it up and place it in this repo's folder locally.
- If your setup requires connection with BQ for example, you need a credential JSON file. Take this credential JSON file and place it somewhere on your system (don't place it in this repo's folder). Then you need to update the profiles.yml file with the location of the JSON file
- Create a venv by doing `python3 -m venv venv`
- Activate the venv `source venv/bin/activate` (Or whatever steps windows needs, this is for mac/linux)
- Install libraries
- ```
  python -m pip install \                                                                                                                               ─╯
  dbt-core \
  dbt-postgres \
  dbt-redshift \
  dbt-snowflake \
  dbt-bigquery \
  dbt-trino
  ```
- To run your dbt flow, `dbt run`

### Using the starter project

Try running the following commands:
- dbt run
- dbt test

### End-to-End Data Extraction and Transformation Workflow with Airbyte and dbt

- Data Extraction (Airbyte):

  - Source Configuration: Airbyte connects to various data sources (databases, APIs, cloud applications, etc.)
  - Airbyte extracts raw data from these sources and loads it into a destination such as (BigQuery, PostgreSQL, etc.) in our case it is PostgreSQL into BigQuery
  - Dalgo schedules an Airbyte sync to pull data from source to destination
  - After the sync completes, Dalgo triggers dbt run to transform the newly ingested data according to your dbt models
  - dbt executes the transformations and stores the results in our data warehouse, depending on the materialization strategy

- dbtCore Query Execution and Intermediate Results

    - Where Queries Run:

      - dbt does not have its own execution engine. It compiles SQL queries and sends them to the data warehouse you’re using, which in our case is BigQuery.
      - When you run a dbt command (`dbt run`), dbt compiles models into executable SQL queries and runs them directly on your data warehouse.
      - The actual query execution happens on your data warehouse, not within dbt itself.

- Intermediate Results:

  - dbt models are defined in `.sql` files and can be materialized in several ways:
    - Tables: The result of the query is stored in the data warehouse as a physical table
    - Views: The result is not stored physically; a view is created that references the query
    - Incremental Models: Data is appended to an existing table based on new or updated records
    - Ephemeral Models: These are not stored physically. Instead, the SQL is compiled into a Common Table Expression (CTE) and embedded within the  queries that reference them
    - Materialization Types: The type of materialization (table, view, incremental, or ephemeral) determines how dbt manages intermediate results

- Intermediate Storage:

    - For materializations like tables or views, the results are stored directly in the data warehouse
    - In the case of ephemeral models, intermediate results are not stored physically but exist temporarily as part of the query execution

- Flow in dbt Core:
    - You define a model as a `.sql` file with a SQL query.
    - dbt compiles the model into a runnable SQL query.
    - The query runs directly on your data warehouse.
    - The results, depending on the materialization type, are either stored in a table/view or used temporarily for further query execution.

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices



