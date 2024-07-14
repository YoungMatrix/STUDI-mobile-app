-- assets/sql/get_patient_today.sql

-- Select patient ID, prescription ID, and planning ID based on confirmed doctor ID and planning date
select
    h.id_patient,
    p.id_prescription,
    p.id_planning
from history as h
inner join planning as p on h.id_history = p.id_history
where p.id_confirmed_doctor = :doctorId and p.date_planning = :formattedDate;



