-- monthly waiting time for 2026--

select distinct
	year(appointment_date) as Yr,
	month(appointment_date) as Mth,
	count(*) over (partition by year(appointment_date), month(appointment_date)) as Appointments,
	cast(avg(waiting_days * 1.0) over (partition by year(appointment_date), month(appointment_date)) as decimal(5,1)) as Avg_wait,
	percentile_cont(0.5) within group (order by waiting_days)
		over (partition by year(appointment_date), month(appointment_date)) as Median_wait
	from appointments
	where appointment_date >= '2026-01-01'
	order by Yr,Mth;

-- Breaches (waits over 48 days) in february vs march 2026--

select 
	sum(case when appointment_date >= '2026-02-01' and appointment_date < '2026-03-01'
		and waiting_days > 48 then 1
		else 0
	end ) as Feb_Breaches,
	sum(case when appointment_date >= '2026-03-01' and appointment_date < '2026-04-01'
		and waiting_days > 48 then 1
		else 0
	end) as Mar_Breaches
from appointments;


-- average waits by service--

with servicewaitscte as (
	select
		s.service_name,
		avg(case when a.appointment_date >= '2026-02-01' and a. appointment_date < '2026-03-01'
			then a.waiting_days * 1.0 
		end) as Feb_Avg,
		avg(case when a.appointment_date >= '2026-03-01' and a. appointment_date < '2026-04-01'
			then a.waiting_days * 1.0 
		end) as Mar_Avg
	from appointments as a
	inner join services as s
	on a.service_id = s.service_id
	group by s.service_name
	)
select
	service_name,
	cast(Feb_Avg as decimal(5,1)) as Feb_Avg,
	cast(Mar_Avg as decimal(5,1)) as Mar_Avg,
	cast(Mar_Avg - Feb_Avg as decimal(5,1)) as Change_Days
from servicewaitscte
order by change_days desc;

--was it one clinic? or everywhere--

with servicewaitscte as (
	select
		c.clinic_name,
		avg(case when a.appointment_date >= '2026-02-01' and a. appointment_date < '2026-03-01'
			then a.waiting_days * 1.0 
		end) as Feb_Avg,
		avg(case when a.appointment_date >= '2026-03-01' and a. appointment_date < '2026-04-01'
			then a.waiting_days * 1.0 
		end) as Mar_Avg
	from appointments as a
	inner join clinics as c
	on a.clinic_id = c.clinic_id
	group by c.clinic_name
	)
select
	clinic_name,
	cast(Feb_Avg as decimal(5,1)) as Feb_Avg,
	cast(Mar_Avg as decimal(5,1)) as Mar_Avg,
	cast(Mar_Avg - Feb_Avg as decimal(5,1)) as Change_Days
from servicewaitscte
order by change_days desc;

--the baseline check--

select distinct
	year(appointment_date) as Yr,
	month(appointment_date) as Mth,
	count(*) over (partition by year(appointment_date), month(appointment_date)) as Appointments,
	cast(avg(waiting_days * 1.0) over (partition by year(appointment_date), month(appointment_date)) as decimal(5,1)) as Avg_wait,
	percentile_cont(0.5) within group (order by waiting_days)
		over (partition by year(appointment_date), month(appointment_date)) as Median_wait
	from appointments
	order by Yr,Mth;

