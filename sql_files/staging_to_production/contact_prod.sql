-- Contact: Staging to Production
-- 4,038,004 in 7min 12sec

INSERT INTO ig_production.contact (
    SELECT
        uuid_generate_v4() as contact_id
        ,cont.contact_linkedin_url
        ,cont.email_address
        ,cont.email_hash_md5
        ,cont.first_name
        ,cont.last_name
        ,cont.title
        ,cont.department_id
        ,cont.job_function_id
        ,cont.job_role_id
        ,cont.phone_number
        ,cont.street_address
        ,cont.postal_code
        ,'Unverified' as contact_data_status
        ,cont.seniority_id
        ,cont.location_id
        ,cont.ip_address
        ,cont.mx_ip_address
        ,cont.stg_contact_id
        ,NOW() as last_update_date
        ,cmp.company_id
        ,cont.email_hash_sha256
        ,'2019_Data' as datasource
    FROM ig_staging.contact cont
    INNER JOIN ig_production.company cmp
        ON cont.company_id = cmp.company_id
    WHERE
        cont.contact_data_status = 'Reverify'
        AND cont.datasource = '2019_Data'
        
        AND cont.contact_linkedin_url IS NOT NULL
        AND cont.email_address IS NOT NULL
        AND cont.email_hash_md5 IS NOT NULL
        AND cont.first_name IS NOT NULL
        AND cont.last_name IS NOT NULL
        AND cont.title IS NOT NULL
        AND cont.department_id IS NOT NULL
        AND cont.phone_number IS NOT NULL
        AND cont.street_address IS NOT NULL
        AND cont.postal_code IS NOT NULL
        AND cont.seniority_id IS NOT NULL
        AND cont.location_id IS NOT NULL
        AND cont.ip_address IS NOT NULL
        AND cont.mx_ip_address IS NOT NULL
        AND cont.stg_contact_id IS NOT NULL
        AND cont.company_id IS NOT NULL
        AND cont.email_hash_sha256 IS NOT NULL
        AND cont.datasource IS NOT NULL
        
        AND cont.contact_linkedin_url != ''
        AND cont.email_address != ''
        AND cont.email_hash_md5 != ''
        AND cont.first_name != ''
        AND cont.last_name != ''
        AND cont.title != ''
        AND cont.phone_number != ''
        AND cont.street_address != ''
        AND cont.postal_code != ''
        AND cont.ip_address != ''
        AND cont.mx_ip_address != ''
        AND cont.email_hash_sha256 != ''
        AND cont.datasource != ''
)