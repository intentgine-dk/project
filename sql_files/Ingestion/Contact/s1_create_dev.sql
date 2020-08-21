-- Contact: Netwise
drop table if exists ig_dev.contact_netwise_q3_b2;
create table ig_dev.contact_netwise_q3_b2 as (
	SELECT
		uuid_generate_v4() as stg_contact_id
		,CASE
			WHEN TRIM(ntw.person_linkedin_url) = ''
			THEN NULL
            WHEN ntw.person_linkedin_url like '%http%'
			THEN SPLIT_PART(TRIM(ntw.person_linkedin_url), 'www.', 2)
            ELSE ntw.person_linkedin_url
		END as contact_linkedin_url
		,CASE
			WHEN TRIM(ntw.email_address) = ''
			THEN NULL
			ELSE TRIM(ntw.email_address)
		END as email_address
		,MD5(TRIM(ntw.email_address)) as email_hash_md5
		,CASE
			WHEN TRIM(ntw.first_name) = ''
			THEN NULL
			ELSE TRIM(ntw.first_name)
		END as first_name
		,CASE
			WHEN TRIM(ntw.last_name) = ''
			THEN NULL
			ELSE TRIM(ntw.last_name)
		END as last_name
		,CASE
			WHEN UPPER(TRIM(ntw.title)) = ''
			THEN NULL
			ELSE UPPER(TRIM(ntw.title))
		END as title
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
		,encode(sha256(TRIM(ntw.email_address)::bytea), 'hex') as email_hash_sha256
		,'Netwise_202007_b2' as datasource
	FROM
		ig_ingestion.alteryx_netwise_q3_b2 ntw
	LEFT JOIN ig_master.department dpt
		ON 
		CASE
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'admin'
			THEN 'Administration'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'education'
			THEN 'Education and Library'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'engineering'
			THEN 'Engineering and R&D'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'finance'
			THEN 'Finance'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'general management'
			THEN 'Senior and General Management'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'healthcare'
			THEN 'Medical and Healthcare'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'human resources'
			THEN 'Human Resources and Training'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'legal'
			THEN 'Legal'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'marketing'
			THEN 'Marketing'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'operations'
			THEN 'Operations'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'real estate'
			THEN 'Sales'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = NULL
			THEN 'Unclassified'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'research and development'
			THEN 'Engineering and R&D'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'sales'
			THEN 'Sales'
			WHEN TRIM(LOWER(REPLACE(ntw.b2b_job_function, '^', ''))) = 'technology'
			THEN 'Information Technology'
			ELSE 'Other'
		END = dpt.department_name
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
		ON TRIM(UPPER(replace(ntw.company_name, '''', ''))) = TRIM(UPPER(replace(cmp.company_name, '''', '')))
	WHERE
		split_part(ntw.person_linkedin_url, '/', 5) !~ '^.*[^A-Za-z0-9,/:()&!@#$%?'' .-].*$'
		and ntw.first_name !~ '^.*[^A-Za-z0-9,/:()&!@#$%?'' .-].*$'
		and ntw.last_name !~ '^.*[^A-Za-z0-9,/:()&!@#$%?'' .-].*$'
		and ntw.title !~ '^.*[^A-Za-z0-9,/:()&!@#$%?'' .-].*$'
)

