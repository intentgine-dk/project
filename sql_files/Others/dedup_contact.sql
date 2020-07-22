update ig_staging.contact
set contact_data_status = 'Duplicate'
where ctid in   (
				select
					min(ctid)
				from ig_staging.contact
				where
					datasource = 'Netwise_202003'
                    and department_id = {}
				group by
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
				having count(*) > 1
				order by 1
			    )
and datasource = 'Netwise_202003'
and department_id = {}