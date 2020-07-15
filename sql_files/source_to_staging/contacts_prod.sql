-- Initial Ingestion for Contacts

INSERT INTO ig_staging.contact (
	SELECT
		uuid_generate_v4() as stg_contact_id
		,TRIM(prd.contact_link) as contact_linkedin_url
		,TRIM(prd.email_address) as email_address
		,MD5(TRIM(prd.email_address)) as email_hash_md5
		,TRIM(prd.first_name) as first_name
		,TRIM(prd.last_name) as last_name
		,UPPER(TRIM(prd.title)) as title
		,dpt.department_id as department_id
		,(SELECT get_job_function(dpt.department_id, REPLACE(prd.job_function2, '^', ''))) as job_function_id
		,(SELECT get_job_role(dpt.department_id, (SELECT get_job_function(dpt.department_id, REPLACE(prd.job_function2, '^', ''))), REPLACE(prd.job_function3, '^', ''))) as job_role_id
		,TRIM(prd.phone_work) as phone_number
		,UPPER(TRIM(prd.primary_address_street)) as street_address
		,TRIM(prd.primary_address_postalcode) as postal_code
		,'Reverify' as contact_data_status
		,sen.seniority_id
		,loc.location_id as location_id
		,'0.0.0.0' as ip_address
		,'0.0.0.0' as mx_ip_address
		,NOW() as last_update_date
		,cmp.company_id as company_id
		,ENCODE(sha256(prd.email_address::BYTEA), 'hex') as email_hash_sha256
		,'Alteryx_Production' as datasource
	FROM
		ig_ingestion.alteryx_production prd
	LEFT JOIN ig_master.department dpt
		ON TRIM(LOWER(REPLACE(prd.job_function1, '^', ''))) = LOWER(dpt.department_name)
	LEFT JOIN ig_master.job_function jf
		ON TRIM(LOWER(REPLACE(prd.job_function2, '^', ''))) = LOWER(jf.job_function_name)
	LEFT JOIN ig_master.contact_data_status cds
		ON prd.contact_data_status = cds.contact_data_status
	LEFT JOIN ig_master.location loc
		ON TRIM(LOWER(prd.primary_address_city)) = TRIM(LOWER(loc.city_name))
		AND TRIM(LOWER(prd.primary_address_state)) = TRIM(LOWER(loc.state_province))
		AND TRIM(LOWER(prd.primary_address_country)) = TRIM(LOWER(loc.country))
	LEFT JOIN ig_master.seniority sen
		ON LOWER(prd.con_job_level) = LOWER(sen.seniority_name)
	LEFT JOIN ig_staging.company cmp
		ON TRIM(LOWER(prd.company_name)) = TRIM(LOWER(cmp.company_name))
)