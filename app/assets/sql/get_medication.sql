-- assets/sql/get_medication.sql

-- Select medication information based on prescription ID
select
    m.id_medication,
    dru.name_drug,
    dos.quantity_dosage
from medication as m
inner join drug as dru on m.id_drug = dru.id_drug
inner join dosage as dos on m.id_dosage = dos.id_dosage
where m.id_prescription = :prescriptionId;



