from datetime import date, timedelta
import pandas as pd
from func import db, gdrive
from func.t_analysis import file
import os

# Constant
yesterday = date.today() - timedelta(days=1)
data_packets = '1vsIFKLDnRxJupeXnf3WecKBBdVDYZuIc'
hygiene_tool = '1xPFwWw1ITuhboSkeau7NgwBJsQxKBezL'
sql_dir = os.getcwd() + "\\files\\raw_usage\\"

# Db
cxn = db.db_connect("local_mysql")
insert_query = open(sql_dir + 'insert_email.sql', 'r').read()
update_query = open(sql_dir + 'hygiene_tool.sql', 'r').read()

# Gdrive
g_auth = gdrive.google_auth()

raw_files = gdrive.list_files(g_auth, data_packets, yesterday)
hygiene_files = gdrive.list_files(g_auth, hygiene_tool, yesterday)

# Insert Email
for raw_file in raw_files:
    if "_raw_" in raw_file:
        gdrive.dl_file_name(g_auth, data_packets, raw_file)
        df = pd.read_excel(raw_file)

        column = dict()
        if 'email_address' in df.columns:
            column['name'] = 'email_address'
        else:
            column['name'] = 'Email'

        for index, row in df.iterrows():
            try:
                cxn.execute(insert_query.format(row[column['name']]))
            except:
                print("Found error on {}".format(row[column['name']]))
        os.remove(raw_file)

# Hygiene Tool
for hygiene_file in hygiene_files:
    if "_raw_" in hygiene_file:
        gdrive.dl_file_name(g_auth, hygiene_tool, hygiene_file)
        df = pd.read_csv(hygiene_file)
        for index, row in df.iterrows():
            try:
                cxn.execute(update_query.format(row['Result'], row['Validated email']))
            except:
                print("Found error on {}".format(row['Validated email']))
        os.remove(hygiene_file)
