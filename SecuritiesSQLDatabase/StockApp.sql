create database StockApp
use master
use StockApp
drop database StockApp

create table users(
    user_id int identity(1,1) primary key,
    username nvarchar(100) unique not null,
    hashed_password nvarchar(200) not null,         -- Mật khẩu được mã hóa
    email nvarchar(255) unique not null,
    phone nvarchar(20) not null,
    full_name nvarchar(255),
    date_of_birth date,
    country nvarchar(200)
)

select * from users

create table user_devices(
    id int primary key identity,
    user_id int not null,
    device_id nvarchar(255) not null,
    foreign key (user_id) references users(user_id)
)

create table stocks(
    stock_id int identity(1,1) primary key,
    symbol nvarchar(10) unique not null,            -- Mã cổ phiếu
    company_name nvarchar(255) not null,            -- Tên công ty
    market_cap decimal(18,2),                       -- Vốn hóa thị trường
    sector nvarchar(200),                           -- Ngành
    industry nvarchar(200),                         -- Lĩnh vực
    sector_en nvarchar(200),
    industry_en nvarchar(200),
    stock_type nvarchar(50),
    
    -- Common Stock (Cổ phiếu thường), Preferred Stock (Cổ phiếu ưu đãi), ETF (Quỹ đầu tư chứng khoán)

    rank int default 0,
    rank_source nvarchar(200),
    reason nvarchar(255)                            -- Nguyên nhân khiến cổ phiếu đưa vào danh sách top stocks
)

-- Cần dữ liệu theo thời gian thực:

create table quotes(
    quote_id int primary key identity(1,1),
    stock_id int,
    price decimal(18,2) not null,                   -- Giá cổ phiếu
    change decimal(18,2) not null,                  -- Biến động giá cổ phiếu so với ngày trước đó
    percent_change decimal(18,2) not null,          -- Tỉ lệ biến đổi giá cổ phiếu so với ngày trước đó
    volume int not null,                            -- Khối lượng giao dịch trong ngày
    time_stamp datetime not null                    -- Thời điểm cập nhật giá cổ phiếu
)

ALTER TABLE quotes
ADD CONSTRAINT FK_Quotes_Stocks
FOREIGN KEY (stock_id)
REFERENCES stocks (stock_id);

-- Các chỉ số index

create table market_indices(
    index_id int primary key identity,
    name nvarchar(255) not null,
    symbol nvarchar(50) unique not null
)

-- market_indices - stocks => quan hệ nhiều nhiều (n - n)
-- idex_constituents: danh sách công ty đã được chọn để tính toán chỉ số của một chỉ số thị trường chứng khoán nhất định
-- association table

create table index_constituents(
    index_id int foreign key references market_indices(index_id),
    stock_id int
)

ALTER TABLE index_constituents
ADD CONSTRAINT FK_IndexConstituents_Stocks
FOREIGN KEY (stock_id)
REFERENCES stocks (stock_id);

create table derivatives(
    derivatives_id int primary key identity,        -- Chứng khoán phái sinh
    name nvarchar(255) not null,
    underlying_asset_id int,    -- ID của tài sản mà chứng khoán phái sinh được dựa trên
    contract_size int,                              -- Kích thước hợp đồng
    expiration_date date,                           -- Ngày hết hạn hợp đồng phái sinh
    strike_price decimal(18,4),                     -- Giá thực hiện
    last_price decimal(18,2) not null,
    change decimal(18,2) not null,
    percent_change decimal(18,2) not null,
    open_price decimal(18,2) not null,
    high_price decimal(18,2) not null,
    low_price decimal(18,2) not null,
    volume int not null,
    open_interest int not null,
    time_stamp datetime not null
)

alter table derivatives
add constraint FK_Derivatives_Stocks
foreign key (underlying_asset_id)
references stocks (stock_id)

create table covered_warrants(
    warrant_id int primary key identity,            -- ID của chứng quyền có bảo đảm
    name nvarchar(255) not null,
    underlying_asset_id int,
    issue_date date,                                -- Ngày phát hành chứng quyền
    expiration_date date,                           -- Ngày hết hạn
    strike_price decimal(18,4),                     -- Giá hiện thực
    warrant_type nvarchar(50)                       -- Loại chứng quyền (mua (call) / bán (put))
)

