--Outliers by clinic--
select
	isnull(c.clinic_name, 'unknown') as Clinic,
	count(*) as Appointments,
	sum(case
		when a.waiting_days > 48 then 1
		else 0
	end) as Outliers,
	cast(sum(case
			when a.waiting_days > 48 then 1
			else 0
		end) * 100.0 / count(*) as decimal(5,1)) as Outlier_Rate
from appointments as a
left join clinics as c
on a.clinic_id = c.clinic_id
group by isnull(c.clinic_name, 'unknown')
order by outlier_rate desc;


--cancellation rate by segment--
select
	a.appointment_type as Segment,
	count(*) as Appointments,
	sum(case 
		when a.status = 'cancelled' then 1
		else 0
	end) as Cancelled,
	cast(sum(case 
		when a.status = 'cancelled' then 1
		else 0
	end)* 100.0 / count(*) as decimal(5,1)) as Cancel_Rate
from appointments as a
group by a.appointment_type
order by cancel_rate desc;


--cancelled rate by referral source--
select
	a.referral_source as Segment,
	count(*) as Appointments,
	sum(case 
		when a.status = 'cancelled' then 1
		else 0
	end) as Cancelled,
	cast(sum(case 
		when a.status = 'cancelled' then 1
		else 0
	end)* 100.0 / count(*) as decimal(5,1)) as Cancel_Rate
from appointments as a
group by a.referral_source
order by cancel_rate desc;


--cancelled rate by patient age band--
select
	a.patient_age_band as Segment,
	count(*) as Appointments,
	sum(case 
		when a.status = 'cancelled' then 1
		else 0
	end) as Cancelled,
	cast(sum(case 
		when a.status = 'cancelled' then 1
		else 0
	end)* 100.0 / count(*) as decimal(5,1)) as Cancel_Rate
from appointments as a
group by a.patient_age_band
order by cancel_rate desc;


