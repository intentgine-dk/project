from func import db, gdrive, tools
from func.t_analysis import file
from files.delivered_leads.variables import *
import pandas as pd
import os
from datetime import timedelta, date

# Initialize
#process_date = '2020-05-08'
g_auth = gdrive.google_auth()
cxn = db.db_connect("local_mysql")
conf_dir = os.getcwd() + "//files//"
dir_id = db.load_directory("directory_id")
#raw_files = gdrive.list_files(g_auth, dir_id['imr'], process_date)


def run_delivered_leads(directory_id, client_name, process_date):
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
                data['client'] = client_name
                data['delivery_date'] = process_date

            # Data Cleansing
            for k, v in data.items():
                if "\'" in str(v):
                    new_v = v.replace("\'", "\\\'")
                    data[k] = new_v
            
            query = file.file_to_str(conf_dir, 'delivered_leads//insert.sql')
            cxn.execute(query.format(file_name, data['email'], data['first_name'], data['last_name'], data['phone'], data['country'], data['title'], data['company'], data['industry'], data['job_function'], data['client'], data['delivery_date']))
            
        os.remove(raw_file)



def daterange(start_date, end_date):
    for n in range(int ((end_date - start_date).days)):
        yield start_date + timedelta(n)

start_date = date(2020, 5, 1)
end_date = date(2020, 5, 5)
for single_date in daterange(start_date, end_date):
    print(single_date)
    raw_files = gdrive.list_files(g_auth, dir_id['bwr'], single_date)
    run_delivered_leads(dir_id['bwr'], 'BWR', single_date)