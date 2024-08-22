SELECT f.*,
    us.name AS school_name
FROM (
    SELECT
        s.student_id,
        s.user_id,
        u.first_name,
        u.last_name,
        u.email,
        g.number AS grade,
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
        u.country,
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
        ug.batch_id,
        ug.auth_group_name,
        ug.program_name
    FROM
        {{ source('source_postgres', 'student') }} AS s
    LEFT JOIN  {{ source('source_postgres', 'user') }} AS u ON s.user_id = u.id
    LEFT JOIN  {{ source('source_postgres', 'grade') }} AS g ON s.grade_id = g.id
    LEFT JOIN (
        SELECT
            gu.user_id,
            b.batch_id,
            ag.name AS auth_group_name,
            p.name AS program_name
        FROM
            {{ source('source_postgres', 'group_user') }} AS gu
        LEFT JOIN  {{ source('source_postgres', 'group') }} AS grp ON gu.group_id = grp.id
        LEFT JOIN  {{ source('source_postgres', 'batch') }} AS b ON grp.child_id = b.id
        LEFT JOIN  {{ source('source_postgres', 'auth_group') }} AS ag ON b.auth_group_id = ag.id
        LEFT JOIN  {{ source('source_postgres', 'program') }} AS p ON b.program_id = p.id
        WHERE
            grp.TYPE = 'batch'
    ) AS ug ON u.id = ug.user_id
) AS f
LEFT JOIN (
    SELECT
        gu.user_id,
        sch.name
    FROM
        {{ source('source_postgres', 'group_user') }} AS gu
    LEFT JOIN  {{ source('source_postgres', 'group') }} AS grp ON gu.group_id = grp.id
    LEFT JOIN  {{ source('source_postgres', 'school') }} AS sch ON grp.child_id = sch.id
    WHERE
        grp.type = 'school'
) AS us ON f.user_id = us.user_id