ALTER TABLE covered_warrants
ADD CONSTRAINT FK_CoveredWarrants_Stocks
FOREIGN KEY (underlying_asset_id)
REFERENCES stocks (stock_id);

create table etfs(
    etf_id int primary key identity,                -- Quỹ đầu tư chứng khoán
    name nvarchar(255) not null,                    -- Tên của quỹ
    symbol nvarchar(50) unique not null,            -- Ký tự của quỹ
    management_company nvarchar(255),               
    inception_date date                             -- Ngày thành lập quỹ đầu tư chứng khoán
)

create table etf_quotes(
    quote_id int primary key identity(1,1),
    etf_id int foreign key references etfs(etf_id),
    price decimal(18,2) not null,                   -- Giá cổ phiếu
    change decimal(18,2) not null,                  -- Biến động giá cổ phiếu so với ngày trước đó
    percent_change decimal(18,2) not null,          -- Tỉ lệ biến đổi giá cổ phiếu so với ngày trước đó
    total_volume int not null,                            -- Khối lượng giao dịch trong ngày
    time_stamp datetime not null                    -- Thời điểm cập nhật giá cổ phiếu
)

create table etf_holdings(
    etf_id int foreign key references etfs(etf_id),
    stock_id int,
    shares_held decimal(18,4),      -- Số lượng cố phiểu của mã cổ phiếu đó mà Quỹ đầu tư đang nắm giữ
    weight decimal(18,4)            -- Trọng số của cổ phiếu đó trong tổng danh mục đầu tư của Quỹ
)

ALTER TABLE etf_holdings
ADD CONSTRAINT FK_ETFHoldings_Stocks
FOREIGN KEY (stock_id)
REFERENCES stocks (stock_id);



-- Watchlist: Bảng theo dõi danh mục đầu tư /// N users theo dõi N stocks
create table watchlists(
    user_id int foreign key references users(user_id),
    stock_id int
)

alter table watchlists 
add constraint unique_Watchlist_Entry
unique(user_id, stock_id)

ALTER TABLE watchlists
ADD CONSTRAINT FK_Watchlists_Stocks
FOREIGN KEY (stock_id)
REFERENCES stocks (stock_id);

-- Bảng đặt lệnh
create table orders(
    order_id int primary key identity(1,1),
    user_id int foreign key references users(user_id),
    stock_id int,
    order_type nvarchar(20),                                -- market/limit/stop
    direction nvarchar(20),
    quantity int,
    price decimal(18,4),
    status nvarchar(20),                                    -- pending/executed/canceled
    order_date datetime
)

ALTER TABLE orders
ADD CONSTRAINT FK_Orders_Stocks
FOREIGN KEY (stock_id)
REFERENCES stocks (stock_id);

-- Bảng danh mục đầu tư
create table portfolios(
    user_id int foreign key references users(user_id),
    stock_id int,
    quantity int,
    purchase_price decimal(18,4),
    purchase_date datetime
)

ALTER TABLE portfolios
ADD CONSTRAINT FK_Portfolios_Stocks
FOREIGN KEY (stock_id)
REFERENCES stocks (stock_id);

create table notifications(
    notification_id int primary key identity(1,1),
    user_id int foreign key references users(user_id),
    notification_type nvarchar(50),
    content text not null,
    is_read bit default 0,
    created_at datetime
)

create table educational_resources(
    resource_id int primary key identity(1,1),      -- ID của Tài liệu
    title nvarchar(255) not null,                   -- Tiêu đề
    content text not null,                          -- Nội dung
    category nvarchar(100),                         -- Danh mục (ví dụ: đầu tư, chiến lược giao dịch, quản lý rủi ro)
    date_published datetime                         -- Ngày xuất bản
)

-- Bảng tài khoản ngân hàng được liên kết

create table linked_bank_accounts(
    account_id int primary key identity(1,1),   -- ID Tài khoản
    user_id int foreign key references users(user_id),
    bank_name nvarchar(255) not null,       -- Tên ngân hàng
    account_number nvarchar(50) not null,   -- Số tài khoản
    routing_number nvarchar(50),            -- Số định tuyến
    account_type nvarchar(50)               -- Loại tài khoản: checking/savings
)

