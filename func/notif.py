import smtplib, ssl
from datetime import date
from email.mime.text import MIMEText

def ingestion_mail(campaign):
    current_date = date.today()
    recipient = 'donn.victory@intentgine.com'
    sender = 'ingestion.notifier@gmail.com,'
    msg = MIMEText("""    
    Hi,

    Found discrepancy on ingestion.
    Files:
        {}

    Thanks
    Data Team
    """)

    msg['Subject'] = "Ingestion Error {}".format(current_date)
    msg['From'] = sender
    msg['To'] = recipient

    ctx = ssl.create_default_context()
    with smtplib.SMTP_SSL("smtp.gmail.com", port=465, context=ctx) as server:
        server.login("ingestion.notifier@gmail.com", "intent2020")
        server.sendmail("ingestion.notifier@gmail.com", 
                        recipient.split(','), 
                        msg.as_string().format(campaign))
