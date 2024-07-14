-- assets/sql/get_doctor_information.sql

-- Select doctor information based on email
SELECT
    d.id_doctor,
    f.name_field,
    d.last_name_doctor,
    d.first_name_doctor,
    d.password_doctor,
    d.salt_doctor
FROM doctor as d
INNER JOIN field as f ON d.id_field = f.id_field
WHERE d.email_doctor = :emailDoctor;
