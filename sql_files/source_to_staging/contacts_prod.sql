-- Initial Ingestion for Contacts

INSERT INTO ig_staging.contact (
	SELECT
		uuid_generate_v4() as stg_contact_id
		,CASE
			WHEN TRIM(prd.contact_link) = ''
			THEN NULL
			ELSE TRIM(prd.contact_link)
		END as contact_linkedin_url
		,CASE
			WHEN TRIM(prd.email_address) = ''
			THEN NULL
			ELSE TRIM(prd.email_address)
		END as email_address
		,MD5(TRIM(prd.email_address)) as email_hash_md5
		,CASE
			WHEN TRIM(prd.first_name) = ''
			THEN NULL
			ELSE TRIM(prd.first_name)
		END as first_name
		,CASE
			WHEN TRIM(prd.last_name) = ''
			THEN NULL
			ELSE TRIM(prd.last_name)
		END as last_name
		,CASE
			WHEN UPPER(TRIM(prd.title)) = ''
			THEN NULL
			ELSE UPPER(TRIM(prd.title))
		END as title
		,dpt.department_id as department_id
		,(SELECT get_job_function(dpt.department_id, REPLACE(prd.job_function2, '^', ''))) as job_function_id
		,(SELECT get_job_role(dpt.department_id, (SELECT get_job_function(dpt.department_id, REPLACE(prd.job_function2, '^', ''))), REPLACE(prd.job_function3, '^', ''))) as job_role_id
		,CASE
			WHEN TRIM(prd.phone_work) = ''
			THEN NULL
			ELSE TRIM(prd.phone_work)
		END as phone_number
		,CASE
			WHEN UPPER(TRIM(prd.primary_address_street)) = ''
			THEN NULL
			ELSE UPPER(TRIM(prd.primary_address_street))
		END as street_address
		,CASE
			WHEN TRIM(prd.primary_address_postalcode) = ''
			THEN NULL
			ELSE TRIM(prd.primary_address_postalcode)
		END as postal_code
		,'Reverify' as contact_data_status
		,sen.seniority_id
		,loc.location_id as location_id
		,'0.0.0.0' as ip_address
		,'0.0.0.0' as mx_ip_address
		,NOW() as last_update_date
		,cmp.company_id as company_id
		,ENCODE(sha256(TRIM(prd.email_address)::BYTEA), 'hex') as email_hash_sha256
		,'2019_Data' as datasource
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
		ON TRIM(UPPER(prd.company_name)) = TRIM(UPPER(cmp.company_name))
)