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


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
