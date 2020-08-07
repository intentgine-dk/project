UPDATE ig_staging.contact
SET contact_data_status = 'Production'
WHERE
    contact_data_status = 'Reverify'
    AND datasource = '2019_Data'
    AND concat(
            contact_linkedin_url
            ,email_address
            ,first_name
            ,last_name
            ,title
            ,department_id
            ,job_function_id
            ,job_role_id
            ,phone_number
            ,street_address
            ,postal_code
            ,seniority_id
            ,location_id
            ,company_id
            ) in    (
                    SELECT
                        concat(
                            contact_linkedin_url
                            ,email_address
                            ,first_name
                            ,last_name
                            ,title
                            ,department_id
                            ,job_function_id
                            ,job_role_id
                            ,phone_number
                            ,street_address
                            ,postal_code
                            ,seniority_id
                            ,location_id
                            ,company_id
                        )
                    FROM
                        ig_production.contact
                    WHERE
                        datasource = '2019_Data'
                    )