create table transactions(
    transaction_id int primary key identity(1,1),
    user_id int foreign key references users(user_id),
    linked_account_id int foreign key references linked_bank_accounts(account_id),
    transaction_type nvarchar(50),          -- Deposit / Withdrawal
    amount decimal(18,2),
    transaction_date datetime
)


select * from users

insert into users (username, hashed_password, email, phone, full_name, date_of_birth, country)
values ('nguyenquoctoan', hashbytes('sha2_256', '123456'), 'nguyenquoctoan@example.com', '012345678', N'Nguyễn Quốc Toàn', '2001-10-20', N'Việt Nam')

go

--------------------------------------------------- CREATE PROCEDURES ------------------------------------------------------------

-- drop procedure RegisterUser
-- go

create procedure dbo.RegisterUser 
    @username nvarchar(100),
    @password nvarchar(200),
    @email nvarchar(255),
    @phone nvarchar(20),
    @full_name nvarchar(255),
    @date_of_birth date,
    @country nvarchar(200)
as
begin 
    insert into users (username, hashed_password, email, phone, full_name, date_of_birth, country)
    values (@username, hashbytes('sha2_256', @password), @email, @phone, @full_name, @date_of_birth, @country)
    select * from users where user_id = @@IDENTITY
end
go

set identity_insert [dbo].[users] off

delete from users where email = 'minhtu222@example.com'

exec dbo.RegisterUser 'nguyenquoctoan', 'password11', 'minhtu222@example.com', '091234567', N'Nguyễn Minh Tú', '1999-07-05', N'Việt Nam'

exec dbo.RegisterUser 'lethibichtram', 'password1', 'bichtram@example.com', '098765432', N'Lê Thị Bích Trâm', '1999-07-15', N'Việt Nam'
exec dbo.RegisterUser 'nguyenminhtrung', 'password2', 'minhtrung@example.com', '012347652', N'Nguyễn Minh Trung', '1995-09-30', N'Việt Nam'
exec dbo.RegisterUser 'phamvantuan', 'password3', 'tuanpham@example.com', '012345689', N'Phạm Văn Tuấn', '1998-02-11', N'Việt Nam'
exec dbo.RegisterUser 'tranthihoai', 'password4', 'hoaitran@example.com', '0192837465', N'Trần Thị Hoài', '2000-01-20', N'Việt Nam'
exec dbo.RegisterUser 'dangquanghoa', 'password5', 'quanghoa@example.com', '093567890', N'Đặng Quang Hòa', '2002-11-22', N'Việt Nam'
exec dbo.RegisterUser 'ngothihuong', 'password6', 'huongngo@example.com', '092345671', N'Ngô Thị Hương', '2001-05-30', N'Việt Nam'
exec dbo.RegisterUser 'buitrunghieu', 'password7', 'trunghieu@example.com', '094532178', N'Bùi Trung Hiếu', '1997-08-13', N'Việt Nam'
exec dbo.RegisterUser 'dinhthanhvinh', 'password8', 'thanhvinh@example.com', '096543789', N'Đinh Thanh Vinh', '1996-03-18', N'Việt Nam'
exec dbo.RegisterUser 'phamvanhieu', 'password9', 'vanhieu@example.com', '097865432', N'Phạm Văn Hiếu', '2003-04-27', N'Việt Nam'
exec dbo.RegisterUser 'tranvanloc', 'password10', 'vanloc@example.com', '098745632', N'Trần Văn Lộc', '2001-12-25', N'Việt Nam'
exec dbo.RegisterUser 'nguyenminhtu', 'password11', 'minhtu@example.com', '091234567', N'Nguyễn Minh Tú', '1999-07-05', N'Việt Nam'

go

select * from users

drop procedure dbo.CheckLogin
go

create procedure dbo.CheckLogin
    @password nvarchar(200),
    @Email nvarchar(255)
as 
begin
    set nocount on
    declare @HashedPassword varbinary(32)
    set @HashedPassword = hashbytes('sha2_256', @password)
    begin 
        select * from users where Email in (select email from users where email = @Email and hashed_password = @HashedPassword)
    end
end
go

CREATE PROCEDURE dbo.CheckLogin
    @password NVARCHAR(200),
    @Email NVARCHAR(255)
AS 
BEGIN
    DECLARE @HashedPassword VARBINARY(32)
    SET @HashedPassword = HASHBYTES('SHA2_256', @password)
    
    SELECT * 
    FROM users 
    WHERE Email = @Email AND hashed_password = @HashedPassword
