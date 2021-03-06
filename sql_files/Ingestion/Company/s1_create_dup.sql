-- Company: Netwise
drop table if exists ig_dev.company_netwise_q3_b2_dup;
CREATE TABLE ig_dev.company_netwise_q3_b2_dup AS (
	SELECT
		uuid_generate_v4() as company_id
		,CASE
			WHEN UPPER(TRIM(ntw.company_name)) = ''
			THEN NULL
			ELSE UPPER(TRIM(ntw.company_name))
		END as company_name
		,CASE
			WHEN TRIM(ntw.company_linkedin_url) = ''
			THEN NULL
			ELSE SUBSTRING(TRIM(ntw.company_linkedin_url), 1, 254)
		END as company_linkedin_url
		,CASE
			WHEN TRIM(ntw.company_domain) = ''
			THEN NULL
			ELSE TRIM(ntw.company_domain)
		END as email_domain
		,CASE
			WHEN TRIM(ntw.company_address1_local) = ''
			THEN NULL
			ELSE SUBSTRING(TRIM(ntw.company_address1_local), 1, 254)
		END as street_address
		,CASE
			WHEN TRIM(ntw.company_zip_local) = ''
			THEN NULL
			ELSE TRIM(ntw.company_zip_local)
		END as postal_code
		,CASE
			WHEN TRIM(ntw.company_phone_local) = ''
			THEN NULL
			ELSE TRIM(ntw.company_phone_local)
		END as phone_number
		,'0.0.0.0' as ip_address
		,'0.0.0.0' as mx_ip_address
		,loc.location_id as location_id
		,ntw.company_city_local
		,ntw.company_state_local
		,ntw.company_country_local
		,emp_size.employee_size_id as employee_size_id
		,ntw.company_employees_bucket
		,ind.industry_id as industry_id
		,ntw.company_normalized_industry
		,subi.subindustry_id as subindustry_id
		,ntw.company_primary_industry
		,sic.sic_code as sic_code
		,ntw.company_primary_sic_code
		,naics.naics_code as naics_code
		,ntw.company_primary_naics_code
		,rev.revenue_range_id as revenue_range_id
		,ntw.company_revenue_bucket
		,'Reverify' as company_data_status
		,now() as last_update_date
		,'Netwise_202007_b2' as datasource
	FROM
		ig_ingestion.alteryx_netwise_q3_b2 ntw
	LEFT JOIN ig_master.location loc
		ON TRIM(LOWER(ntw.company_city_local)) = TRIM(LOWER(loc.city_name))
		AND TRIM(LOWER(ntw.company_state_local)) = TRIM(LOWER(loc.state_province))
		AND TRIM(LOWER(ntw.company_country_local)) = TRIM(LOWER(loc.country))
	LEFT JOIN ig_master.employee_size emp_size
		ON 
		CASE
			WHEN ntw.company_employees_bucket = 'Micro (1-20 Employees)'
			THEN '1 - 50'
			WHEN ntw.company_employees_bucket = 'Small (21-100 Employees)'
			THEN '51 - 200'
			WHEN ntw.company_employees_bucket = 'Medium (101-500 Employees)'
			THEN '201 - 500'
			WHEN ntw.company_employees_bucket = 'Medium-Large (501-1000 Employees)'
			THEN '501 - 1,000'
			WHEN ntw.company_employees_bucket = 'Large (1001-5000 Employees)'
			THEN '2,001 - 5,000'
			WHEN ntw.company_employees_bucket = 'XLarge (5001+ Employees)'
			THEN 'more than 10,000'
			ELSE NULL
		END = emp_size.employee_size_name
	LEFT JOIN ig_master.industry ind
		ON TRIM(UPPER(ntw.company_normalized_industry)) = TRIM(UPPER(ind.industry_name))
	LEFT JOIN ig_master.subindustry subi
		ON TRIM(UPPER(ntw.company_primary_industry)) = TRIM(UPPER(subi.subindustry_name))
	LEFT JOIN ig_master.sic_code sic
		ON substring(ntw.company_primary_sic_code, 1, 4) = sic.sic_code::varchar(250)
	LEFT JOIN ig_master.naics_code naics
		ON ntw.company_primary_naics_code = naics.naics_code::varchar(250)
	LEFT JOIN ig_master.revenue_range rev
		ON
		CASE
			WHEN ntw.company_revenue_bucket = 'Less than $1 Million'
			THEN 'Upto 10 Million'
			WHEN ntw.company_revenue_bucket = '$1 - 9.99 Million'
			THEN 'Upto 10 Million'
			WHEN ntw.company_revenue_bucket = '$10 - 49.99 Million'
			THEN '10 Million to 50 Million'
			WHEN ntw.company_revenue_bucket = '$50 - 99.99 Million'
			THEN '50 Million to 100 Million'
			WHEN ntw.company_revenue_bucket = '$100 - 999.99 Million'
			THEN '500 Million to 1 Billion'
			WHEN ntw.company_revenue_bucket = '$1+ Billion'
			THEN '1 Billion and Above'
			ELSE NULL
		END = rev.revenue_range
	WHERE
		ntw.company_name !~ '^.*[^A-Za-z0-9,/:()&!@#$%?'' .-].*$'
)