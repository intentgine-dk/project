update {0} as t1
set {2} = t2.{2}::uuid
from {1} as t2
where
	upper(trim(t1.company_name)) = upper(trim(t2.company_name))
	and t1.company_linkedin_url = t2.company_linkedin_url
	and t1.email_domain = t2.email_domain
	and t1.{2} is null
	and t2.{2} is not null
	and t1.company_data_status = 'Reverify';