END
go

exec dbo.RegisterUser 'myxuyen', 'myxuyen', 'myxuyen@example.com', '091234567', N'Nguyễn Minh Tú', '1999-07-05', N'Việt Nam'
exec dbo.CheckLogin 'myxuyen', 'myxuyen@example.com'

execute dbo.CheckLogin 'myxuyen', 'myxuyen@example.com'


drop table stocks
select * from stocks

insert into stocks (symbol, company_name, market_cap, sector, industry, sector_en, industry_en, stock_type)
values 
('VNM', N'Vinamilk', 2400000000000.00, N'Thực phẩm', N'Sữa và sản phẩm sữa', 'Food', 'Dairy Products', N'Common Stock'),
('FPT', N'Công ty cổ phần FPT', 800000000000.00, N'Công nghệ', N'Dịch vụ phần mềm', 'Technology', 'Software Services', N'Common Stock'),
('VCB', N'Ngân hàng Vietcombank', 3500000000000.00, N'Tài chính', N'Ngân hàng', 'Finance', 'Banking', N'Common Stock'),
('HPG', N'Tập đoàn Hòa Phát', 600000000000.00, N'Sản xuất', N'Thép', 'Manufacturing', 'Steel', N'Common Stock'),
('MSN', N'Tập đoàn Masan', 1500000000000.00, N'Tiêu dùng', N'Hàng tiêu dùng', 'Consumer Goods', 'Consumer Products', N'Common Stock'),
('VIC', N'Tập đoàn Vingroup', 3000000000000.00, N'Bất động sản', N'Phát triển bất động sản', 'Real Estate', 'Real Estate Development', N'Common Stock'),
('MWG', N'Tập đoàn Thế Giới Di Động', 1200000000000.00, N'Bán lẻ', N'Sản phẩm điện tử', 'Retail', 'Electronics', N'Common Stock'),
('SAB', N'Tổng công ty cổ phần Bia - Rượu - Nước giải khát Sài Gòn', 500000000000.00, N'Thực phẩm và đồ uống', N'Bia và rượu', 'Food & Beverage', 'Beer & Alcohol', N'Common Stock'),
('PLX', N'Tập đoàn Xăng dầu Việt Nam', 700000000000.00, N'Năng lượng', N'Xăng dầu', 'Energy', 'Oil & Gas', N'Common Stock'),
('VHM', N'Công ty cổ phần Vinhomes', 2000000000000.00, N'Bất động sản', N'Phát triển bất động sản', 'Real Estate', 'Real Estate Development', N'Common Stock');

go

select * from quotes

insert into quotes (stock_id, price, change, percent_change, volume, time_stamp)
values
(1, 102.50, 1.50, 1.49, 1200000, '2024-09-01 09:30:00'),
(2, 55.30, -0.70, -1.25, 850000, '2024-09-01 09:30:00'),
(3, 92.10, 2.10, 2.33, 600000, '2024-09-01 09:30:00'),
(4, 45.00, 0.50, 1.12, 750000, '2024-09-01 09:30:00'),
(5, 33.80, -0.30, -0.88, 900000, '2024-09-01 09:30:00'),
(6, 150.20, 2.20, 1.49, 500000, '2024-09-01 09:30:00'),
(7, 120.50, -1.50, -1.23, 650000, '2024-09-01 09:30:00'),
(8, 78.90, 1.00, 1.28, 300000, '2024-09-01 09:30:00'),
(9, 67.45, 0.95, 1.43, 400000, '2024-09-01 09:30:00'),
(10, 98.70, -1.20, -1.20, 550000, '2024-09-01 09:30:00');


select * from market_indices

insert into market_indices (name, symbol)
values 
(N'S&P 500', 'SPX'),
(N'Nasdaq Composite', 'IXIC'),
(N'Dow Jones Industrial Average', 'DJIA'),
(N'FTSE 100', 'FTSE'),
(N'Nikkei 225', 'N225'),
(N'Shanghai Composite', 'SHCOMP'),
(N'DAX', 'DAX'),
(N'CAC 40', 'CAC'),
(N'Hang Seng Index', 'HSI'),
(N'Russell 2000', 'RUT'),
(N'Topix', 'TOPX'),
(N'ASX 200', 'AS51'),
(N'Euro Stoxx 50', 'STOXX50E'),
(N'KOSPI', 'KOSPI'),
(N'S&P BSE Sensex', 'SENSEX'),
(N'Ibovespa', 'BVSP'),
(N'TSX Composite', 'TSX'),
(N'Merval', 'MERVAL'),
(N'STRAITS TIMES INDEX', 'STI'),
(N'Taiex', 'TWII');

