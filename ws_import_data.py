import csv
import psycopg2

connection = psycopg2.connect(
            database="intentgine",
            user="donnv",
            password="v1ctory#01",
            host="intentgine-masterdb1.clyakjebfxtl.us-west-1.rds.amazonaws.com",
            port='5432'
        )

with open('dead_cont.csv', encoding="ISO-8859-1") as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        #print(row)
        cursor = connection.cursor()
        query = 'insert into public.dead_cont values ("{0}", "{1}", "{2}", "{3}", "{4}", "{5}", "{6}", "{7}", "{8}", "{9}", "{10}", "{11}", "{12}", "{13}", "{14}", "{15}", "{16}", "{17}", "{18}", "{19}", "{20}", "{21}", "{22}", "{23}", "{24}", "{25}", "{26}", "{27}", "{28}", "{29}", "{30}", "{31}", "{32}", "{33}", "{34}", "{35}", "{36}", "{37}", "{38}", "{39}", "{40}")'.format(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11], row[12], row[13], row[14], row[15], row[16], row[17], row[18], row[19], row[20], row[21], row[22], row[23], row[24], row[25], row[26], row[27], row[28], row[29], row[30], row[31], row[32], row[33], row[34], row[35], row[36], row[37], row[38], row[39], row[40])
        query = query.replace("\'", "\\\'")
        print(query)
        cursor.execute(query)
        print(query)
        
        line_count += 1