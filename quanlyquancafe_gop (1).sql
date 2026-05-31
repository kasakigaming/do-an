-- =================================================================
-- FILE: quanlyquancafe_gop.sql
-- Gop tu 3 file: quanlyquancafe4.sql + quanlyquancafe4 (1).sql + quanlyquancafe4_full.sql
-- Database: quanlyquancoffe
-- Noi dung:
--   - Tao DB + toan bo bang (gom ca bang khuyenmai)
--   - 5 vai tro, 5 tai khoan, 5 nhan vien
--   - 10 san pham, 7 khach hang, 6 ban
--   - 38 hoa don rai deu 3 thang (3-4-5/2026) + chi tiet hoa don
--   - Du lieu khuyen mai
--   - Query kiem tra bao cao o cuoi
-- =================================================================

-- 1. Tao database neu chua ton tai
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'quanlyquancoffe')
BEGIN
    CREATE DATABASE quanlyquancoffe;
END
GO

USE quanlyquancoffe;
GO

-- 2. Xoa bang cu (dung thu tu FK)
DROP TABLE IF EXISTS quyennguoidung;
DROP TABLE IF EXISTS chitiethoadon;
DROP TABLE IF EXISTS chitietnhaphang;
DROP TABLE IF EXISTS hoadon;
DROP TABLE IF EXISTS phieunhap;
DROP TABLE IF EXISTS tonkho;
DROP TABLE IF EXISTS khuyenmai;
DROP TABLE IF EXISTS nhanvien;
DROP TABLE IF EXISTS taikhoan;
DROP TABLE IF EXISTS sanpham;
DROP TABLE IF EXISTS nhacungcap;
DROP TABLE IF EXISTS khachhang;
DROP TABLE IF EXISTS quyen;
DROP TABLE IF EXISTS vaitro;
DROP TABLE IF EXISTS danhmuc;
DROP TABLE IF EXISTS ban;
GO

-- =================================================================
-- 3. TAO BANG
-- =================================================================
CREATE TABLE vaitro (
    vaitroid  INT IDENTITY PRIMARY KEY,
    tenvaitro NVARCHAR(50),
    mota      NVARCHAR(255)
);

CREATE TABLE quyen (
    quyenid  INT IDENTITY PRIMARY KEY,
    maquyen  NVARCHAR(50),
    tenquyen NVARCHAR(100)
);

CREATE TABLE quyennguoidung (
    vaitroid INT,
    quyenid  INT,
    PRIMARY KEY (vaitroid, quyenid),
    FOREIGN KEY (vaitroid) REFERENCES vaitro(vaitroid),
    FOREIGN KEY (quyenid)  REFERENCES quyen(quyenid)
);

CREATE TABLE taikhoan (
    taikhoanid  INT IDENTITY PRIMARY KEY,
    tendangnhap NVARCHAR(100) NOT NULL,
    matkhau     NVARCHAR(100) NOT NULL,
    vaitroid    INT,
    trangthai   BIT      DEFAULT 1,
    ngaytao     DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (vaitroid) REFERENCES vaitro(vaitroid)
);

CREATE TABLE nhanvien (
    nhanvienid  INT IDENTITY PRIMARY KEY,
    taikhoanid  INT,
    hoten       NVARCHAR(100),
    ngaysinh    DATE,
    gioitinh    NVARCHAR(10),
    diachi      NVARCHAR(255),
    sodienthoai NVARCHAR(20),
    email       NVARCHAR(100),
    ngaybatdau  DATE,
    ghichu      NVARCHAR(255),
    FOREIGN KEY (taikhoanid) REFERENCES taikhoan(taikhoanid)
);

CREATE TABLE khachhang (
    khachhangid  INT IDENTITY PRIMARY KEY,
    tenkhachhang NVARCHAR(100),
    diachi       NVARCHAR(255),
    sodienthoai  NVARCHAR(20),
    email        NVARCHAR(100),
    diemtichluy  INT DEFAULT 0
);

