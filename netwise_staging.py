from func.t_analysis import file
from func import db
import os

cursor, connection = db.rds_connect("aurora")
conf_dir = os.getcwd() + "\\sql_files\\source_to_staging\\"
query = file.file_to_str(conf_dir, "company_netwise.sql")

department = ["'admin'", "'consultants'", "'education'", "'engineering'", "'finance'", "'general management'", "'government'", "'healthcare'", "'human resources'", "'law enforcement'", "'legal'", "'marketing'", "'military'", "'operations'", "'photographer'", "'real estate'", "'religious leader'", "'research and development'", "'retired'", "'sales'", "'science'", "'stay at home parent'", "'student'", "'supply chain'", "'technology'", "'writer'"]

#department_id = ["'43e2600c-d3fa-44a3-8679-507f0c16e1e4'", "'a837e79d-978b-49e8-b7a7-bcba1150b0b1'", "'f2f555ed-b8a6-4191-9d97-51b901c79792'", "'46f41c73-e34d-4a04-8fae-8b4e52ebbf19'", "'1fb191d0-c99d-4060-a72e-61f4d5644245'", "'c977f955-a7f6-4c35-8502-8125eea7c37c'", "'c910426a-5fa1-46f0-aa5f-864fa1ccf2ea'", "'2528fa2e-1a6b-424a-9c68-e5f9b66aba41'", "'b0f91fa1-d6b0-4ff0-adf3-bf209a2d1ab1'", "'76ea4a2b-b42f-4f90-b293-182c9e7fc443'", "'bb527e03-4ffe-401a-a9a0-adb2c13c3d6d'", "'1fab500a-b1fc-42fd-9249-f50aca33647d'", "'927f1777-8d40-473c-93f5-9188a62bd19b'", "'92adb43c-d107-4905-b666-4d79482cacfa'", "'a6d62dd9-d0f7-4b4b-bcb1-2204846a96cc'", "'b0570184-dbb4-499b-80f5-4802b48805d3'", "'63cefd41-2db3-4fc8-b491-512fbeed8dc9'"]

industry_id = ["'ff45bb0b-b962-4b37-816a-9bcb69151b5f'", "'602a2eef-3aa6-4400-a4b7-74788902ff60'", "'562445a1-a0dc-4ee0-afa3-91209ad8424e'", "'dfd5b099-7109-4395-897c-571eb6671759'", "'663ecfeb-4224-4647-a0cc-5525bad573b4'", "'2793f45a-06b3-4cc1-8de0-e4db4bbeebe6'", "'b19c5736-4b04-4768-b095-e97b4e93b867'", "'4a9fb6fe-568a-4c6d-846c-bb23a38acb0c'", "'88fc4fef-7ba6-4f10-b538-63a121bc56fe'", "'92467282-4610-4a55-abdd-74a12b91f0f9'", "'a563ff01-a983-4fe9-abf5-c34f5d947ca5'", "'aaa42a86-bc99-4cad-8107-9a01d29cfe09'", "'5656f706-066a-4bcd-9e3d-4e54cffec1dd'", "'90b0bcbb-07e9-4f10-828a-f8c7027067c2'", "'90629093-1b47-4894-8e0a-420b25a6d338'", "'ca6aaade-3662-48a0-a4c2-6d42121761e0'", "'df1ebcf6-12b4-4c09-97c6-b722a524cd99'", "'4ca3d313-08d6-404e-8423-c0ed5b8b8bbd'", "'10b49d38-568b-47e6-94fd-4941182ae3c9'", "'9a1e8bfd-d34d-48a7-808d-17465ad72840'"]

#id_list = ['street_address', 'phone_number', 'postal_code']
#id_list = ['location_id', 'employee_size_id', 'revenue_range_id', 'subindustry_id']
#id_list = ['sic_code', 'naics_code']

'''
for dpt in id_list:
    print("Processing {}.".format(dpt))
    for ind in industry_id:
        try:
            print("Processing {}.".format(ind))
            cursor.execute(query.format(dpt, dpt, dpt, dpt, ind))
            connection.commit()
        except Exception as e:
            print(e)
            pass
'''
for dpt in id_list:
    print("Processing {}.".format(dpt))
    try:
        cursor.execute(query.format(dpt, dpt, dpt, dpt))
        connection.commit()
    except Exception as e:
        print(e)
        pass
