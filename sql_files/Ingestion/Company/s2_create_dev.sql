CREATE TABLE ig_dev.company_netwise_q3_b2 AS (
SELECT
	*
FROM ig_staging.company
WHERE 1=2
);

ALTER TABLE ig_dev.company_netwise_q3_b2
ADD CONSTRAINT "company_name_company_netwise_q3_b2" UNIQUE (company_name);