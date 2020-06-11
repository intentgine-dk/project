CREATE TABLE prod.blacklist (
    reject_type varchar(30) DEFAULT NULL,
    email varchar(255) DEFAULT NULL,
    delivery_date datetime DEFAULT NULL,
    email_status varchar(20) DEFAULT NULL,
    campaign_name varchar(255) DEFAULT NULL,
    brand_domain varchar(255) DEFAULT NULL,
    ip_address varchar(20) DEFAULT NULL
)
