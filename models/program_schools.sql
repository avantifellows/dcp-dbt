{{ config(
  materialized='table'
) }}

SELECT 
    id,
    code,
    name,
    board,
    state,
    region,
    user_id,
    district,
    block_code,
    block_name,
    state_code,
    udise_code
FROM 
    {{ source('source_postgres', 'school') }}
