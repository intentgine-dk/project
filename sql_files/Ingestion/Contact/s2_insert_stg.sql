INSERT INTO ig_dev.contact_stg (
SELECT
	stg_contact_id
	,cont.contact_linkedin_url
	,cont.email_address
	,cont.email_hash_md5
	,cont.first_name
	,cont.last_name
	,cont.title
	,cont.department_id::uuid
	,cont.job_function_id::uuid
	,cont.job_role_id::uuid
	,cont.phone_number
	,cont.street_address
	,cont.postal_code
	,contact_data_status
	,cont.seniority_id::uuid
	,cont.location_id::uuid
	,cont.ip_address
	,cont.mx_ip_address
	,NOW() as last_update_date
	,cont.company_id::uuid
	,cont.email_hash_sha256
	,datasource
FROM ig_dev.contact_netwise_q3_b2 cont
)