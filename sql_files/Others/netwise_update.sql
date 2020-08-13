update ig_dev.company_netwise_202003 as t1
set {} = t2.{}
from ig_dev.company_netwise_202003_dup as t2
where
	upper(trim(t1.company_name)) = upper(trim(t2.company_name))
	and t1.company_linkedin_url = t2.company_linkedin_url
	and t1.email_domain = t2.email_domain
	and t1.{} is null
	and t2.{} is not null
	and t1.industry_id = {};
