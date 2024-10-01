from faker import Faker
import random
import string
from database import Database

server_name = 'localhost'
database_name = 'StockApp'
port = '1435'
username = 'sa'
password = 'Abc@123456'
driver = '{ODBC Driver 17 for SQL Server}'

db = Database(server_name, database_name, port, username, password, driver)

fake = Faker()

used_symbols = set()

def generate_word(min_length=2, max_length=10):
    letters = string.ascii_uppercase
    word_length = random.randint(min_length, max_length)
    word = ''.join(random.choice(letters) for i in range(word_length))  # sửa dấu cách
    return word

SECTORS = {"Thực phẩm": "Food", "Bất động sản": "Real estate", "Ngân hàng": "Banking", "Dược phẩm": "Pharmaceuticals", "Công nghệ": "Technology", "Dịch vụ": "Services", "Tài chính": "Finance", "Năng lượng": "Energy", "Công nghiệp": "Industrial", "Y tế": "Healthcare", "Vận tải": "Transportation", "Truyền thông": "Media", "Thể thao": "Sports", "Giải trí": "Entertainment", "Khác": "Other"}

INDUSTRIES = {"Sữa và thực phẩm sữa": "Dairy and dairy products", "Phát triển bất động sản": "Real estate development", "Ngân hàng thương mại": "Commercial bank", "Dược phẩm chữa bệnh": "Pharmaceuticals", "Công nghệ thông tin": "Information technology", "Dịch vụ công nghiệp": "Industrial services", "Tài chính": "Finance", "Năng lượng": "Energy", "Công nghiệp": "Industrial", "Y tế": "Healthcare", "Vận tải": "Transportation", "Truyền thông": "Media", "Thể thao": "Sports", "Giải trí": "Entertainment", "Khác": "Other"}

STOCK_TYPES = ["Common Stock", "Preferred Stock", "ETF"]

for i in range(100):
    symbol = generate_word(2, 10)
    while symbol in used_symbols:
        symbol = generate_word(2, 10)
    used_symbols.add(symbol)

    company_name = fake.company()
    market_cap = fake.pyfloat(positive=True, right_digits=2, min_value=1000000, max_value=1000000000)

    sector = random.choice(list(SECTORS.keys()))
    sector_en = SECTORS[sector]

    industry = random.choice(list(INDUSTRIES.keys()))
    industry_en = INDUSTRIES[industry]

    stock_type = random.choice(STOCK_TYPES)

    rank = fake.random_int(1, 100)
    rank_source = fake.word()
    reason = fake.sentence(nb_words=6, variable_nb_words=True)

    query = "INSERT INTO stocks (symbol, company_name, market_cap, sector, industry, sector_en, industry_en, stock_type, rank, rank_source, reason) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

    params = (symbol, company_name, market_cap, sector, industry, sector_en, industry_en, stock_type, rank, rank_source, reason)

    db.execute_query(query, params)
