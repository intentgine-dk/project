update ig_staging.company as t1
set company_data_status = 'Production'
from ig_production.company as t2
where
	upper(trim(t1.company_name)) = upper(trim(t2.company_name))
	and t1.company_linkedin_url = t2.company_linkedin_url
	and t1.email_domain = t2.company_website
	and t1.company_data_status = 'Reverify'