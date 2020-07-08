from func import db, gdrive, tools, notif
from func.t_analysis import file
from files.delivered_leads.variables import *
import pandas as pd
import os
import re
from datetime import timedelta, date

# Initialize
#cursor, connection = db.rds_connect("aurora")
cursor, connection = db.db_connect("local_mysql")
conf_dir = os.getcwd() + "//files//"
dir_id = db.load_directory("directory_id")

def run_delivered_leads(g_auth, gdrive_dir, process_date):
    directory_id = dir_id[gdrive_dir.lower()]
    raw_files = gdrive.list_files(g_auth, directory_id, process_date)
    for raw_file in raw_files:
        try:
            gdrive.dl_file_name(g_auth, directory_id, raw_file)
        except Exception as e:
            print(e)
            pass
        
        file_name = raw_file.replace("\'", "\'\'")
        if ("{" in file_name) and ("}") in file_name:
            campaign = re.findall("\{(.*?)\}", file_name)[0]
        else:
            campaign = file_name.split(".")[0]
        df = pd.DataFrame()
        data = dict()
        dl = dict()

        # Read input file
        df = tools.file_to_df(raw_file)

        # Build columns
        for k, v in master_list.items():
            col = tools.build_columns(df, v)
            dl[k] = col
            
        # Build dict
        for index, row in df.iterrows():
            for k, v in dl.items():
                if v == '':
                    data[k] = ''
                else:
                    data[k] = row[v]
                data['client'] = gdrive_dir
                data['delivery_date'] = process_date

            # Data Cleansing
            for k, v in data.items():
                if "\'" in str(v):
                    new_v = v.replace("\'", "\'\'")
                    data[k] = new_v
            
            if data['email'] == '':
                try:
                    #notif.ingestion_mail("No email on {}".format(data['campaign']))
                    pass
                except:
                    print("Error on {}".format(file_name))

            if data['campaign'] == '':
                data['campaign'] = campaign

            try:
                query = file.file_to_str(conf_dir, 'delivered_leads//insert.sql')
                cursor.execute(query.format(data['campaign'], data['email'], data['first_name'], data['last_name'], data['phone'], data['country'], data['title'], data['company'], data['industry'], data['job_function'], data['client'], data['delivery_date']))
                #connection.commit()
            except Exception as e:
                notif.ingestion_mail(data['campaign'])
                print(e)
                pass

        os.remove(raw_file)
