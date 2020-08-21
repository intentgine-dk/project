INSERT INTO ig_dev.company (
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
        ,'Netwise_202007_b2' as datasource
    FROM
        ig_dev.company_netwise_q3_b2 cmp
    WHERE
        cmp.datasource = 'Netwise_202007_b2'
        AND cmp.company_data_status = 'Reverify'
)
ON CONFLICT ON CONSTRAINT company_name_key
DO NOTHING;