CREATE TABLE prod.sent_campaign (
	email varchar(255) DEFAULT NULL,
	ip varchar(20) DEFAULT NULL,
	email_status varchar(20) DEFAULT NULL,
	type varchar(20) DEFAULT NULL,
	campaign_name varchar(255) DEFAULT NULL,
	Timestamp datetime DEFAULT NULL,
	asset varchar(255) DEFAULT NULL,
	asset_link varchar(255) DEFAULT NULL,
	last_sent_date datetime DEFAULT NULL,
	brand_domain varchar(30) DEFAULT NULL,
	client_name varchar(20) DEFAULT NULL
) 