CREATE TABLE danhmuc (
    danhmucid  INT IDENTITY PRIMARY KEY,
    tendanhmuc NVARCHAR(100),
    mota       NVARCHAR(255)
);

CREATE TABLE sanpham (
    sanphamid  INT IDENTITY PRIMARY KEY,
    danhmucid  INT,
    tensanpham NVARCHAR(100),
    donvitinh  NVARCHAR(50),
    gianhap    DECIMAL(18,2),
    giaban     DECIMAL(18,2),
    mota       NVARCHAR(255),
    FOREIGN KEY (danhmucid) REFERENCES danhmuc(danhmucid)
);

CREATE TABLE tonkho (
    tonkhoid  INT IDENTITY PRIMARY KEY,
    sanphamid INT,
    soluong   INT DEFAULT 0,
    FOREIGN KEY (sanphamid) REFERENCES sanpham(sanphamid)
);

CREATE TABLE nhacungcap (
    nhacungcapid  INT IDENTITY PRIMARY KEY,
    tennhacungcap NVARCHAR(100),
    diachi        NVARCHAR(255),
    sodienthoai   NVARCHAR(20),
    email         NVARCHAR(100)
);

CREATE TABLE phieunhap (
    phieunhapid  INT IDENTITY PRIMARY KEY,
    nhacungcapid INT,
    nhanvienid   INT,
    ngaynhap     DATETIME DEFAULT GETDATE(),
    tongtien     DECIMAL(18,2),
    FOREIGN KEY (nhacungcapid) REFERENCES nhacungcap(nhacungcapid),
    FOREIGN KEY (nhanvienid)   REFERENCES nhanvien(nhanvienid)
);

CREATE TABLE chitietnhaphang (
    chitietnhapid INT IDENTITY PRIMARY KEY,
    phieunhapid   INT,
    sanphamid     INT,
    soluong       INT,
    dongia        DECIMAL(18,2),
    ghichu        NVARCHAR(255),
    FOREIGN KEY (phieunhapid) REFERENCES phieunhap(phieunhapid),
    FOREIGN KEY (sanphamid)   REFERENCES sanpham(sanphamid)
);

CREATE TABLE ban (
    banid     INT IDENTITY PRIMARY KEY,
    tenban    NVARCHAR(100) NOT NULL DEFAULT N'Chua dat ten',
    trangthai NVARCHAR(100) NOT NULL DEFAULT N'Trong'
);

CREATE TABLE hoadon (
    hoadonid    INT IDENTITY PRIMARY KEY,
    nhanvienid  INT,
    khachhangid INT,
    banid       INT NULL,
    ngaylap     DATETIME DEFAULT GETDATE(),
    tongtien    DECIMAL(18,2),
    FOREIGN KEY (nhanvienid)  REFERENCES nhanvien(nhanvienid),
    FOREIGN KEY (khachhangid) REFERENCES khachhang(khachhangid),
    CONSTRAINT fk_hoadon_ban FOREIGN KEY (banid) REFERENCES ban(banid)
);

CREATE TABLE chitiethoadon (
    chitiethoadonid INT IDENTITY PRIMARY KEY,
    hoadonid        INT,
    sanphamid       INT,
    soluong         INT,
    dongia          DECIMAL(18,2),
    ghichu          NVARCHAR(255),
    FOREIGN KEY (hoadonid)  REFERENCES hoadon(hoadonid),
    FOREIGN KEY (sanphamid) REFERENCES sanpham(sanphamid)
);

-- Bang khuyenmai (lay tu file quanlyquancafe4 (1).sql)
CREATE TABLE khuyenmai (
    khuyenmaiid  INT IDENTITY PRIMARY KEY,
    tenkhuyenmai NVARCHAR(100) NOT NULL,
    mucgiam      DECIMAL(18,2) NOT NULL DEFAULT 0,
    ngaybatdau   DATE NULL,
    ngayketthuc  DATE NULL,
    trangthai    NVARCHAR(50) NOT NULL DEFAULT N'Dang ap dung',
    ghichu       NVARCHAR(255) NULL
);
GO

