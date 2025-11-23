create schema hospital;

set search_path to hospital;

show search_path;

select * from admissions;
select * from appointments;
select * from bills;
select * from doctors;
select * from nurses;
select * from patients;
select * from payments;
select * from prescriptions;
select * from treatments;
select * from wards;

 -- 1. Retrieve the list of all male patients who were born after 1990, including their patient ID, first
 -- name, last name, and date of birth.

select 
     "PatientID",
     "FirstName",
     "LastName",
     "DateOfBirth"
from patients
where "Gender" = 'M'
     and "DateOfBirth" > '1990-01-02';

-- 2. Produce a report showing the ten most recent appointments in the system, ordered from the
-- newest to the oldest.

select 
    "AppointmentID",
    "PatientID",
    "DoctorID",
    "AppointmentDate",
    "Status",
    "NurseID"
FROM Appointments
ORDER BY "AppointmentDate" DESC
LIMIT 10;

--3 Generate a report that shows all appointments along with the full names of the patients and
-- doctors involved.

select 
     a."AppointmentID",
     a."PatientID",
     a."Status",
     a."PatientID",
concat(p."FirstName", ' ', p."LastName") as PatientFullName,
a."DoctorID",
concat(d."FirstName", ' ', d."LastName")
from appointments a 
join patients p on a."PatientID" = p."PatientID" 
join doctors d on a."DoctorID" = d."DoctorID" 
order by a."AppointmentDate" desc;

-- 4. Prepare a list that shows all patients together with any treatments they have received, ensuring
-- that patients without treatments also appear in the results.

select 
      p."PatientID",
      concat(p."FirstName", ' ', p."LastName") as PatientFullName,
      t."TreatmentID",
      t."TreatmentType",
      t."Outcome"
from patients p 
left join appointments a on p."PatientID" = a."PatientID" 
left join treatments t on a."AppointmentID" = t."AppointmentID" 
order by p."PatientID";

--5. Identify any treatments recorded in the system that do not have a matching appointment.

select 
      t."TreatmentID",
      t."AppointmentID",
      t."TreatmentType",
      t."Outcome" 
from treatments t 
left join appointments a on t."AppointmentID" = a."AppointmentID" 
where a."AppointmentID" is null;

-- 6. Create a summary that shows how many appointments each doctor has handled, ordered from
-- the highest to the lowest count.

select 
      d."DoctorID",
      concat(d."FirstName", ' ', d."LastName") as DoctorFullName,
      count(a."AppointmentID") as TotalAppointments
from doctors d 
left join appointments a on d."DoctorID" = a."DoctorID" 
group  by d."DoctorID", doctorfullname 
order by totalappointments desc;

-- 7. Produce a list of doctors who have handled more than twenty appointments, showing their
-- doctor ID, specialization, and total appointment count.

select 
      d."DoctorID",
      d."Specialization",
      count(a."AppointmentID") as TotalAppointments
from doctors d 
left join appointments a on d."DoctorID" = a."DoctorID"
group by d."DoctorID", d."Specialization" 
having count(a."AppointmentID" ) > 20
order by totalappointments desc;


-- 8. Retrieve the details of all patients who have had appointments with doctors whose
-- specialization is “Cardiology.”

select 
     p."PatientID",
     concat(p."FirstName", ' ', p."LastName") as PatientFullName,
     p."Gender",
     p."DateOfBirth" 
from patients p
join appointments a on p."PatientID" = a."PatientID" 
join doctors d on a."DoctorID" = d."DoctorID" 
where d."Specialization" = 'Cardiology';

-- 9. Produce a list of patients who have at least one bill that remains unpaid.

select 
      p."PatientID",
      concat(p."FirstName", ' ', p."LastName") as PatientFullName,
      p."Gender",
      p."DateOfBirth" 
from patients p 
join admissions a on p."PatientID" = a."PatientID" 
join bills b on a."AdmissionID" = b."AdmissionID" 
where b."OutstandingAmount" > 0;

-- 10 Retrieve all bills whose total amount is higher than the average total amount for all bills in
-- the system.
-- in this question we shall use a subquery

select 
      b."BillID",
      b."AdmissionID",
      b."TotalAmount", 
      b."PaidAmount",
      b."OutstandingAmount" 
from bills b 
WHERE b."TotalAmount" > (select AVG(b."TotalAmount" )from bills b );

-- 11. For each patient in the database, identify their most recent appointment and list it along with
-- the patient’s ID.

select 
      a."PatientID",
      a."AppointmentID",
      a."AppointmentDate",
      a."DoctorID",
      a."Status" 
from appointments a 
where a."AppointmentDate" = (
     select MAX(a2."AppointmentDate")
     from appointments a2 
     where a2."PatientID" = a."PatientID" 
);

-- 15. Build a query that identifies all patients who currently have an outstanding balance, based on
-- information from admissions and billing records.

select 
      p."PatientID",
      concat(p."FirstName", ' ', p."LastName") as PatientFullName,
      SUM(b."OutstandingAmount") as total_outstanding
from patients p 
join admissions ad on p."PatientID" = ad."PatientID" 
join bills b on ad."AdmissionID" = b."AdmissionID" 
group by p."PatientID", patientfullname 
having SUM(b."OutstandingAmount") > 0
order by total_outstanding desc;

-- 17. Add a new patient record to the Patients table, providing appropriate information for all
-- required fields.

insert into patients (
  "PatientID",
  "FirstName",
  "LastName",
  "Gender",
  "DateOfBirth",
  "Email",
  "PhoneNumber"
) values(
  'P9999',
  'Felix',
  'Kenyansa',
  'M',
  '1990-04-02',
  'felixkenyansa@yahoo.com',
  '555-01999'
);

-- 18. Modify the appointments table so that any appointment with a NULL status is updated to
-- show “Scheduled.”
update appointments a 
set "Status" = 'Scheduled'
where a."Status" is null;

-- 19. Remove all prescription records that belong to appointments marked as “Cancelled.”

delete from prescriptions 
where "AppointmentID" in (
   select "AppointmentID"
   from appointments a 
   where a."Status" = 'Cancelled'
);


      
