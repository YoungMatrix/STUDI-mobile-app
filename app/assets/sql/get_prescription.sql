-- assets/sql/get_prescription.sql

-- Select prescription information based on its ID
select
    p.id_prescription,
    l.title_label,
    p.date_prescription,
    p.date_start_prescription,
    p.date_end_prescription,
    p.description
from prescription as p
inner join label as l on p.id_label = l.id_label
where p.id_prescription = :prescriptionId;




