CREATE TABLE prod.blacklist (
    file_source varchar(255),
    reject_type varchar(50) DEFAULT NULL,
    email varchar(255) DEFAULT NULL,
    delivery_date datetime DEFAULT NULL,
    email_status varchar(50) DEFAULT NULL,
    campaign_name varchar(255) DEFAULT NULL,
    brand_domain varchar(255) DEFAULT NULL,
    ip_address varchar(20) DEFAULT NULL
)
