import psycopg2

try:
    connection = psycopg2.connect(
        database="intentgine",
        user="donnv",
        password="v1ctory#01",
        host="intentgine-masterdb1.clyakjebfxtl.us-west-1.rds.amazonaws.com",
        port='5432'
    )

    cursor = connection.cursor()
    cursor.execute("SELECT * FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';")
    record = cursor.fetchall()
    print(record)

except (Exception, psycopg2.Error) as error :
    print ("Error while connecting to PostgreSQL", error)
finally:
    if(connection):
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")