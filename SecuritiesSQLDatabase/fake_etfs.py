from faker import Faker
import pyodbc
import random

server_name = 'localhost'
database_name = 'StockApp'
port = '1435'
username = 'sa'
password = 'Abc@123456'

# Sử dụng dấu ngoặc kép đôi cho {SQL Server}
connection_string = 'DRIVER={{SQL Server}};SERVER={0},{1};DATABASE={2};UID={3};PWD={4}'.format(
    server_name, port, database_name, username, password)

conn = pyodbc.connect(connection_string)

fake = Faker()

symbols = ['VTI', 'VXUS', 'BND', 'BNDX', 'VEA', 'VWO', 'VTV', 'VUG', 'VOO', 'QQQ']
used_symbols = set()
for i in range(100):
    
    name = fake.company() + ' ETF'
    while True:
        symbol = random.choice(symbols) + str(random.randint(1, 100))
        if symbol not in used_symbols:
            used_symbols.add(symbol)
            break
    management_company = fake.company()
    
    # Chuyển đổi inception_date sang chuỗi định dạng 'YYYY-MM-DD'
    inception_date = fake.date_between(start_date='-10y', end_date='today').strftime('%Y-%m-%d')

    cursor = conn.cursor()
    cursor.execute("INSERT INTO etfs (name, symbol, management_company, inception_date) VALUES (?, ?, ?, ?)", (name, symbol, management_company, inception_date))

    conn.commit()
