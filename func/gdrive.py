from oauth2client.service_account import ServiceAccountCredentials
from pydrive.drive import GoogleDrive
from pydrive.auth import GoogleAuth
from datetime import datetime, timedelta
from func import db, notif
import pandas as pd
import gspread
import os


def google_auth():
    g_auth = GoogleAuth()
    g_auth.LocalWebserverAuth()
    g_drive = GoogleDrive(g_auth)

    return g_drive

def spreadsheet(file):
    scope = ['https://www.googleapis.com/auth/spreadsheets',
             "https://www.googleapis.com/auth/drive.file",
             "https://www.googleapis.com/auth/drive"]
    credentials = ServiceAccountCredentials.from_json_keyfile_name('spreadsheet_reader.json', scope)
    client = gspread.authorize(credentials)
    sheet = client.open(str(file)).sheet1
    result = sheet.get_all_records()

    return result


def excel_to_list(excel_file, sheet, class_name):
    df_source = pd.read_excel(excel_file, sheet_name=sheet)
    data = df_source.values.tolist()
    if excel_file:
        os.remove(excel_file)
    data_list = []

    for d in data:
        data_list.append(class_name(*d))

    return data_list


def list_to_db(data_list, schema, target_table, method, mode='append'):
    cxn = db.db_connect("local_mysql")
    df = method(data_list)

    df.to_sql(con=cxn, name=target_table, schema=schema, if_exists=mode, index=False)

    return df

def dl_file_name(g_auth, directory_id, file_name):
    file_list = g_auth.ListFile({'q': "'{}' in parents and trashed=false".format(directory_id)}).GetList()
    for file in sorted(file_list, key=lambda x: x['title']):
        title = str(file['title'])

        if title == file_name:
            print('Downloading {} from GDrive.'.format(title))
            file.GetContentFile(title)

def dl_file_date(g_auth, directory_id, file_date):
    file_list = g_auth.ListFile({'q': "'{}' in parents and trashed=false".format(directory_id)}).GetList()
    for file in sorted(file_list, key=lambda x: x['title']):
        title = str(file['title'])
        modified_date_ts = datetime.strptime(file['modifiedDate'], '%Y-%m-%dT%H:%M:%S.%fZ') + timedelta(hours=8)
        modified_date = modified_date_ts.strftime('%Y-%m-%d')

        if str(modified_date) == str(file_date):
            print('Downloading {} from GDrive.'.format(title))
            file.GetContentFile(title)

def dl_dir_files(g_auth, directory_id):
    titles = list()

    file_list = g_auth.ListFile({'q': "'{}' in parents and trashed=false".format(directory_id)}).GetList()
    for file in sorted(file_list, key=lambda x: x['title']):

        print('Downloading {} from GDrive.'.format(file['title']))
        file.GetContentFile(file['title'])
        titles.append(file['title'])

    return titles

def list_files(g_auth, directory_id, file_date):
    titles = list()

    file_list = g_auth.ListFile({'q': "'{}' in parents and trashed=false".format(directory_id)}).GetList()
    for file in sorted(file_list, key=lambda x: x['title']):
        title = str(file['title'])
        modified_date_ts = datetime.strptime(file['modifiedDate'], '%Y-%m-%dT%H:%M:%S.%fZ') + timedelta(hours=8)
        modified_date = modified_date_ts.strftime('%Y-%m-%d')

        if str(modified_date) == str(file_date):
            titles.append(title)

    return titles