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

# Lấy danh sách các etf_id và stock_id hiện có từ cơ sở dữ liệu
etf_ids = [i for i in range(1, 58)]  # Danh sách các etf_id
stock_ids = [i for i in range(1, 100)]  # Danh sách các stock_id

for i in range(100):
    # Lấy ngẫu nhiên etf_id và stock_id
    etf_id = random.choice(etf_ids)  # Không cần [0] vì random.choice đã trả về số nguyên
    stock_id = random.choice(stock_ids)  # Không cần [0]

    # Số lượng cổ phiếu nắm giữ và trọng số của cổ phiếu trong quỹ
    shares_held = round(random.uniform(1000, 1000000), 4)
    weight = round(random.uniform(0.01, 100.00), 4)

    # Tạo câu lệnh SQL và chèn dữ liệu
    query = "INSERT INTO etf_holdings (etf_id, stock_id, shares_held, weight) VALUES (?, ?, ?, ?)"
    params = (etf_id, stock_id, shares_held, weight)

    db.execute_query(query, params)
