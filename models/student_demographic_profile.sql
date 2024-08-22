{{ config(
  materialized='table'
) }}

    SELECT
        s.category,
        s.stream,
        s.father_name
    FROM
        {{ source('source_postgres', 'student') }} AS s
    where s.category = 'Gen'