go 

select * from index_constituents
insert into index_constituents (index_id, stock_id)
values 
(1, 1),   -- Vinamilk (VNM) vào chỉ số S&P 500
(1, 2),   -- FPT vào chỉ số S&P 500
(2, 3),   -- Vietcombank (VCB) vào chỉ số Nasdaq Composite
(2, 4),   -- Hòa Phát (HPG) vào chỉ số Nasdaq Composite
(3, 5),   -- Masan (MSN) vào chỉ số Dow Jones Industrial Average
(3, 6),   -- Vingroup (VIC) vào chỉ số Dow Jones Industrial Average
(4, 7),   -- Thế Giới Di Động (MWG) vào chỉ số FTSE 100
(4, 8),   -- Sabeco (SAB) vào chỉ số FTSE 100
(5, 9),   -- Petrolimex (PLX) vào chỉ số Nikkei 225
(5, 10);  -- Vinhomes (VHM) vào chỉ số Nikkei 225

go
select * from stocks
select * from index_constituents
select * from market_indices

-- drop view v_stock_index
go

create view v_stock_index as 
select 
    s.stock_id, 
    s.symbol, 
    s.company_name, 
    s.market_cap, 
    s.sector, 
    s.sector_en,
    s.industry,
    s.industry_en,
    s.stock_type,
    i.index_id,
    m.symbol as index_symbol,
    m.name as index_name
from stocks as s
inner join index_constituents as i
on s.stock_id = i.stock_id
inner join market_indices as m
on m.index_id = i.index_id

go 

select 
    v.index_symbol,
    v.index_name,
    v.symbol as stock_symbol,
    v.company_name
from v_stock_index as v
where v.index_symbol = 'DJIA'
order by v.index_symbol

select 
    v.index_symbol,
    v.index_name,
    count(v.symbol) as total_companies
from v_stock_index as v
group by v.index_symbol, v.index_name
order by v.index_symbol;

select count(*) as total_companies
from v_stock_index
where market_cap > 1000000000000

select
    v.symbol,
    format(v.market_cap, '#,##0')
from v_stock_index as v



insert into derivatives 
    (name, underlying_asset_id, contract_size, expiration_date, strike_price, last_price, change, percent_change, open_price, high_price, low_price, volume, open_interest, time_stamp)
values
    (N'Hợp đồng tương lai Vinamilk', 1, 100, '2024-12-31', 105.50, 102.50, -3.00, -2.85, 103.00, 104.00, 101.00, 1500, 200, '2024-09-01 09:30:00'),
    (N'Hợp đồng tương lai FPT', 2, 200, '2024-11-30', 58.00, 55.30, -2.70, -4.66, 56.00, 57.00, 54.50, 1200, 150, '2024-09-01 09:30:00'),
    (N'Hợp đồng quyền chọn Vietcombank', 3, 500, '2024-10-15', 95.00, 92.10, -2.90, -3.05, 93.00, 94.00, 91.50, 800, 300, '2024-09-01 09:30:00'),
    (N'Hợp đồng tương lai Hòa Phát', 4, 300, '2024-09-30', 47.00, 45.00, -2.00, -4.26, 46.00, 46.50, 44.50, 900, 250, '2024-09-01 09:30:00'),
    (N'Hợp đồng quyền chọn Masan', 5, 150, '2024-12-01', 35.00, 33.80, -1.20, -3.43, 34.50, 34.80, 33.50, 1100, 180, '2024-09-01 09:30:00'),
    (N'Hợp đồng tương lai Vingroup', 6, 400, '2024-12-31', 152.00, 150.20, -1.80, -1.18, 151.00, 151.50, 149.00, 700, 350, '2024-09-01 09:30:00'),
    (N'Hợp đồng tương lai Thế Giới Di Động', 7, 250, '2024-11-15', 123.00, 120.50, -2.50, -2.03, 121.00, 122.50, 119.50, 850, 220, '2024-09-01 09:30:00'),
    (N'Hợp đồng quyền chọn Sabeco', 8, 100, '2024-09-20', 80.00, 78.90, -1.10, -1.38, 79.50, 80.00, 78.00, 950, 140, '2024-09-01 09:30:00'),
    (N'Hợp đồng tương lai Petrolimex', 9, 150, '2024-10-30', 69.00, 67.45, -1.55, -2.25, 68.00, 68.50, 67.00, 1000, 175, '2024-09-01 09:30:00'),
    (N'Hợp đồng quyền chọn Vinhomes', 10, 500, '2024-11-05', 100.00, 98.70, -1.30, -1.30, 99.50, 100.50, 98.00, 600, 130, '2024-09-01 09:30:00');
