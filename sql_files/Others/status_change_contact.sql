UPDATE ig_staging.contact as t1
SET contact_data_status = 'Production'
FROM ig_production.contact as t2
WHERE
    t1.contact_data_status = 'Reverify'
    AND t1.datasource = '2019_Data'
	AND t1.contact_linkedin_url = t2.contact_linkedin_url
	AND t1.email_address = t2.email_address
	AND t1.first_name = t2.first_name
	AND upper(trim(t1.title)) = upper(trim(t2.title))
	AND t1.department_id = t2.department_id
	AND t1.phone_number = t2.phone_number
	AND upper(trim(t1.street_address)) = upper(trim(t2.street_address))
	AND t1.postal_code = t2.postal_code
	AND t1.seniority_id = t2.seniority_id
	AND t1.location_id = t2.location_id
	AND t1.company_id = t2.company_id