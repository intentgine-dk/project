-- Company: Staging to Production
-- 88,760 in 9sec 314 msec
-- 1045 rows with NULL subindustry

INSERT INTO ig_production.company (
    SELECT
        cmp.company_id
        ,cmp.company_name
        ,cmp.company_linkedin_url
        ,cmp.email_domain as company_website
        ,cmp.street_address
        ,cmp.postal_code
        ,cmp.phone_number
        ,cmp.ip_address
        ,cmp.mx_ip_address
        ,cmp.location_id
        ,cmp.employee_size_id
        ,cmp.industry_id
        ,cmp.subindustry_id
        ,cmp.sic_code
        ,cmp.naics_code
        ,cmp.revenue_range_id
        ,'Unverified' as company_data_status
        ,NOW() as last_update_date
        ,'2019_Data' as datasource
    FROM
        ig_staging.company cmp
    WHERE
        cmp.datasource = 'Alteryx_Production'
        AND cmp.company_data_status = 'Reverify'
        
        AND cmp.company_id IS NOT NULL
        AND cmp.company_name IS NOT NULL
        AND cmp.company_linkedin_url IS NOT NULL
        AND cmp.email_domain IS NOT NULL
        AND cmp.street_address IS NOT NULL
        AND cmp.postal_code IS NOT NULL
        AND cmp.phone_number IS NOT NULL
        AND cmp.ip_address IS NOT NULL
        AND cmp.mx_ip_address IS NOT NULL
        AND cmp.location_id IS NOT NULL
        AND cmp.employee_size_id IS NOT NULL
        AND cmp.industry_id IS NOT NULL
        AND cmp.sic_code IS NOT NULL
        AND cmp.naics_code IS NOT NULL
        AND cmp.revenue_range_id IS NOT NULL
        
        AND TRIM(cmp.company_name) != ''
        AND TRIM(cmp.company_linkedin_url) != ''
        AND TRIM(cmp.email_domain) != ''
        AND TRIM(cmp.street_address) != ''
        AND TRIM(cmp.postal_code) != ''
        AND TRIM(cmp.phone_number) != ''
        AND TRIM(cmp.ip_address) != ''
        AND TRIM(cmp.mx_ip_address) != ''
)