go 

select 
    d.underlying_asset_id,
    d.name
from derivatives as d
order by underlying_asset_id

go
drop view v_stocks_derivatives
go
create view v_stocks_derivatives
as
select 
    s.*,
    d.*
from stocks s
inner join derivatives d on s.stock_id = d.underlying_asset_id
go

select
    v.stock_id,
    v.symbol,
    v.company_name,
    v.derivatives_id,
    v.name as derivative_name
from v_stocks_derivatives v
order by stock_id
go

select 
    symbol,
    company_name,
    count(derivatives_id) as num_derivatives
from v_stocks_derivatives
group by symbol, company_name


insert into covered_warrants 
    (name, underlying_asset_id, issue_date, expiration_date, strike_price, warrant_type)
values
    (N'Chứng quyền Vinamilk mua', 1, '2024-01-01', '2024-12-31', 105.50, N'Call'),
    (N'Chứng quyền FPT bán', 2, '2024-02-01', '2024-11-30', 60.00, N'Put'),
    (N'Chứng quyền Vietcombank mua', 3, '2024-03-01', '2024-10-15', 95.00, N'Call'),
    (N'Chứng quyền Hòa Phát bán', 4, '2024-04-01', '2024-09-30', 50.00, N'Put'),
    (N'Chứng quyền Masan mua', 5, '2024-01-15', '2024-12-01', 35.00, N'Call'),
    (N'Chứng quyền Vingroup mua', 6, '2024-02-15', '2024-12-31', 155.00, N'Call'),
    (N'Chứng quyền Thế Giới Di Động bán', 7, '2024-05-01', '2024-11-15', 125.00, N'Put'),
    (N'Chứng quyền Sabeco mua', 8, '2024-06-01', '2024-09-20', 80.00, N'Call'),
    (N'Chứng quyền Petrolimex bán', 9, '2024-07-01', '2024-10-30', 70.00, N'Put'),
    (N'Chứng quyền Vinhomes mua', 10, '2024-08-01', '2024-11-05', 100.00, N'Call');

select * from covered_warrants

select 'Sell' as order_type, count(*) as num_orders
from covered_warrants
where warrant_type = 'Call'
union all
select 'Buy' as order_type, count(*) as num_orders
from covered_warrants
where warrant_type = 'Put'


select * from etfs

ALTER TABLE etf_quotes CHECK CONSTRAINT ALL;
ALTER TABLE etf_holdings CHECK CONSTRAINT ALL;

select * from stocks;

select name, object_name(parent_object_id) as table_name
from sys.foreign_keys
where referenced_object_id = object_id('stocks')

select count(*) from stocks where stock_type = 'ETF' and sector_en = 'Food'

select * from etf_holdings

select * from stocks

select * from etfs

select * from watchlists

select count(*) from orders

select * from users

select * from portfolios

INSERT INTO educational_resources (title, content, category, date_published)
VALUES 
(N'Tổng quan về đầu tư chứng khoán', 
N'Bài viết này cung cấp kiến thức cơ bản về đầu tư chứng khoán, bao gồm cách thị trường hoạt động và các yếu tố ảnh hưởng đến giá cổ phiếu.',
N'Đầu tư', 
'2024-01-15'),

(N'Chiến lược giao dịch theo xu hướng', 
N'Chiến lược giao dịch theo xu hướng là phương pháp sử dụng các chỉ báo kỹ thuật để xác định xu hướng thị trường và giao dịch theo hướng đó.',
N'Chiến lược giao dịch', 
'2024-02-05'),

