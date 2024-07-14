-- assets/sql/send_patient_information.sql

-- Start transaction
START TRANSACTION;

-- Select all label id based on label titles (1)
select id_label from label where title_label = :labelTitle;

-- Select all drug id based on drug names (2)
select id_drug from drug where name_drug = :drugName;

-- Select all dosage id based on dosage quantities (3)
select id_dosage from dosage where quantity_dosage = :dosageQuantity;

-- Select the history ID, confirmed doctor ID, and prescription ID from the planning
-- table where the planning ID matches the provided parameter (4)
select id_history, id_confirmed_doctor, id_prescription
from planning
where id_planning = :planningId and date_planning = :date;

-- Select the planning dates from the planning table where
-- the history ID matches the provided parameter, ordered by date in ascending order (5)
select date_planning
from planning
where id_history = :historyId
order by date_planning asc;

-- Update history with end date (6)
update history set id_doctor = :doctorId, date_release = :endDate where id_history = :historyId;

-- Delete from planning (7)
delete from planning where id_history = :historyId;

-- Reset the AUTO_INCREMENT value for the planning table (8)
alter table planning AUTO_INCREMENT = 1;

-- Insert into planning (9)
insert into planning (id_history, id_confirmed_doctor, id_prescription, date_planning)
values (:historyId, :confirmedDoctorId, :prescriptionId, :date);

-- If patient.prescription != null:

-- Update prescription details (10)
update
    prescription
set id_label = :labelId, date_prescription = :prescriptionDate,
    date_start_prescription = :startDate, date_end_prescription = :endDate,
    description = :prescriptionDescription
where id_prescription = :prescriptionId;

-- Delete previous medication entries for the prescription (11)
delete from medication where id_prescription = :prescriptionId;

-- Reset the AUTO_INCREMENT value for the medication table (12)
alter table medication AUTO_INCREMENT = 1;

-- Check if the medication entry already exists (13)
select count(*)
from medication
where id_prescription = :prescriptionId and id_drug = :drugId and id_dosage = :dosageId;

-- Insert new medication entries (14)
insert into medication (id_prescription, id_drug, id_dosage)
values (:prescriptionId, :drugId, :dosageId);

-- If patient.prescription == null:

-- Insert into prescription table (15)
insert into prescription (id_label, date_prescription,
        date_start_prescription, date_end_prescription, description)
values (:labelId, :prescriptionDate, :startDate, :endDate, :prescriptionDescription);

-- Get the ID of the inserted prescription using the details (16)
select id_prescription
from prescription
where id_label = :labelId and
        date_prescription = :prescriptionDate and
        date_start_prescription = :startDate and
        date_end_prescription = :endDate and
        description = :prescriptionDescription;

-- Update planning table (17)
update planning set id_prescription = :prescriptionId where id_history = :historyId;

-- Commit transaction
commit;