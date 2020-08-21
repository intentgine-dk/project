update {0} as t1
set {2} = t2.{2}
from {1} as t2
where
	upper(trim(t1.company_name)) = upper(trim(t2.company_name))
	and t1.email_domain = t2.email_domain
	and (
		t1.{2} is null
		or t1.{2} = ''
		or trim(t1.{2}) = ''
		)
	and t2.{2} is not null
	and t2.{2} != ''
	and trim(t2.{2}) != ''
	and t1.company_data_status = 'Reverify';