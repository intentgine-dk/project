from func.t_analysis import file
from func import db
import os

cursor, connection = db.rds_connect("aurora")
conf_dir = os.getcwd() + "\\sql_files\\source_to_staging\\"
query = file.file_to_str(conf_dir, "contact_netwise.sql")

department = ["'admin'", "'consultants'", "'education'", "'engineering'", "'finance'", "'general management'", "'government'", "'healthcare'", "'human resources'", "'law enforcement'", "'legal'", "'marketing'", "'military'", "'operations'", "'photographer'", "'real estate'", "'religious leader'", "'research and development'", "'retired'", "'sales'", "'science'", "'stay at home parent'", "'student'", "'supply chain'", "'technology'", "'writer'"]

for dpt in department:
    try:
        print("Processing {}.".format(dpt))
        cursor.execute(query.format(dpt))
    except Exception as e:
        print(e)
        pass