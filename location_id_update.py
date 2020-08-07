from func import db
import xlrd 
  
loc = ("C:\\Users\\DonnV\\Documents\\Files\\Location ID-Cleanup 02-Aug.xlsx") 
cursor, connection = db.rds_connect("aurora")
data = dict()

wb = xlrd.open_workbook(loc) 
sheet = wb.sheet_by_index(0) 
sheet.cell_value(0, 0)

query = """
        update public.contact_null_location 
        set location_id = '{}' 
        where 
            location_id is null 
            and primary_address_city = '{}' 
            and primary_address_country = '{}' 
            and (
                primary_address_postalcode is null
                or
                trim(primary_address_postalcode) = ''
                )
        """
  
for i in range(sheet.nrows): 
    data["city"] = sheet.cell_value(i, 0)
    data["state"] = sheet.cell_value(i, 1)
    data["country"] = sheet.cell_value(i, 2)
    data["postal_code"] = str(sheet.cell_value(i, 3))
    if "." in data['postal_code']:
        data['postal_code'] = data['postal_code'].split(".")[0]
    data["location_id"] = sheet.cell_value(i, 5)
    location_id = sheet.cell_value(i, 5)

    try:
        cursor.execute(query.format(data['location_id'], data['city'], data['country']))
        connection.commit()
    except Exception as e:
        print(e)
