from datetime import date
from func import gdrive, db, dataframe
from e_class import ingestion

""" Constant Values """
CURRENT_DATE = date.today()
TCI_id = '1GliNu0DlllOGbcAa46V96U0Rr0pKu2-7'
BWR_id = '1ncXvE-Pj_Z1x7s--wJOGIlGoLq3w4tEK'
QA_id = '1ZS6X6arlcvKTTgjZOFEyfsWvtpAycz6p'
HUB_id = '1lH7g4AsUbfwNwaL4x6bW5bU_LpsARQk_'
SENT_id = '1lH7g4AsUbfwNwaL4x6bW5bU_LpsARQk_'

gdrive.process_ingestion(TCI_id, '2020-03-31', 'prod', 'delivered_leads', 'MySQL', ingestion.TCI, dataframe.tci_dataframe, 0)
gdrive.process_ingestion(TCI_id, '2020-03-31', 'staging', 'delivered_leads', 'MySQL', ingestion.TCI, dataframe.tci_dataframe, 0)
#gdrive.process_ingestion(HUB_id, '2020-03-09', 'staging', 'blacklist', 'MySQL', HUB, dataframe.hub_dataframe, 0)
#gdrive.process_ingestion(SENT_id, '2020-03-09', 'staging', 'sent_campaign', 'MySQL', SENT, dataframe.sent_dataframe, 1)
#gdrive.process_ingestion(QA_id, '2020-03-10', 'staging', 'pool_leads', 'MySQL', QA, dataframe.qa_dataframe, 0)