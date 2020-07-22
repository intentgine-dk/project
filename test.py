from func.date_func import daterange
from datetime import date, timedelta

current_date = date.today()
i = None

for process_date in daterange(i, current_date):
    print(process_date)