-- =================================================================
-- 4. DU LIEU DANH MUC HE THONG
-- =================================================================

-- Vai tro (5 - gop tu file (1))
INSERT INTO vaitro (tenvaitro, mota) VALUES
(N'Admin',     N'Toan quyen he thong'),
(N'NhanVien',  N'Quan ly ban hang'),
(N'ThuNgan',   N'Thu ngan ban hang'),
(N'QuanLyKho', N'Quan ly kho va nhap hang'),
(N'QuanLyCa',  N'Quan ly ca lam viec');

-- Quyen (5)
INSERT INTO quyen (maquyen, tenquyen) VALUES
('QL_NV',   N'Quan ly nhan vien'),
('QL_SP',   N'Quan ly san pham'),
('QL_HD',   N'Quan ly hoa don'),
('QL_NHAP', N'Quan ly nhap hang'),
('XEM_BC',  N'Xem bao cao');

-- Gan toan bo quyen cho Admin (vaitroid = 1) + phan quyen cac vai tro khac
INSERT INTO quyennguoidung (vaitroid, quyenid)
SELECT 1, quyenid FROM quyen;

INSERT INTO quyennguoidung (vaitroid, quyenid) VALUES
(2, 2),
(2, 3),
(3, 3),
(4, 4),
(5, 5);

-- =================================================================
-- 5. TAI KHOAN & NHAN VIEN (5 nguoi)
-- =================================================================
INSERT INTO taikhoan (tendangnhap, matkhau, vaitroid, trangthai) VALUES
('admin',     'admin',  1, 1),   -- ID 1  Admin
('nhanvien1', '123456', 2, 1),   -- ID 2  NhanVien
('nhanvien2', '123456', 2, 1),   -- ID 3  NhanVien
('thungan1',  '123456', 3, 1),   -- ID 4  ThuNgan
('kho1',      '123456', 4, 1);   -- ID 5  QuanLyKho

INSERT INTO nhanvien (taikhoanid, hoten, gioitinh, sodienthoai, email, ngaybatdau) VALUES
(1, N'Quan Tri Vien',   N'Nam', '0000000000', 'admin@cafe.com', '2023-01-01'),
(2, N'Nguyen Thi Hoa',  N'Nu',  '0912345678', 'hoa@cafe.com',   '2024-01-15'),
(3, N'Tran Van Minh',   N'Nam', '0923456789', 'minh@cafe.com',  '2024-03-01'),
(4, N'Le Thi Thu Hang', N'Nu',  '0934567890', 'hang@cafe.com',  '2024-06-01'),
(5, N'Pham Van Kho',    N'Nam', '0945678901', 'kho@cafe.com',   '2024-09-01');

-- =================================================================
-- 6. KHACH HANG (7 nguoi)
-- =================================================================
INSERT INTO khachhang (tenkhachhang, sodienthoai, email, diemtichluy) VALUES
(N'Khach le',      '1111111111', 'guest@gmail.com', 0),
(N'Nguyen Van A',  '2222222222', 'a@gmail.com',     10),
(N'Pham Van Binh', '0945001001', 'binh@gmail.com',  25),
(N'Hoang Thi Lan', '0945002002', 'lan@gmail.com',   40),
(N'Do Minh Tuan',  '0945003003', 'tuan@gmail.com',  15),
(N'Vu Thi Ngoc',   '0945004004', 'ngoc@gmail.com',  60),
(N'Bui Van Duc',   '0945005005', 'duc@gmail.com',   10);

-- =================================================================
-- 7. DANH MUC & SAN PHAM (10 mon)
-- =================================================================
INSERT INTO danhmuc (tendanhmuc, mota) VALUES
(N'Ca phe', N'Do uong ca phe'),
(N'Tra',    N'Do uong tra'),
(N'Do an',  N'Mon an nhe');

