-- Initial Ingestion for Contacts

INSERT INTO ig_staging.contact (
SELECT
	uuid_generate_v4() as stg_contact_id
	,prd.contact_link as contact_linkedin_url
	,prd.email_address as email_address
	,MD5(prd.email_address) as email_hash_md5
	,prd.first_name as first_name
	,prd.last_name as last_name
	,CASE
		WHEN prd.title IS NULL
		THEN 'Unclassified'
		WHEN prd.title = ''
		THEN 'Unclassified'
		ELSE prd.title
	END as title
	,dpt.department_id as department_id
	,(select get_job_function(dpt.department_id, replace(prd.job_function2, '^', ''))) as job_function_id
	,(select get_job_role(dpt.department_id, (select get_job_function(dpt.department_id, replace(prd.job_function2, '^', ''))), replace(prd.job_function3, '^', ''))) as job_role_id
	,prd.phone_work as phone_number
	,prd.primary_address_street as street_address
	,prd.primary_address_postalcode as postal_code
	,'Production' as contact_data_status
	,sen.seniority_id
	,loc.location_id as location_id
	,'0.0.0.0' as ip_address
	,'0.0.0.0' as mx_ip_address
	,now() as last_update_date
	,cmp.company_id
	,encode(sha256(prd.email_address::bytea), 'hex') as email_hash_sha256
	,'Alteryx_Production' as datasource
FROM
	ig_ingestion.alteryx_production prd
LEFT JOIN ig_master.department dpt
	ON replace(prd.job_function1, '^', '') = dpt.department_name
LEFT JOIN ig_master.job_function jf
	ON replace(prd.job_function2, '^', '') = jf.job_function_name
LEFT JOIN ig_master.contact_data_status cds
	ON prd.contact_data_status = cds.contact_data_status
LEFT JOIN ig_master.location loc
	ON prd.primary_address_city = loc.city_name
	AND prd.primary_address_state = loc.state_province
	AND prd.primary_address_country = loc.country
LEFT JOIN ig_master.seniority sen
	ON prd.con_job_level = sen.seniority_name
LEFT JOIN ig_staging.company cmp
	ON prd.company_name = cmp.company_name
)