-- Queries to count records by recip_id and vax_event_id

-- Identifies cdc count by grouping vax_event_id and recip_id
select vax_event_id, recip_id from
	mvrs_data 
	group by vax_event_id,recip_id;

-- Duplication of (recip_id, admin_date) (not checked by CDC)
select recip_id,admin_date from
	mvrs_data 
	group by recip_id,admin_date
	having count(*)>1
	order by recip_id;

-- Identifies duplicate (vax_event_id,recip_id) rows
select vax_event_id,recip_id from
		mvrs_data 
		group by vax_event_id,recip_id
		having count(*)>1
		order by recip_id;

-- Identifies duplicates caused by (vax_event_id,recip_id) with admin_date
select b.vax_event_id,b.recip_id,a.admin_date from
	(select vax_event_id,recip_id from
		mvrs_data 
		group by vax_event_id,recip_id
		having count(*)>1
	)b, mvrs_data a
	where 
	a.vax_event_id = b.vax_event_id
	AND a.recip_id = b.recip_id
	order by b.recip_id;
	
-- Identifies duplicates caused by (recip_id,admin_date)
select vax_event_id, recip_id from 
	mvrs_data md WHERE 
	vax_event_id in 
		(  select a.vax_event_id from
			(select recip_id,admin_date from
				mvrs_data 
				group by recip_id,admin_date
				having count(*)>1
			)b, mvrs_data a
			WHERE 
			b.admin_date = a.admin_date
			and b.recip_id = a.recip_id
		)
		order by recip_id;

--Same as above different approach
-- Adding grouping to remove repetitions
select a.vax_event_id,a.recip_id from
		    mvrs_data a join
			(select recip_id,admin_date from
				mvrs_data 
				group by recip_id,admin_date
				having count(*)>1
			)b
			on  b.admin_date = a.admin_date
			and b.recip_id = a.recip_id
			group by a.vax_event_id,a.recip_id
			order by b.recip_id;

-- Compares each record in DB against the duplicate set
-- to return list of records that match on recip_id (and admin_date) but not on vax_event_id
select md.vax_event_id,md.recip_id
	from mvrs_data md
	join (
		 select a.vax_event_id,a.recip_id from
		    mvrs_data a join
			(select recip_id,admin_date from
				mvrs_data 
				group by recip_id,admin_date
				having count(*)>1
			)b
			on  b.admin_date = a.admin_date
			and b.recip_id = a.recip_id
			group by a.vax_event_id,a.recip_id
		) c
	on
	md.vax_event_id <> c.vax_event_id
	and 
	md.recip_id = c.recip_id 
	order by md.recip_id;


-- Instead of comparing with all records in DB with duplicate set
-- Compare identical duplicate sets and pick the ones that do not match on vax_event_id
select md.vax_event_id,md.recip_id,md.admin_date
	from ( 
			select d.vax_event_id,d.recip_id,d.admin_date from
		    mvrs_data d join
			(select recip_id,admin_date from
				mvrs_data 
				group by recip_id,admin_date
				having count(*)>1
			)e
			on  e.admin_date = d.admin_date
			and e.recip_id = d.recip_id
			group by d.vax_event_id,d.recip_id
	     ) md
	join (
		 select a.vax_event_id,a.recip_id from
		    mvrs_data a join
			(select recip_id,admin_date from
				mvrs_data 
				group by recip_id,admin_date
				having count(*)>1
			)b
			on  b.admin_date = a.admin_date
			and b.recip_id = a.recip_id
			group by a.vax_event_id,a.recip_id
		) c
	on
	md.vax_event_id <> c.vax_event_id  --mismatching vax_event ids
	and 
	md.recip_id = c.recip_id 
	order by md.recip_id;

