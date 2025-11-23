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

-- 12. For every appointment in the system, assign a sequence number that ranks each patient’s
-- appointments from most recent to oldest.

with RankedAppointments as (
select 
     a."AppointmentDate",
     a."PatientID",
     a."AppointmentDate",
     a."Status", 
     row_number() over (
       partition by a."PatientID"
       order by a."AppointmentDate"
     ) as AppointmentRank
from appointments a 
)
select * 
from RankedAppointments 
order by "PatientID", AppointmentRank;

-- 13. Generate a report showing the number of appointments per day for October 2021, including a
-- running total across the month.

with OctAppointments as (
   select 
        DATE(a."AppointmentDate") as appt_date,
        count(*) as appointment_that_day
from appointments a
where a."AppointmentDate" >= '2021-10-01'
     and a."AppointmentDate" < '2021-11-01'
group by DATE(a."AppointmentDate")     
)
select
     appt_date
     appointment_that_day,
     SUM(appointment_that_day) OVER(
       order by appt_date
       rows between unbounded preceding and current ROW
     ) as running_total_month
from OctAppointments
order by appt_date;

-- 14. Using a temporary query structure, calculate the average, minimum, and maximum total bill
-- amount, and then return these values in a single result set.
-- CTE (temporary query structure)

with BillStats as (
  select
       AVG(b."TotalAmount") as avg_total,
       MIN(b."TotalAmount") as min_total,
       MAX(b."TotalAmount") as max_total
from bills b        
)
select avg_total, min_total, max_total
from BillStats;

-- 16. Create a query that generates all dates from January 1 to January 15, 2021, and show how
-- many appointments occurred on each of those dates.

with dates as(
  select generate_series(
                DATE '2021-01-01',
                DATE '2021-01-15',
                interval '1 day'
              )::date as day_date
),
appt_counts as (
  select 
    DATE(a."AppointmentDate") as appt_date,
    count(*) as appt_count
  from appointments a  
  where a."AppointmentDate" >= '2021-01-01'
     and a."AppointmentDate" < '2021-01-16'
  group by DATE(a."AppointmentDate")   
)
select 
     d.day_date,
     coalesce(appt_count, 0) as appointments_on_day
from dates d
left join appt_counts on d.day_date = appt_date
order by d.day_date;




