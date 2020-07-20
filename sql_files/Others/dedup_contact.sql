DELETE FROM ig_production.contact a
WHERE a.ctid <> (
                SELECT 
                    MIN(b.ctid)
                FROM ig_production.contact b
                WHERE 
                    a.contact_linkedin_url = b.contact_linkedin_url
                    AND a.email_address = b.email_address
                    AND a.first_name = b.first_name
                    AND a.title = b.title
                    AND a.department_id = b.department_id
                    AND a.job_function_id = b.job_function_id
                    AND a.job_role_id = b.job_role_id
                    AND a.phone_number = b.phone_number
                    AND a.street_address = b.street_address
                    AND a.postal_code = b.postal_code
                    AND a.seniority_id = b.seniority_id
                    AND a.location_id = b.location_id
                    AND a.company_id = b.company_id
                 );

UPDATE 