(N'Quản lý rủi ro trong đầu tư cổ phiếu', 
N'Bài viết này cung cấp cách thức quản lý rủi ro khi đầu tư cổ phiếu, bao gồm việc đa dạng hóa danh mục và thiết lập các mức cắt lỗ.',
N'Quản lý rủi ro', 
'2024-03-10'),

(N'Phân tích cơ bản trong đầu tư chứng khoán', 
N'Phân tích cơ bản là phương pháp đánh giá giá trị của cổ phiếu dựa trên các yếu tố tài chính và kinh tế như doanh thu, lợi nhuận và nợ.',
N'Đầu tư', 
'2024-04-22'),

(N'Tâm lý thị trường và hành vi nhà đầu tư', 
N'Bài viết này khám phá tác động của tâm lý thị trường và hành vi của nhà đầu tư lên giá cổ phiếu, bao gồm cả hiệu ứng đám đông và sự tham lam.',
N'Tâm lý thị trường', 
'2024-05-12');

select * from educational_resources

INSERT INTO linked_bank_accounts (user_id, bank_name, account_number, routing_number, account_type)
VALUES 
(1, N'Vietcombank', '12345678901234', 'VCB123456', 'checking'),
(2, N'Techcombank', '98765432109876', 'TCB987654', 'savings'),
(3, N'Vietinbank', '11112222333344', 'VTB111122', 'checking'),
(4, N'BIDV', '44443333222211', 'BIDV444433', 'savings'),
(5, N'Sacombank', '55556666777788', 'SCB555566', 'checking'),
(6, N'ACB', '99990000111122', 'ACB999900', 'savings'),
(7, N'MB Bank', '66667777888899', 'MB666677', 'checking'),
(8, N'VPBank', '12344321123456', 'VPB123443', 'savings'),
(9, N'Eximbank', '87654321876543', 'EXIM876543', 'checking'),
(10, N'OCB', '12121212121212', 'OCB121212', 'savings'),
(11, N'HSBC', '89898989898989', 'HSBC898989', 'checking'),
(1, N'VIB', '90909090909090', 'VIB909090', 'savings'),
(2, N'SCB', '23232323232323', 'SCB232323', 'checking'),
(3, N'DongABank', '34343434343434', 'DAB343434', 'savings'),
(4, N'TPB Bank', '45454545454545', 'TPB454545', 'checking'),
(5, N'NamABank', '56565656565656', 'NAB565656', 'savings'),
(6, N'PVcomBank', '67676767676767', 'PVB676767', 'checking'),
(7, N'SHB', '78787878787878', 'SHB787878', 'savings'),
(8, N'ABBank', '89898989898912', 'ABB898989', 'checking'),
(9, N'SeABank', '90909090909078', 'SEAB909090', 'savings');

select * from linked_bank_accounts
/*

viết một trigger sau khi thêm dữ liệu vào bảng orders:
- insert hoặc update dữ liệu stock_id và quantity vào bảng portfolios
- insert dữ liệu vào bảng notifications
- insert dữ liệu vào bảng transactions

Nếu orders.direction là "buy" thì transaction_type là "withdrawal"
Nếu orders.direction là "Sell" thì transaction_type là "deposit"

orders(order_id, user_id, stock_id, order_type, direction, quantity, price, status, order_date)

portfolios(user_id, stock_id, quantity, purchase_price, purchase_date)

notifications(notification_id, user_id, notification_type, content, is_read, created_at)

transactions(transaction_id, user_id, linked_account_id, transaction_type, amount, transaction_date)
*/
GO

drop trigger trg_after_insert_orders
go

