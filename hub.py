from func import db, gdrive, tools, notif
from func.date_func import daterange
from func.t_analysis import file
from files.hub.variables import *
from datetime import date, timedelta
import pandas as pd
import os

# Initialize
cursor, connection = db.db_connect("local_mysql")
conf_dir = os.getcwd() + "//files//"
dir_id = db.load_directory("directory_id")

def run_hub(g_auth, gdrive_dir, process_date):
    directory_id = dir_id[gdrive_dir.lower()]
    raw_files = gdrive.list_files(g_auth, directory_id, process_date)
    for raw_file in raw_files:
        gdrive.dl_file_name(g_auth, directory_id, raw_file)
        file_name = raw_file.replace("\'", "\\\'")
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
                data['delivery_date'] = process_date

            # Data Cleansing
            for k, v in data.items():
                if "\'" in str(v):
                    new_v = v.replace("\'", "\\\'")
                    data[k] = new_v
            
            if str(data['reject_type']).lower() != 'active' or str(data['reject_type']).lower() != 'sent':
                try:
                    query = file.file_to_str(conf_dir, 'hub//insert.sql')
                    cursor.execute(query.format(file_name, data['reject_type'], data['email'], data['delivery_date'], data['email_status'], data['campaign_name'], data['brand_domain'], data['ip_address']))
                except Exception as e:
                    #notif.ingestion_mail(file_name)
                    print(e)
                    pass

        os.remove(raw_file)
