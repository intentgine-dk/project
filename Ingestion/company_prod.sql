-- Initial Ingestion for Company
-- 532319 in 8min 37sec

INSERT INTO ig_staging.company (
	SELECT
		uuid_generate_v4() as company_id
		,UPPER(TRIM(prd.company_name)) as company_name
		,TRIM(prd.company_linkedin_url) as company_linkedin_url
		,TRIM(prd.website) as email_domain
		,TRIM(prd.billing_address_street) as street_address
		,TRIM(prd.billing_address_postalcode) as postal_code
		,TRIM(prd.phone_office) as phone_number
		,'0.0.0.0' as ip_address
		,'0.0.0.0' as mx_ip_address
		,loc.location_id as location_id
		,emp_size.employee_size_id
		,ind.industry_id
		,subi.subindustry_id
		,sic.sic_code
		,naics.naics_code
		,rev.revenue_range_id
		,'Production' as company_data_status
		,now() as last_update_date
		,'Alteryx_Production' as datasource
	FROM
		ig_ingestion.alteryx_production prd
	LEFT JOIN ig_master.location loc
		ON prd.billing_address_city = loc.city_name
		AND prd.billing_address_state = loc.state_province
		AND prd.billing_address_country = loc.country
	LEFT JOIN ig_master.employee_size emp_size
		ON prd.acc_emp_size_range = emp_size.employee_size_name
	LEFT JOIN ig_master.industry ind
		ON prd.industry = ind.industry_name
	LEFT JOIN ig_master.subindustry subi
		ON prd.subindustry = subi.subindustry_name
	LEFT JOIN ig_master.sic_code sic
		ON prd.sic_code = sic.sic_code::varchar(250)
	LEFT JOIN ig_master.naics_code naics
		ON prd.acc_naisc_code = naics.naics_code::varchar(250)
	LEFT JOIN ig_master.revenue_range rev
		ON prd.acc_revenue_range = rev.revenue_range
)
ON CONFLICT ON  CONSTRAINT company_name_key
DO NOTHING;