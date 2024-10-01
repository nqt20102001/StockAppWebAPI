from faker import Faker
import random
from database import Database

# Cấu hình kết nối với cơ sở dữ liệu
server_name = 'localhost'
database_name = 'StockApp'
port = '1435'
username = 'sa'
password = 'Abc@123456'
driver = '{ODBC Driver 17 for SQL Server}'

# Khởi tạo đối tượng cơ sở dữ liệu và Faker
db = Database(server_name, database_name, port, username, password, driver)
fake = Faker()

# Danh sách dữ liệu giả định cho bảng orders
order_types = ['market', 'limit', 'stop']
directions = ['buy', 'sell']
statuses = ['pending', 'executed', 'canceled']

# Lấy danh sách user_id và stock_id hiện có từ cơ sở dữ liệu
user_ids = [i for i in range(1, 10)]  # Danh sách user_id
stock_ids = [i for i in range(1, 100)]  # Danh sách stock_id

for i in range(1000):  # Tạo 100 dòng dữ liệu giả cho bảng orders
    # Chọn ngẫu nhiên các giá trị cho mỗi trường trong bảng orders
    user_id = random.choice(user_ids)
    stock_id = random.choice(stock_ids)
    order_type = random.choice(order_types)
    direction = random.choice(directions)
    quantity = random.randint(1, 1000)
    price = round(random.uniform(10, 1000), 4)
    status = random.choice(statuses)
    order_date = fake.date_time_this_year()

    # Tạo câu truy vấn SQL và các tham số để chèn dữ liệu
    query = """
        INSERT INTO orders (user_id, stock_id, order_type, direction, quantity, price, status, order_date)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """
    params = (user_id, stock_id, order_type, direction, quantity, price, status, order_date)

    # Thực hiện câu lệnh INSERT
    db.execute_query(query, params)
