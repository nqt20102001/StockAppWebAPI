import pyodbc

class Database:
    def __init__(self, server_name, database_name, port, username, password, driver):
        self.server_name = server_name
        self.database_name = database_name
        self.port = port
        self.username = username
        self.password = password
        self.driver = driver
        
        # Sử dụng f-string để định dạng chuỗi kết nối đúng cách
        self.connection_string = (f'DRIVER={self.driver};'
                                  f'SERVER={self.server_name},{self.port};'
                                  f'DATABASE={self.database_name};'
                                  f'UID={self.username};'
                                  f'PWD={self.password};'
                                  'TrustServerCertificate=Yes')

        # Kết nối tới cơ sở dữ liệu
        self.conn = pyodbc.connect(self.connection_string)
        self.cursor = self.conn.cursor()
    
    def execute_query(self, query, params):
        self.cursor.execute(query, params)
        self.conn.commit()

    def fetch_query(self, query, params=None):
    # Nếu không có params, thực hiện câu lệnh mà không có tham số
        if params:
            self.cursor.execute(query, params)
        else:
            self.cursor.execute(query)
        return self.cursor.fetchall()

