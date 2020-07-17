-- Initial Ingestion for Company
-- 530746 in 14min 16sec

INSERT INTO ig_staging.company (
	SELECT
		uuid_generate_v4() as company_id
		,CASE
			WHEN UPPER(TRIM(prd.company_name)) = ''
			THEN NULL
			ELSE UPPER(TRIM(prd.company_name))
		END as company_name
		,CASE
			WHEN TRIM(prd.company_linkedin_url) = ''
			THEN NULL
			ELSE TRIM(prd.company_linkedin_url)
		END as company_linkedin_url
		,CASE
			WHEN TRIM(prd.website) = ''
			THEN NULL
			ELSE TRIM(prd.website)
		END as email_domain
		,CASE
			WHEN TRIM(prd.billing_address_street) = ''
			THEN NULL
			ELSE TRIM(prd.billing_address_street)
		END as street_address
		,CASE
			WHEN TRIM(prd.billing_address_postalcode) = ''
			THEN NULL
			ELSE TRIM(prd.billing_address_postalcode)
		END as postal_code
		,CASE
			WHEN TRIM(prd.phone_office) = ''
			THEN NULL
			ELSE TRIM(prd.phone_office)
		END as phone_number
		,'0.0.0.0' as ip_address
		,'0.0.0.0' as mx_ip_address
		,loc.location_id as location_id
		,emp_size.employee_size_id
		,ind.industry_id
		,subi.subindustry_id
		,sic.sic_code
		,naics.naics_code
		,rev.revenue_range_id
		,'Reverify' as company_data_status
		,now() as last_update_date
		,'2019_Data' as datasource
	FROM
		ig_ingestion.alteryx_production prd
	LEFT JOIN ig_master.location loc
		ON TRIM(LOWER(prd.billing_address_city)) = TRIM(LOWER(loc.city_name))
		AND TRIM(LOWER(prd.billing_address_state)) = TRIM(LOWER(loc.state_province))
		AND TRIM(LOWER(prd.billing_address_country)) = TRIM(LOWER(loc.country))
	LEFT JOIN ig_master.employee_size emp_size
		ON prd.acc_emp_size_range = emp_size.employee_size_name
	LEFT JOIN ig_master.industry ind
		ON TRIM(LOWER(prd.industry)) = TRIM(LOWER(ind.industry_name))
	LEFT JOIN ig_master.subindustry subi
		ON TRIM(LOWER(prd.subindustry)) = TRIM(LOWER(subi.subindustry_name))
	LEFT JOIN ig_master.sic_code sic
		ON prd.sic_code = sic.sic_code::varchar(250)
	LEFT JOIN ig_master.naics_code naics
		ON prd.acc_naisc_code = naics.naics_code::varchar(250)
	LEFT JOIN ig_master.revenue_range rev
		ON prd.acc_revenue_range = rev.revenue_range
)
ON CONFLICT ON CONSTRAINT company_name_key
DO NOTHING;