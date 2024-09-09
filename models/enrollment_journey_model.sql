{{ config(
  materialized='table'
) }}

/* 
Define a CTE (Common Table Expression) to extract and structure the enrollment data
*/

WITH enrollment_data AS (
    SELECT
        enrollment_record.academic_year,
        enrollment_record.is_current,
        enrollment_record.start_date,
        enrollment_record.end_date,
        enrollment_record.inserted_at AS record_inserted_at,
        enrollment_record.updated_at AS record_updated_at,
        enrollment_record.user_id,
        enrollment_record.subject_id,
        enrollment_record.grade_id,
        enrollment_record.group_type,
        enrollment_record.group_id
    FROM
        {{ source('source_postgres', 'enrollment_record') }}
)

/*
In main query join enrollment data with subject, grade, batch, auth_group, school, user, and student tables
*/

SELECT
    enrollment_data.academic_year,
    enrollment_data.is_current,
    enrollment_data.start_date,
    enrollment_data.end_date,
    enrollment_data.record_inserted_at,
    enrollment_data.record_updated_at,
    enrollment_data.user_id,
    subject.name AS subject,
    grade.number AS grade,
    enrollment_data.group_type,
    COALESCE(batch.name, auth_group.name, school.name) AS group_name,
    user.gender,
    user.date_of_birth,
    user.first_name, 
    user.last_name,
    student.category,
    student.student_id
FROM
    enrollment_data
    LEFT JOIN {{ source('source_postgres', 'subject') }} AS subject ON subject.id = enrollment_data.subject_id
    LEFT JOIN {{ source('source_postgres', 'grade') }}  AS grade ON grade.id = enrollment_data.grade_id
    LEFT JOIN {{ source('source_postgres', 'batch') }} AS batch ON enrollment_data.group_type = 'batch' AND batch.id = enrollment_data.group_id
    LEFT JOIN {{ source('source_postgres', 'auth_group') }} AS auth_group ON enrollment_data.group_type = 'auth_group' AND auth_group.id = enrollment_data.group_id
    LEFT JOIN {{ source('source_postgres', 'school') }}  AS school ON enrollment_data.group_type = 'school' AND school.id = enrollment_data.group_id
    LEFT JOIN {{ source('source_postgres', 'school') }} AS status ON enrollment_data.group_type = 'status' AND status.id = enrollment_data.group_id
    LEFT JOIN {{ source('source_postgres', 'user') }} AS user ON enrollment_data.user_id = user.id
    LEFT JOIN {{ source('source_postgres', 'student') }} AS student ON user.id = student.user_id