-- sanphamid 1-10
INSERT INTO sanpham (danhmucid, tensanpham, donvitinh, gianhap, giaban, mota) VALUES
(1, N'Ca phe den',        N'ly',  10000, 20000, N'Ca phe den da'),          -- 1
(1, N'Ca phe sua',        N'ly',  12000, 25000, N'Ca phe sua da'),          -- 2
(1, N'Ca phe Latte',      N'ly',  15000, 35000, N'Ca phe sua tuoi'),        -- 3
(1, N'Cappuccino',        N'ly',  18000, 40000, N'Cappuccino thuong hang'), -- 4
(2, N'Tra dao',           N'ly',  15000, 30000, N'Tra dao mat lanh'),       -- 5
(2, N'Tra sua tran chau', N'ly',  20000, 45000, N'Tra sua tran chau den'),  -- 6
(2, N'Tra chanh',         N'ly',  10000, 25000, N'Tra chanh mat lanh'),     -- 7
(3, N'Banh mi',           N'cai',  8000, 15000, N'Banh mi thit'),           -- 8
(3, N'Banh flan',         N'cai', 12000, 28000, N'Banh flan beo min'),      -- 9
(3, N'Sandwich',          N'cai', 20000, 45000, N'Sandwich thit nguoi');    -- 10

-- Ton kho ban dau
INSERT INTO tonkho (sanphamid, soluong) VALUES
(1,150),(2,150),(3,120),(4,100),
(5,150),(6,130),(7,160),(8,200),(9,100),(10,80);

-- =================================================================
-- 8. NHA CUNG CAP & PHIEU NHAP
-- =================================================================
INSERT INTO nhacungcap (tennhacungcap, diachi, sodienthoai, email) VALUES
(N'Cong ty Cafe Trung Nguyen', N'Ha Noi', '0901111111', 'info@trungnguyen.vn'),
(N'Cong ty Tra Oolong',        N'Da Lat', '0902222222', 'contact@oolong.vn');

INSERT INTO phieunhap (nhacungcapid, nhanvienid, tongtien) VALUES
(1, 1, 3000000),
(2, 1, 2000000);

INSERT INTO chitietnhaphang (phieunhapid, sanphamid, soluong, dongia) VALUES
(1,1,100,10000),(1,2,100,12000),(1,3, 80,15000),(1,4, 60,18000),
(2,5,100,15000),(2,6, 80,20000),(2,7,100,10000),(2,8,150, 8000);

-- =================================================================
-- 9. BAN
-- =================================================================
INSERT INTO ban (tenban, trangthai) VALUES
(N'Ban 1',   N'Trong'),
(N'Ban 2',   N'Trong'),
(N'Ban 3',   N'Trong'),
(N'Ban 4',   N'Trong'),
(N'Ban 5',   N'Trong'),
(N'Ban VIP', N'Trong');

-- =================================================================
-- 10. HOA DON + CHI TIET (rai deu 3 thang: 3-4-5/2026)
--     Nhan vien ban: NV2 (Hoa), NV3 (Minh), NV4 (Hang)
-- =================================================================

-- THANG 3/2026 (12 hoa don)
INSERT INTO hoadon (nhanvienid,khachhangid,banid,ngaylap,tongtien) VALUES
(2,1,1,'2026-03-02 08:30',  60000),  -- HD 1
(3,2,2,'2026-03-04 09:00',  95000),  -- HD 2
(2,3,3,'2026-03-06 10:15',  70000),  -- HD 3
(4,4,4,'2026-03-08 14:00', 120000),  -- HD 4
(3,5,5,'2026-03-10 15:30',  80000),  -- HD 5
(2,6,6,'2026-03-12 08:00', 105000),  -- HD 6
(4,7,1,'2026-03-14 11:00',  45000),  -- HD 7
(3,1,2,'2026-03-16 16:00',  90000),  -- HD 8
(2,2,3,'2026-03-18 09:30', 130000),  -- HD 9
(4,3,4,'2026-03-20 10:00',  75000),  -- HD 10
(3,4,5,'2026-03-24 14:30', 110000),  -- HD 11
(2,5,6,'2026-03-27 15:00',  85000);  -- HD 12

