{{ config(
  materialized='table'
) }}

WITH enrollment_data AS (
    SELECT
        er.academic_year,
        er.is_current,
        er.start_date AS start_date,
        er.end_date AS end_date,
        er.inserted_at AS record_inserted_at,
        er.updated_at AS record_updated_at,
        er.user_id,
        er.subject_id,
        er.grade_id,
        er.group_type,
        er.group_id
    FROM
        {{ source('source_postgres', 'enrollment_record') }} AS er
    WHERE
        er.is_current = true
)

SELECT
    ed.academic_year,
    ed.is_current,
    ed.start_date,
    ed.end_date,
    ed.record_inserted_at,
    ed.record_updated_at,
    ed.user_id,
    s.name AS subject,
    g.number AS grade,
    ed.group_type,
    COALESCE(b.name, ag.name, sc.name) AS group_name
FROM
    enrollment_data AS ed
    LEFT JOIN {{ source('source_postgres', 'subject') }} AS s ON s.id = ed.subject_id
    LEFT JOIN {{ source('source_postgres', 'grade') }}  AS g ON g.id = ed.grade_id
    LEFT JOIN {{ source('source_postgres', 'batch') }} AS b ON ed.group_type = 'batch' AND b.id = ed.group_id
    LEFT JOIN {{ source('source_postgres', 'auth_group') }} AS ag ON ed.group_type = 'auth_group' AND ag.id = ed.group_id
    LEFT JOIN {{ source('source_postgres', 'school') }}  AS sc ON ed.group_type = 'school' AND sc.id = ed.group_id
