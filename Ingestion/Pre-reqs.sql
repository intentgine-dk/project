-- Pre-reqs

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE OR REPLACE FUNCTION get_job_function(
	dpt_id uuid
	,jf_name varchar(100)
	,OUT jf_id uuid) 
AS $$
BEGIN
	jf_id := (
	SELECT
		job_function_id
	FROM ig_master.job_function
	WHERE 
		department_id = dpt_id
		AND 
		CASE
			WHEN jf_name IS NULL
			THEN 
				'Unclassified'
			WHEN jf_name = ''
			THEN 
				'Unclassified'
			ELSE
				TRIM(LOWER(jf_name))
		END = TRIM(LOWER(job_function_name))
	);
END; $$

LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_job_role(
	dpt_id uuid
	,jf_id uuid
	,jr_name varchar(100)
	,OUT jr_id uuid) 
AS $$
BEGIN
	jr_id := (
	SELECT
		job_role_id
	FROM ig_master.job_role
	WHERE 
		department_id = dpt_id
		AND job_function_id = jf_id
		AND 
		CASE
			WHEN jr_name IS NULL
			THEN 
				'Unclassified'
			WHEN jr_name = ''
			THEN 
				'Unclassified'
			ELSE
				TRIM(LOWER(jr_name))
		END = TRIM(LOWER(job_role_name))
	);
END; $$

LANGUAGE plpgsql;