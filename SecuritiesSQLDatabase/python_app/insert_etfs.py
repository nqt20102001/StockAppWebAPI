# insert_etfs.py
from faker import Faker
import random
from database import Database

server_name = 'localhost'
database_name = 'StockApp'
port = '1435'
username = 'sa'
password = 'Abc@123456'
driver = '{ODBC Driver 17 for SQL Server}'

db = Database(server_name, database_name, port, username, password, driver)

fake = Faker()

symbols = ['VTI', 'VXUS', 'BND', 'BNDX', 'VEA', 'VWO', 'QQQ', 'SPY', 'GLD', 'EFA']

used_symbols = set()

for i in range(1000):
    name = fake.company() + ' ETF'
    
    while True:
        symbol = random.choice(symbols) + str(random.randint(1, 100))
        if symbol not in used_symbols:
            used_symbols.add(symbol)
            break
    
    management_company = fake.company()
    
    inception_date = fake.date_between(start_date='-10y', end_date='today')

    query = "INSERT INTO etfs (name, symbol, management_company, inception_date) VALUES (?, ?, ?, ?)"
    params = (name, symbol, management_company, inception_date)
    db.execute_query(query, params)
