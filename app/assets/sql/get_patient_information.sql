-- assets/sql/get_patient_information.sql

-- Select patient information based on their ID
select
p.last_name_patient,
p.first_name_patient
from patient as p
where p.id_patient = :patientId;