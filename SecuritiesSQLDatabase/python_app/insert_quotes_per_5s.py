import random
import time
from faker import Faker
from database import Database  # Import lớp Database từ file database.py

# Khởi tạo đối tượng Faker
fake = Faker()

# Kết nối đến SQL Server bằng lớp Database
db = Database(server_name='localhost', 
              database_name='StockApp', 
              port='1435', 
              username='sa', 
              password='Abc@123456', 
              driver='{ODBC Driver 17 for SQL Server}')

# Lấy danh sách stock_id hiện có từ cơ sở dữ liệu
stock_ids = [row[0] for row in db.fetch_query("SELECT stock_id FROM stocks")]

# Hàm tạo dữ liệu giả cho bảng quotes
def generate_quote(stock_id):
    price = round(random.uniform(10, 1000), 2)  # Giá cổ phiếu
    change = round(random.uniform(-10, 10), 2)  # Biến động giá
    percent_change = round((change / price) * 100, 2)  # Tỷ lệ biến động
    volume = random.randint(1000, 1000000)  # Khối lượng giao dịch
    time_stamp = fake.date_time_this_year()  # Thời gian cập nhật
    return (stock_id, price, change, percent_change, volume, time_stamp)

# Câu truy vấn SQL để chèn dữ liệu vào bảng quotes
insert_query = """
    INSERT INTO quotes (stock_id, price, change, percent_change, volume, time_stamp)
    VALUES (?, ?, ?, ?, ?, ?)
"""

# Hàm để chèn 1 bản ghi mỗi 5 giây
def insert_quote_every_5_seconds():
    try:
        while True:
            # Chọn ngẫu nhiên stock_id từ danh sách
            stock_id = random.choice(stock_ids)
            # Tạo một bản ghi quotes
            quote = generate_quote(stock_id)
            # Chèn bản ghi vào bảng quotes
            db.execute_query(insert_query, quote)
            print(f"Inserted quote for stock_id: {stock_id}")
            # Tạm dừng 5 giây
            time.sleep(5)
    except KeyboardInterrupt:
        print("Stopped by user")

# Gọi hàm để bắt đầu chèn dữ liệu mỗi 5 giây
insert_quote_every_5_seconds()