-- THANG 4/2026 (14 hoa don)
INSERT INTO hoadon (nhanvienid,khachhangid,banid,ngaylap,tongtien) VALUES
(3,1,1,'2026-04-01 08:00',  90000),  -- HD 13
(2,2,2,'2026-04-03 09:30', 115000),  -- HD 14
(4,3,3,'2026-04-05 10:00',  65000),  -- HD 15
(3,4,4,'2026-04-07 14:00', 145000),  -- HD 16
(2,5,5,'2026-04-09 15:30',  80000),  -- HD 17
(4,6,6,'2026-04-11 08:30', 100000),  -- HD 18
(3,7,1,'2026-04-13 11:30', 125000),  -- HD 19
(2,1,2,'2026-04-15 16:30',  55000),  -- HD 20
(4,2,3,'2026-04-17 09:00', 150000),  -- HD 21
(3,3,4,'2026-04-19 10:00',  72000),  -- HD 22
(2,4,5,'2026-04-21 14:00', 110000),  -- HD 23
(4,5,6,'2026-04-23 15:00',  88000),  -- HD 24
(3,6,1,'2026-04-25 08:30', 135000),  -- HD 25
(2,7,2,'2026-04-28 11:00',  95000);  -- HD 26

-- THANG 5/2026 (12 hoa don, den ngay 22/05)
INSERT INTO hoadon (nhanvienid,khachhangid,banid,ngaylap,tongtien) VALUES
(4,1,1,'2026-05-02 08:00',  95000),  -- HD 27
(3,2,2,'2026-05-04 09:30', 120000),  -- HD 28
(2,3,3,'2026-05-06 10:00',  70000),  -- HD 29
(4,4,4,'2026-05-08 14:30', 160000),  -- HD 30
(3,5,5,'2026-05-10 15:00',  85000),  -- HD 31
(2,6,6,'2026-05-12 08:30', 105000),  -- HD 32
(4,7,1,'2026-05-14 11:00', 130000),  -- HD 33
(3,1,2,'2026-05-16 16:00',  92000),  -- HD 34
(2,2,3,'2026-05-18 09:30', 155000),  -- HD 35
(4,3,4,'2026-05-19 10:00',  78000),  -- HD 36
(3,4,5,'2026-05-21 14:00', 115000),  -- HD 37
(2,5,6,'2026-05-22 10:30',  68000);  -- HD 38

