update ig_staging.company as t1
set company_data_status = 'Production'
from ig_production.company as t2
where
	upper(trim(t1.company_name)) = upper(trim(t2.company_name))
	and t1.company_linkedin_url = t2.company_linkedin_url
	and t1.email_domain = t2.company_website
	and upper(trim(t1.street_address)) = upper(trim(t2.street_address))
	and upper(trim(t1.phone_number)) = upper(trim(t2.phone_number))
	and t1.location_id = t2.location_id
	and t1.employee_size_id = t2.employee_size_id
	and t1.industry_id = t2.industry_id
	and t1.subindustry_id = t2.subindustry_id
	and t1.sic_code = t2.sic_code
	and t1.naics_code = t2.naics_code
	and t1.revenue_range_id = t2.revenue_range_id
	and t1.datasource = '2019_Data'
	and t1.company_data_status = 'Reverify'