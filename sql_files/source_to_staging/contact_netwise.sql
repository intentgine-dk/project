-- Contact: Netwise

INSERT INTO ig_staging.contact (
	SELECT
		uuid_generate_v4() as stg_contact_id
		,TRIM(ntw.person_linkedin_url) as contact_linkedin_url
		,TRIM(ntw.email_address) as email_address
		,MD5(TRIM(ntw.email_address)) as email_hash_md5
		,TRIM(ntw.first_name) as first_name
		,TRIM(ntw.last_name) as last_name
		,UPPER(TRIM(ntw.title)) as title
		,dpt.department_id as department_id
		,(SELECT get_job_function(dpt.department_id, REPLACE(ntw.b2b_job_sub_function, '^', ''))) as job_function_id
		,NULL as job_role_id
		,NULL as phone_number
		,NULL as street_address
		,NULL as postal_code
		,'Unverified' as contact_data_status
		,sen.seniority_id
		,NULL as location_id
		,'0.0.0.0' as ip_address
		,'0.0.0.0' as mx_ip_address
		,NOW() as last_update_date
		,cmp.company_id as company_id
		,encode(sha256(ntw.email_address::bytea), 'hex') as email_hash_sha256
		,'Netwise_202003' as datasource
	FROM
		ig_ingestion.alteryx_raw_netwise ntw
	LEFT JOIN ig_master.department dpt
		ON TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = LOWER(dpt.department_name)
	LEFT JOIN ig_master.seniority sen
		ON
		CASE
			WHEN TRIM(LOWER(ntw.b2b_seniority)) = 'non management'
			THEN 'Individual Contributor'
			WHEN TRIM(LOWER(ntw.b2b_seniority)) = 'staff'
			THEN 'Individual Contributor'
			WHEN TRIM(LOWER(ntw.b2b_seniority)) = 'manager'
			THEN 'Manager'
			WHEN TRIM(LOWER(ntw.b2b_seniority)) = 'director'
			THEN 'Director'
			WHEN TRIM(LOWER(ntw.b2b_seniority)) = 'vice president'
			THEN 'Vice President'
			WHEN TRIM(LOWER(ntw.b2b_seniority)) = 'c level'
			THEN 'C Level'
			WHEN TRIM(LOWER(ntw.b2b_seniority)) = 'board of directors'
			THEN 'C Level'
			WHEN TRIM(LOWER(ntw.b2b_seniority)) = 'owner or partner'
			THEN 'Business Owner / Founder'
			WHEN TRIM(LOWER(ntw.b2b_seniority)) = 'founder'
			THEN 'Business Owner / Founder'
		END = sen.seniority_name
	LEFT JOIN ig_staging.company cmp
		ON TRIM(UPPER(ntw.company_name)) = TRIM(UPPER(cmp.company_name))
)