-- =================================================================
-- 11. CHI TIET HOA DON (moi hoa don 2-4 dong san pham)
-- =================================================================
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(1,1,2,20000),(1,9,1,28000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(2,2,2,25000),(2,6,1,45000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(3,5,2,30000),(3,8,1,15000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(4,3,2,35000),(4,6,1,45000),(4,7,1,25000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(5,4,1,40000),(5,8,2,15000),(5,9,1,28000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(6,6,1,45000),(6,3,1,35000),(6,7,1,25000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(7,1,1,20000),(7,5,1,30000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(8,4,1,40000),(8,10,1,45000),(8,7,1,25000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(9,3,2,35000),(9,6,1,45000),(9,8,1,15000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(10,2,2,25000),(10,5,1,30000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(11,4,1,40000),(11,6,1,45000),(11,8,1,15000),(11,9,1,28000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(12,3,1,35000),(12,10,1,45000),(12,8,1,15000);

INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(13,1,2,20000),(13,6,1,45000),(13,8,1,15000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(14,4,1,40000),(14,6,1,45000),(14,9,1,28000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(15,2,2,25000),(15,5,1,30000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(16,3,2,35000),(16,6,1,45000),(16,10,1,45000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(17,5,1,30000),(17,4,1,40000),(17,8,1,15000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(18,3,1,35000),(18,6,1,45000),(18,7,1,25000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(19,4,2,40000),(19,10,1,45000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(20,1,1,20000),(20,5,1,30000),(20,7,1,25000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(21,3,2,35000),(21,6,1,45000),(21,9,1,28000),(21,7,1,25000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(22,2,2,25000),(22,5,1,30000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(23,4,1,40000),(23,6,1,45000),(23,8,1,15000),(23,9,1,28000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(24,3,1,35000),(24,7,2,25000),(24,8,1,15000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(25,4,2,40000),(25,10,1,45000),(25,9,1,28000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(26,6,1,45000),(26,3,1,35000),(26,8,1,15000);

INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(27,3,1,35000),(27,6,1,45000),(27,8,1,15000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(28,4,1,40000),(28,6,1,45000),(28,9,1,28000),(28,7,1,25000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(29,5,1,30000),(29,2,1,25000),(29,8,1,15000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(30,4,2,40000),(30,6,1,45000),(30,10,1,45000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(31,3,1,35000),(31,9,1,28000),(31,7,1,25000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(32,6,1,45000),(32,4,1,40000),(32,7,1,25000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(33,3,2,35000),(33,6,1,45000),(33,9,1,28000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(34,4,1,40000),(34,5,1,30000),(34,8,1,15000),(34,7,1,25000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(35,3,2,35000),(35,6,1,45000),(35,10,1,45000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(36,5,1,30000),(36,2,2,25000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(37,4,1,40000),(37,6,1,45000),(37,8,2,15000);
INSERT INTO chitiethoadon(hoadonid,sanphamid,soluong,dongia) VALUES(38,3,1,35000),(38,7,1,25000),(38,8,1,15000);

-- =================================================================
-- 12. KHUYEN MAI (lay tu file quanlyquancafe4 (1).sql)
-- =================================================================
INSERT INTO khuyenmai (tenkhuyenmai, mucgiam, ngaybatdau, ngayketthuc, trangthai, ghichu) VALUES
(N'Giam 10 phan tram',     10, GETDATE(), DATEADD(DAY, 30, GETDATE()), N'Dang ap dung', N'Du lieu mau'),
(N'Giam 20 phan tram',     20, GETDATE(), DATEADD(DAY, 15, GETDATE()), N'Dang ap dung', N'Du lieu mau'),
(N'Uu dai thanh vien',     15, GETDATE(), DATEADD(DAY, 60, GETDATE()), N'Dang ap dung', N'Du lieu mau'),
(N'Khuyen mai cuoi tuan',  25, GETDATE(), DATEADD(DAY,  7, GETDATE()), N'Sap dien ra',  N'Ap dung thu bay chu nhat'),
(N'Mua 2 tang 1',          30, GETDATE(), DATEADD(DAY, 45, GETDATE()), N'Dang ap dung', N'Ap dung san pham chon loc');
GO

-- =================================================================
-- 13. KIEM TRA NHANH SAU KHI CHAY
-- =================================================================
SELECT N'--- KIEM TRA DU LIEU ---' AS Info;

SELECT
    FORMAT(ngaylap,'MM/yyyy')         AS Thang,
    COUNT(*)                          AS SoHoaDon,
    FORMAT(SUM(tongtien),'N0') + N' d' AS TongDoanhThu
FROM hoadon
GROUP BY FORMAT(ngaylap,'MM/yyyy')
ORDER BY Thang;

SELECT
    sp.tensanpham                     AS SanPham,
    SUM(ct.soluong)                   AS TongBan,
    FORMAT(SUM(ct.soluong * ct.dongia),'N0') + N' d' AS DoanhThu
FROM chitiethoadon ct
JOIN sanpham sp ON sp.sanphamid = ct.sanphamid
GROUP BY sp.tensanpham
ORDER BY TongBan DESC;

SELECT * FROM taikhoan;
SELECT * FROM khuyenmai;
