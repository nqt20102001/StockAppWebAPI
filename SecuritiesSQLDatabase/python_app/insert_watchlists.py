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

# Lấy danh sách các user_id và stock_id hiện có từ cơ sở dữ liệu
users_ids = [i for i in range(1, 10)]  # Danh sách các user_id
stock_ids = [i for i in range(1, 100)]  # Danh sách các stock_id

for i in range(100):
    # Lấy ngẫu nhiên user_id và stock_id
    user_id = random.choice(users_ids)
    stock_id = random.choice(stock_ids)

    # Kiểm tra xem cặp user_id và stock_id đã tồn tại chưa
    check_query = "SELECT COUNT(*) FROM watchlists WHERE user_id = ? AND stock_id = ?"
    check_params = (user_id, stock_id)
    result = db.fetch_query(check_query, check_params)

    # Nếu cặp chưa tồn tại, tiến hành chèn
    if result[0][0] == 0:
        query = "INSERT INTO watchlists (user_id, stock_id) VALUES (?, ?)"
        params = (user_id, stock_id)
        db.execute_query(query, params)
    else:
        print(f"Cặp user_id={user_id} và stock_id={stock_id} đã tồn tại, bỏ qua.")
