from func.t_analysis import file
from func import db
import os

cursor, connection = db.rds_connect("aurora")
conf_dir = os.getcwd() + "\\sql_files\\Ingestion\\Company\\"
query1 = file.file_to_str(conf_dir, "s4_update_str.sql")
query2 = file.file_to_str(conf_dir, "s4_update_id.sql")
query3 = file.file_to_str(conf_dir, "s4_update_num.sql")

#department = ["'admin'", "'consultants'", "'education'", "'engineering'", "'finance'", "'general management'", "'government'", "'healthcare'", "'human resources'", "'law enforcement'", "'legal'", "'marketing'", "'military'", "'operations'", "'photographer'", "'real estate'", "'religious leader'", "'research and development'", "'retired'", "'sales'", "'science'", "'stay at home parent'", "'student'", "'supply chain'", "'technology'", "'writer'"]

#department_id = ["'43e2600c-d3fa-44a3-8679-507f0c16e1e4'", "'a837e79d-978b-49e8-b7a7-bcba1150b0b1'", "'f2f555ed-b8a6-4191-9d97-51b901c79792'", "'46f41c73-e34d-4a04-8fae-8b4e52ebbf19'", "'1fb191d0-c99d-4060-a72e-61f4d5644245'", "'c977f955-a7f6-4c35-8502-8125eea7c37c'", "'c910426a-5fa1-46f0-aa5f-864fa1ccf2ea'", "'2528fa2e-1a6b-424a-9c68-e5f9b66aba41'", "'b0f91fa1-d6b0-4ff0-adf3-bf209a2d1ab1'", "'76ea4a2b-b42f-4f90-b293-182c9e7fc443'", "'bb527e03-4ffe-401a-a9a0-adb2c13c3d6d'", "'1fab500a-b1fc-42fd-9249-f50aca33647d'", "'927f1777-8d40-473c-93f5-9188a62bd19b'", "'92adb43c-d107-4905-b666-4d79482cacfa'", "'a6d62dd9-d0f7-4b4b-bcb1-2204846a96cc'", "'b0570184-dbb4-499b-80f5-4802b48805d3'", "'63cefd41-2db3-4fc8-b491-512fbeed8dc9'"]

cols_1 = ['company_linkedin_url', 'email_domain', 'street_address', 'postal_code', 'phone_number']
cols_2 = ['location_id', 'employee_size_id', 'industry_id', 'subindustry_id', 'revenue_range_id']
cols_3 = ['sic_code', 'naics_code']

for col in cols_1:
    print("Processing {}.".format(col))
    try:
        res = cursor.execute(query1.format('ig_dev.company_netwise_q3_b2', 'ig_dev.company_netwise_q3_b2_dup', col))
        print(cursor.rowcount)
        connection.commit()
    except Exception as e:
        print(e)
        pass

for col in cols_2:
    print("Processing {}.".format(col))
    try:
        res = cursor.execute(query2.format('ig_dev.company_netwise_q3_b2', 'ig_dev.company_netwise_q3_b2_dup', col))
        print(cursor.rowcount)
        connection.commit()
    except Exception as e:
        print(e)
        pass

for col in cols_3:
    print("Processing {}.".format(col))
    try:
        res = cursor.execute(query3.format('ig_dev.company_netwise_q3_b2', 'ig_dev.company_netwise_q3_b2_dup', col))
        print(cursor.rowcount)
        connection.commit()
    except Exception as e:
        print(e)
        pass
