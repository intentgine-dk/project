from delivered_leads import run_delivered_leads
from func import db, gdrive, tools, notif
from datetime import date, timedelta
from func.date_func import daterange
from func.t_analysis import file
from hub import run_hub
import pandas as pd
import os

# Initialize
current_date = date.today()
g_auth = gdrive.google_auth()
cursor, connection = db.db_connect("local_mysql")
query = "select max(delivery_date) from prod.delivered_leads"

row = cursor.execute(query)
rows = row.fetchone()
current_date = date.today()
for start_date in rows:
    for process_date in daterange(start_date, current_date):
        print("Running {}.".format(process_date))
        run_hub(g_auth, 'HUBS', process_date)
        run_delivered_leads(g_auth, 'BWR', process_date)
        run_delivered_leads(g_auth, 'IMR', process_date)
        run_delivered_leads(g_auth, 'NSF', process_date)
        run_delivered_leads(g_auth, 'MAD', process_date)
        run_delivered_leads(g_auth, 'NTL', process_date)
        run_delivered_leads(g_auth, 'P2B', process_date)
        run_delivered_leads(g_auth, 'TCI', process_date)
        run_delivered_leads(g_auth, 'GRL', process_date)
