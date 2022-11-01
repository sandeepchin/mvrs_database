-- New scripts to account for all sorts of duplicate combinations 10/24/22

-- Script to get records that have 
-- duplicate vax_event_id,recip_id,admin_date values
select vax_event_id, recip_id, admin_date
			from mvrs_data 
			group by vax_event_id,recip_id,admin_date 
			having count(*)>1
			order by vax_event_id;
		
-- Script with similar objective as above
-- But this helps to break down duplicates counts by 2 or 3 
-- change count(*)>1 or count(*)>2 to get various duplicate counts
select md.vax_event_id, md.recip_id, md.admin_date 
	from mvrs_data md
	join (select vax_event_id, recip_id, admin_date
			from mvrs_data 
			group by vax_event_id,recip_id,admin_date 
			having count(*)>1)dup
    on
    	md.vax_event_id = dup.vax_event_id
    	and md.recip_id = dup.recip_id
    	and md.admin_date = dup.admin_date
	order by md.vax_event_id;


-- Script to get records that have
-- duplicate vax_event_id, recip_id but not admin_date
select md.vax_event_id, md.recip_id, md.admin_date
	from mvrs_data md 
	join (select b.vax_event_id,b.recip_id,b.admin_date  -- to get admin_date add this layer
			from mvrs_data b
			join 
			(select vax_event_id,recip_id
				from mvrs_data 
				group by vax_event_id, recip_id
				having count(*)>1) dup
			on b.vax_event_id = dup.vax_event_id
			and b.recip_id = dup.recip_id ) a
	on 
		md.vax_event_id = a.vax_event_id
		and md.recip_id = a.recip_id
		and md.admin_date != a.admin_date
	order by md.recip_id;

-- Script to get records that have
-- duplicate recip_id,admin_date but not vax_event_id
select md.vax_event_id, md.recip_id, md.admin_date
	from mvrs_data md 
	join (select b.vax_event_id,b.recip_id,b.admin_date   -- to get the vax_event_id add this layer
			from mvrs_data b
			join 
			(select recip_id, admin_date
				from mvrs_data 
				group by recip_id,admin_date 
				having count(*)>1) dup
			on b.recip_id = dup.recip_id
			and b.admin_date = dup.admin_date) a
	on 
		md.recip_id = a.recip_id
		and md.admin_date = a.admin_date
		and md.vax_event_id!=a.vax_event_id   -- non matching vax_event_id
	order by md.recip_id ;
	

-- Script to get records that have
-- duplicate vax_event_id, admin_date but not recip_id
select md.vax_event_id, md.recip_id, md.admin_date
	from mvrs_data md 
	join (select b.vax_event_id,b.recip_id,b.admin_date   -- to get the recip_id add this layer
			from mvrs_data b
			join 
			(select vax_event_id,admin_date 
				from mvrs_data 
				group by vax_event_id,admin_date 
				having count(*)>1)dup
			on b.vax_event_id = dup.vax_event_id
			and b.admin_date = dup.admin_date ) a
	on 
		md.vax_event_id = a.vax_event_id
		and md.admin_date = a.admin_date
		and md.recip_id != a.recip_id
	order by md.vax_event_id;
	