CREATE TRIGGER trg_after_insert_orders
ON orders
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Khai báo các biến tạm thời
    DECLARE @user_id INT;
    DECLARE @stock_id INT;
    DECLARE @quantity INT;
    DECLARE @price DECIMAL(18,4);
    DECLARE @order_date DATETIME;
    DECLARE @direction NVARCHAR(20);

    -- Lấy giá trị từ bảng INSERTED
    SELECT @user_id = i.user_id, 
           @stock_id = i.stock_id, 
           @quantity = i.quantity, 
           @price = i.price, 
           @order_date = i.order_date, 
           @direction = i.direction
    FROM inserted i;

    -- Debugging với PRINT để xem các giá trị
    PRINT 'Inserting into portfolios for user_id: ' + CAST(@user_id AS NVARCHAR(10));
    PRINT 'Inserting into portfolios for stock_id: ' + CAST(@stock_id AS NVARCHAR(10));
    PRINT 'Quantity: ' + CAST(@quantity AS NVARCHAR(10));
    PRINT 'Price: ' + CAST(@price AS NVARCHAR(20));  -- Đã sửa lỗi ở đây, không cần (18,4) cho NVARCHAR
    PRINT 'Order Date: ' + CAST(@order_date AS NVARCHAR(20));
    PRINT 'Direction: ' + @direction;

    -- Insert hoặc Update vào bảng portfolios
    IF EXISTS (SELECT 1 FROM portfolios WHERE user_id = @user_id AND stock_id = @stock_id)
    BEGIN
        -- Cập nhật nếu đã tồn tại user_id và stock_id trong portfolios
        UPDATE portfolios
        SET quantity = quantity + @quantity, 
            purchase_price = @price, 
            purchase_date = @order_date
        WHERE user_id = @user_id AND stock_id = @stock_id;
    END
    ELSE
    BEGIN
        -- Thêm mới nếu chưa tồn tại
        INSERT INTO portfolios (user_id, stock_id, quantity, purchase_price, purchase_date)
        VALUES (@user_id, @stock_id, @quantity, @price, @order_date);
    END;

    -- Insert vào bảng notifications
    INSERT INTO notifications (user_id, notification_type, content, is_read, created_at)
    VALUES (@user_id, 
           'Order Notification', 
           CONCAT('Your ', @direction, ' order for ', @quantity, ' shares of stock ID ', @stock_id, ' has been placed.'), 
           0, 
           GETDATE());

    -- Insert vào bảng transactions
    INSERT INTO transactions (user_id, linked_account_id, transaction_type, amount, transaction_date)
    VALUES (@user_id, 
            NULL,  -- linked_account_id có thể được điều chỉnh nếu cần
            CASE WHEN @direction = 'buy' THEN 'withdrawal' ELSE 'deposit' END, 
            @quantity * @price, 
            @order_date);
    
END;



INSERT INTO orders (user_id, stock_id, order_type, direction, quantity, price, status, order_date)
VALUES (1, 10, 'market', 'buy', 100, 50.75, 'pending', GETDATE());

INSERT INTO orders (user_id, stock_id, order_type, direction, quantity, price, status, order_date)
VALUES (2, 15, 'limit', 'sell', 200, 75.50, 'executed', GETDATE());

select * from orders where user_id = 2 and stock_id = 15
SELECT * FROM portfolios WHERE user_id = 2 AND stock_id = 15;
SELECT * FROM notifications WHERE user_id = 2;
SELECT * FROM transactions WHERE user_id = 2 ORDER BY transaction_date DESC;

go
create trigger trg_update_created_at
on notifications
after INSERT
as 
begin 
    update notifications SET created_at = GETDATE()
    where notification_id in (select notification_id from inserted)
end

drop view view_quotes_realtime
go
create view view_quotes_realtime as 
select distinct 
    q.quote_id,
    s.symbol,
    s.company_name,
    m.name as index_name,
    m.symbol as index_symbol,
    s.market_cap,
    s.sector_en,
    s.industry_en,
    s.sector,
    s.industry,
    s.stock_type,
    q.price,
    q.change,
    q.percent_change,
    q.volume,
    q.time_stamp
from quotes q
inner join stocks s on q.stock_id = s.stock_id
inner join index_constituents i on s.stock_id = i.stock_id
inner join market_indices m on i.index_id = m.index_id
where q.time_stamp >= (select max(time_stamp) from quotes where stock_id = q.stock_id)
go

select distinct
    symbol, quote_id, time_stamp
from view_quotes_realtime 
order by symbol

truncate table quotes

select * from quotes

/*
create table quotes(
    quote_id int primary key identity(1,1),
    stock_id int,
    price decimal(18,2) not null,                   -- Giá cổ phiếu
    change decimal(18,2) not null,                  -- Biến động giá cổ phiếu so với ngày trước đó
    percent_change decimal(18,2) not null,          -- Tỉ lệ biến đổi giá cổ phiếu so với ngày trước đó
    volume int not null,                            -- Khối lượng giao dịch trong ngày
    time_stamp datetime not null                    -- Thời điểm cập nhật giá cổ phiếu
)

*/



