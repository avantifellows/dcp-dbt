{{ config(
  materialized='table'
) }}


WITH student_data AS (
    SELECT
        s.student_id,
        s.user_id,
        s.father_name,
        s.father_phone,
        s.mother_name,
        s.mother_phone,
        s.category,
        s.stream,
        s.physically_handicapped,
        s.physically_handicapped_certificate,
        s.family_income,
        s.father_profession,
        s.father_education_level,
        s.mother_profession,
        s.mother_education_level,
        s.time_of_device_availability,
        s.has_internet_access,
        s.primary_smartphone_owner,
        s.guardian_name,
        s.guardian_relation,
        s.guardian_phone,
        s.guardian_education_level,
        s.guardian_profession,
        s.annual_family_income,
        s.monthly_family_income,
        s.family_type,
        s.number_of_four_wheelers,
        s.number_of_two_wheelers,
        s.has_air_conditioner,
        s.goes_for_tuition_or_other_coaching,
        s.know_about_avanti,
        s.percentage_in_grade_10_science,
        s.percentage_in_grade_10_math,
        s.percentage_in_grade_10_english,
        s.grade_10_marksheet,
        s.photo,
        s.planned_competitive_exams,
        g.number AS grade
    FROM
        {{ source('source_postgres', 'student') }} s
    LEFT JOIN
        {{ source('source_postgres', 'grade') }} g ON s.grade_id = g.id
),
user_data AS (
    SELECT
        u.id AS user_id,
        u.first_name,
        u.last_name,
        u.email,
        u.phone,
        u.gender,
        u.address,
        u.city,
        u.district,
        u.state,
        u.pincode,
        u.role,
        u.whatsapp_phone,
        u.date_of_birth,
        u.country
    FROM
        {{ source('source_postgres', 'user') }} u
),
group_user_data AS (
    SELECT
        gu.user_id,
        b.batch_id,
        ag.name AS auth_group_name,
        p.name AS program_name
    FROM
        {{ source('source_postgres', 'group_user') }} gu
    LEFT JOIN
        {{ source('source_postgres', 'group') }} grp ON gu.group_id = grp.id
    LEFT JOIN
        {{ source('source_postgres', 'batch') }} b ON grp.child_id = b.id
    LEFT JOIN
        {{ source('source_postgres', 'auth_group') }} ag ON b.auth_group_id = ag.id
    LEFT JOIN
        {{ source('source_postgres', 'program') }} p ON b.program_id = p.id
    WHERE
        grp.type = 'batch'
),
school_data AS (
    SELECT
        gu.user_id,
        sch.name AS school_name
    FROM
        {{ source('source_postgres', 'group_user') }} gu
    LEFT JOIN
        {{ source('source_postgres', 'group') }} grp ON gu.group_id = grp.id
    LEFT JOIN
        {{ source('source_postgres', 'school') }} sch ON grp.child_id = sch.id
    WHERE
        grp.type = 'school'
)
SELECT
    sd.*,
    ud.first_name,
    ud.last_name,
    ud.email,
    ud.phone,
    ud.gender,
    ud.address,
    ud.city,
    ud.district,
    ud.state,
    ud.pincode,
    ud.role,
    ud.whatsapp_phone,
    ud.date_of_birth,
    ud.country,
    gud.batch_id,
    gud.auth_group_name,
    gud.program_name,
    sd.grade,
    us.school_name
FROM
    student_data sd
LEFT JOIN
    user_data ud ON sd.user_id = ud.user_id
LEFT JOIN
    group_user_data gud ON sd.user_id = gud.user_id
LEFT JOIN
    school_data us ON sd.user_id = us.user_id
