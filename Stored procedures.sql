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

-- 20. Create a stored procedure that adds a new record to the Doctors table.
-- The procedure should accept the doctor’s ID, first name, last name, specialization, email, and
-- phone number as input parameters.
-- After creating the procedure, call it using a set of sample doctor details to insert a new doctor
-- into the database.

-- creating the procedure

create procedure add_doctor(
      p_doctor_id      TEXT,
      p_first_name     TEXT,
      P_last_name      TEXT,
      p_specialization TEXT,
      p_email          TEXT,
      P_phone          TEXT
)
language plpgsql
as $$
begin
	insert into doctors d (
	   d."DoctorID", d."FirstName", d."Specialization", d."Email", d."PhoneNumber"
	) values (
	  p_doctor_id, p_first_name, p_last_name, p_specialization, p_email, p_phone
	);
exception 
   when unique_violation then
     raise notice 'Doctor ID % already exists; insert skipped.', p_doctor_id;
end;
$$;

-- we will call the procedure with simple doctor details (succesful insert)

call add_doctor (
   'D9999', 'Grace', 'Mwangi', 'Cardiology',
   'grace.mwangi@example', '555-02999'
);

-- 21. Create a stored procedure that records a new appointment and automatically performs
--validation before inserting.
--The procedure should accept an appointment ID, patient ID, doctor ID, appointment date, status,
--and nurse ID.
--Inside the procedure, implement the following logic:
--* Verify that the patient exists in the Patients table.
--* Verify that the doctor exists in the Doctors table.
--* If either does not exist, prevent the insertion and return an error message.
--* If both exist, insert the appointment into the Appointments table.
--After creating the procedure, call it with sample data to demonstrate both a successful and a
--failed insertion attempt.

-- Create procedure
create procedure add_appointment_with_validation(
  p_appointment_id TEXT,
  p_patient_id     TEXT,
  p_doctor_id      TEXT,
  p_appointment_dt TIMESTAMP,
  p_status         TEXT,
  p_nurse_id       TEXT
)
language plpgsql
as $$
declare
  v_patient_exists INT;
  v_doctor_exists  INT;
begin
  -- Check patient exists
  select 1 into v_patient_exists
  from patients
  where "PatientID" = p_patient_id
  limit 1;

  if not found then
    raise exception 'Insert failed: Patient % does not exist.', p_patient_id;
  end if;

  -- Check doctor exists
  select 1 into v_doctor_exists
  from doctors
  where "DoctorID" = p_doctor_id
  limit 1;

  if not found then
    raise exception 'Insert failed: Doctor % does not exist.', p_doctor_id;
  end if;

  -- Optionally: verify nurse exists if you keep Nurses table foreign key
  -- INSERT the appointment
  insert into Appointments (
    AppointmentID, PatientID, DoctorID, AppointmentDate, Status, NurseID
  ) values (
    p_appointment_id, p_patient_id, p_doctor_id, p_appointment_dt, p_status, p_nurse_id
  );

end;
$$;





