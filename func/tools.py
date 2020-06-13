import pandas as pd

def build_columns(df, col_list):
    col = ''
    for element in col_list:
        if element in df.columns:
            col = element
    
    return col

def file_to_df(raw_file):
    if ".csv" in raw_file:
        df = pd.read_csv(raw_file, encoding="ISO-8859-1", engine="python")
    else:
        df = pd.read_excel(raw_file, sheet_name=0)

    return df