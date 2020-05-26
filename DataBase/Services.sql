USE master
GO
DROP DATABASE DB_SERVICES
GO
CREATE DATABASE DB_SERVICES
GO
USE DB_SERVICES
GO
CREATE TABLE TB_USERS		-- Người dùng
(
	UserId int IDENTITY PRIMARY KEY
	, Username nvarchar(30)
	, UserPassword nvarchar(30)
	, UserGG nvarchar(50)
	, UserFB nvarchar(50)
	, UserPhone nvarchar(20)	-- Số điện thoại
	, UserEmail nvarchar(50)	-- Email
	, UserAddress nvarchar(MAX)	-- Địa chỉ
	, UserType nvarchar(20)		-- Phân loại: ADMIN / STAFF
	, UserStatus nvarchar(20)	-- Trạng thái
	, UserNote nvarchar(100)	-- Ghi chú
)
GO
CREATE TABLE TB_TYPES	-- Loại dịch vụ (Cấu hình)
(
	TypeCode varchar(10) PRIMARY KEY	-- Loại dịch vụ: GTV, PH, VPR, VPA, TVDN, KTDN
	, TypeName nvarchar(50)			-- Tên dịch vụ: GÓI THÀNH VIÊN, PHÒNG HỌP, VP RIÊNG, VP ẢO, TVDN, KTDN
)
GO
CREATE TABLE TB_TYPE_DETAILS	-- Chi tiết dịch vụ (Cấu hình)
(
	TypeDetailId int IDENTITY PRIMARY KEY
	, TypeDetailName nvarchar(50)		-- Key
	, TypeDetailType varchar(50)		-- Loại giá trị: STRING, BOOL, INT

	, TypeDetailTypeCode varchar(10)
	, CONSTRAINT FK_TypeDetailTypeCode FOREIGN KEY (TypeDetailTypeCode) REFERENCES TB_TYPES(TypeCode)
)
GO
CREATE TABLE TB_SERVICES	-- Dịch vụ
(
	ServiceId int IDENTITY PRIMARY KEY

	, ServiceName nvarchar(50)		-- Tên dịch vụ
	, ServicePrice decimal(18,2)	-- Giá tiền
	, ServiceUnit nvarchar(30)		-- Đơn vị
	, ServiceBase nvarchar(50)		-- Cơ sở
	, ServiceContent nvarchar(MAX)	-- Giới thiệu
	
	, ServiceTypeCode varchar(10)
	, CONSTRAINT FK_ServiceTypeCode FOREIGN KEY (ServiceTypeCode) REFERENCES TB_TYPES(TypeCode)
)
GO
CREATE TABLE TB_SERVICE_DETAILS
(
	SrvDetailId int IDENTITY PRIMARY KEY
	, SrvDetailValue nvarchar(50)	-- Value

	, SrvDetailServiceId int
	, CONSTRAINT FK_SrvDetailServiceId FOREIGN KEY (SrvDetailServiceId) REFERENCES TB_SERVICES(ServiceId)
	, SrvTypeDetailId int
	, CONSTRAINT FK_SrvTypeDetailId FOREIGN KEY (SrvTypeDetailId) REFERENCES TB_TYPE_DETAILS(TypeDetailId)
)
GO
CREATE TABLE TB_FILES		-- Ảnh
(
	FileId int IDENTITY PRIMARY KEY
	, FileOrg nvarchar(50)		-- Tên gốc
	, FilePath nvarchar(50)		-- Đường dẫn
	, FileData nvarchar(MAX)	-- Base64
	, FileStatus nvarchar(20)	-- Trạng thái

	, FileType nvarchar(50)		-- Bảng: SERVICE / BLOG / ...
	, FileReferenceId nvarchar(50)	-- Khóa ngoại
)
GO
CREATE TABLE TB_REGISTERS	-- Đăng ký dịch vụ
(
	RegisterId int IDENTITY PRIMARY KEY
	
	, RegisterUserName nvarchar(50)		-- Tên
	, RegisterUserEmail nvarchar(50)	-- Email
	, RegisterUserPhone nvarchar(20)	-- Số điện thoại

	, RegisterCode nvarchar(30)		-- Mã đăng ký
	, RegisterDateCreate date		-- Ngày đăng ký
	, RegisterDateBegin date		-- Ngày bắt đầu
	, RegisterDateNumber int		-- Số ngày thuê
	, RegisterStatus nvarchar(20)	-- Trạng thái: 
	
	, RegisterServiceId int
	, CONSTRAINT FK_RegisterServiceId FOREIGN KEY (RegisterServiceId) REFERENCES TB_SERVICES(ServiceId)
	, RegisterUserId int
	, CONSTRAINT FK_RegisterUserId FOREIGN KEY (RegisterUserId) REFERENCES TB_USERS(UserId)
)
GO
CREATE TABLE TB_BLOGS		-- Tin tức, bài viết
(
	BlogId int IDENTITY PRIMARY KEY
	, BlogName nvarchar(50)		-- Tên bài viết
	, BlogContent nvarchar(MAX)	-- Nội dung
	, BlogDateCreate date		-- Ngày tạo
	, BlogType nvarchar(20)		-- Loại bài viết
	, BlogIsShow bit			-- Trạng thái hiển thị

	, BlogUserId int			-- Người viết
	, CONSTRAINT FK_BlogUserId FOREIGN KEY (BlogUserId) REFERENCES TB_USERS(UserId)
)
GO
CREATE TABLE TB_VOUCHERS	-- Khuyến mại
(
	VoucherId int IDENTITY PRIMARY KEY
	, VoucherDateCreate date	-- Ngày tạo
	, VoucherDateExpired date	-- Ngày hết hạn
	, VoucherType nvarchar(20)	-- Loại KM: AUTO / LIMITED
	, VoucherLimited int		-- Số lần giới hạn
	, VoucherState int			-- Trạng thái
	, VoucherNote nvarchar(MAX)	-- Mô tả
)
GO
CREATE TABLE TB_VOUCHER_DETAILS		-- Chi tiết KM
(
	VoucherDetailId int IDENTITY PRIMARY KEY
	, VoucherDetailCreate date		-- Ngày tạo
	, VoucherDetailCode varchar(20)		-- MÃ KM

	, VoucherDetailVoucherId int
	, CONSTRAINT FK_VoucherDetailVoucherId FOREIGN KEY (VoucherDetailVoucherId) REFERENCES TB_VOUCHERS(VoucherId)
)
GO
CREATE TABLE TB_PRODUCTS	-- Sản phẩm
(
	ProductCode varchar(20) PRIMARY KEY	-- Mã sản phẩm
	, ProductName nvarchar(50)	-- Tên sản phẩm
	, ProductPrice decimal(18,2)	-- Giá sản phẩm
)
GO
CREATE TABLE TB_ORDERS		-- Hóa đơn
(
	OrderCode varchar(20) PRIMARY KEY	-- Mã hóa đơn
	, OrderDateCreate date		-- Ngày tạo
	, OrderTotal decimal(18,2)	-- Tổng tiền
	, OrderVoucher varchar(20)	-- Mã KM
	, OrderState int			-- Trạng thái
	, OrderCurrentUserId int	-- Người đang thao tác

	, OrderUserId int			-- Người tạo
	, CONSTRAINT FK_OrderUserId FOREIGN KEY (OrderUserId) REFERENCES TB_USERS(UserId)
)
GO
CREATE TABLE TB_ORDER_DETAILS	-- Chi tiết hóa đơn
(
	OrderDetailId int IDENTITY PRIMARY KEY
	, OrderDetailNumber	int		-- Số lượng

	, OrderDetailOrderCode varchar(20)	-- Hóa đơn
	, CONSTRAINT FK_OrderDetailOrderCode FOREIGN KEY (OrderDetailOrderCode) REFERENCES TB_ORDERS(OrderCode)
	, OrderDetailProductCode varchar(20)	-- Sản phẩm
	, CONSTRAINT FK_OrderDetailProductCode FOREIGN KEY (OrderDetailProductCode) REFERENCES TB_PRODUCTS(ProductCode)
)
GO
INSERT INTO TB_TYPES(TypeCode, TypeName)
VALUES ('GTV', N'GÓI THÀNH VIÊN')
	, ('PH', N'PHÒNG HỌP')
	, ('VPR', N'VP RIÊNG')
	, ('VPA', N'VP ẢO')
	, ('TVDN', N'TƯ VẤN DOANH NGHIỆP')
	, ('KTDN', N'KẾ TOÁN DOANH NGHIỆP')
GO
INSERT INTO TB_TYPE_DETAILS(TypeDetailName, TypeDetailType, TypeDetailTypeCode)
VALUES (N'Thời gian làm việc', 'STRING', 'GTV')
	, (N'Phòng họp', 'BOOL', 'GTV')
	, (N'In ấn miễn phí', 'BOOL', 'GTV')
	, (N'Wifi tốc độ cao', 'BOOL', 'GTV')
	, (N'Lễ tân, nhận bưu phẩm', 'BOOL', 'GTV')
	, (N'Chỗ ngồi cố định', 'BOOL', 'GTV')
	, (N'Tủ để đồ miễn phí', 'BOOL', 'GTV')
	, (N'Trà, café', 'BOOL', 'GTV')
	, (N'Ghế Massage, Bàn Bi A, Bi Lắc, Bóng Bàn, ...', 'BOOL', 'GTV')
	, (N'Bếp và khu tiếp khách, vườn ngoài trời', 'BOOL', 'GTV')
	, (N'Kết nối BisHub', 'BOOL', 'GTV')
	, (N'Sự kiện BisHub', 'BOOL', 'GTV')
	, (N'3 gói Trải nghiệm miễn phí 1 ngày cho bạn bè', 'BOOL', 'GTV')
	, (N'Ưu đãi từ đối tác', 'BOOL', 'GTV')
	, (N'Thư viện sách', 'BOOL', 'GTV')
GO
INSERT INTO TB_TYPE_DETAILS(TypeDetailName, TypeDetailType, TypeDetailTypeCode)
VALUES (N'Sức chứa', 'STRING', 'PH')
	, (N'Thiết bị trình chiếu', 'BOOL', 'PH')
	, (N'Bảng Flipchart', 'BOOL', 'PH')
	, (N'HDMI', 'BOOL', 'PH')
	, (N'Loa, Micro hiện đại', 'BOOL', 'PH')
	, (N'Diện tích', 'STRING', 'PH')
	, (N'Tea break ngọt', 'STRING', 'PH')
	, (N'Trà cafe', 'STRING', 'PH')
GO
INSERT INTO TB_TYPE_DETAILS(TypeDetailName, TypeDetailType, TypeDetailTypeCode)
VALUES (N'Thời gian làm việc', 'STRING', 'VPR')
	, (N'Lễ tân', 'BOOL', 'VPR')
	, (N'Phòng họp', 'STRING', 'VPR')
	, (N'Số chỗ ngồi', 'INT', 'VPR')
	, (N'Trà café hòa tan', 'BOOL', 'VPR')
	, (N'Thư viện sách', 'BOOL', 'VPR')
	, (N'Ghế Massage, Bàn Bi A, Bi Lắc, ...', 'BOOL', 'VPR')
	, (N'Dịch vụ in ấn', 'STRING', 'VPR')
	, (N'Điện nước miễn phí', 'BOOL', 'VPR')
	, (N'Biển tên Công ty', 'BOOL', 'VPR')
	, (N'Dịch vụ bảo vệ', 'BOOL', 'VPR')
	, (N'Tiếp nhận bưu phẩm', 'BOOL', 'VPR')
	, (N'Địa chỉ giao dịch', 'BOOL', 'VPR')
	, (N'Địa chỉ đăng ký KD', 'BOOL', 'VPR')
GO
INSERT INTO TB_TYPE_DETAILS(TypeDetailName, TypeDetailType, TypeDetailTypeCode)
VALUES (N'Giá', 'STRING', 'VPA')
	, (N'Thời gian làm việc', 'STRING', 'VPA')
	, (N'Lễ tân', 'BOOL', 'VPA')
	, (N'Phòng họp', 'STRING', 'VPA')
	, (N'Số chỗ ngồi', 'INT', 'VPA')
	, (N'Trà café hòa tan', 'BOOL', 'VPA')
	, (N'Thư viện sách', 'BOOL', 'VPA')
	, (N'Ghế Massage, Bi A, Bi Lắc, ...', 'BOOL', 'VPA')
	, (N'Dịch vụ in ấn', 'STRING', 'VPA')
	, (N'Điện nước miễn phí', 'BOOL', 'VPA')
	, (N'Biển tên Công ty', 'BOOL', 'VPA')
	, (N'Dịch vụ bảo vệ', 'BOOL', 'VPA')
	, (N'Tiếp nhận bưu phẩm', 'BOOL', 'VPA')
	, (N'Địa chỉ giao dịch', 'BOOL', 'VPA')
	, (N'Địa chỉ đăng ký KD', 'BOOL', 'VPA')
GO
INSERT INTO TB_SERVICES(ServiceName, ServicePrice, ServiceUnit, ServiceBase, ServiceContent, ServiceTypeCode)
VALUES (N'GÓI THÀNH VIÊN NGÀY', 50000, N'VND / 1 Ngày', N'Xã Đàn', N'Với 1 hoặc 3 ngày làm việc linh hoạt trong tháng, phù hợp với những bạn đi công tác tại Hà Nội, hoặc đổi không khí làm việc. Chi phí từ 60k, tiết kiệm mà được sử dụng 700m2 diện tích chung.', 'GTV')
	, (N'GÓI THÀNH VIÊN NGÀY', 80000, N'VND / 1 Ngày', N'MIPEC', N'Với 1 hoặc 3 ngày làm việc linh hoạt trong tháng, phù hợp với những bạn đi công tác tại Hà Nội, hoặc đổi không khí làm việc. Chi phí từ 60k, tiết kiệm mà được sử dụng 700m2 diện tích chung.', 'GTV')
	, (N'GÓI THÀNH VIÊN 3 NGÀY', 130000, N'VND / 3 Ngày', N'Xã Đàn', N'Bạn hay phải đi công tác, mỗi tháng bạn chỉ làm việc 1-2 tuần tại Hà Nội, gói tuần giúp bạn tiết kiệm chi phí mà vẫn đáp ứng đầy đủ 1 văn phòng cao cấp với 700m2 diện tích chung.', 'GTV')
	, (N'GÓI THÀNH VIÊN 3 NGÀY', 200000, N'VND / 3 Ngày', N'MIPEC', N'Bạn hay phải đi công tác, mỗi tháng bạn chỉ làm việc 1-2 tuần tại Hà Nội, gói tuần giúp bạn tiết kiệm chi phí mà vẫn đáp ứng đầy đủ 1 văn phòng cao cấp với 700m2 diện tích chung.', 'GTV')
	, (N'GÓI THÀNH VIÊN LINH HOẠT', 1200000, N'VND / 1 Người / Tháng', N'Xã Đàn', N'Bạn hay nhóm của bạn cần không gian sáng tạo, tiện nghi và không phải lo về những thứ khác => gói linh hoạt giúp bạn tiết kiệm chi phí => bạn được sử dụng đầy đủ 700m2 chung.', 'GTV')
	, (N'GÓI THÀNH VIÊN LINH HOẠT', 1600000, N'VND / 1 Người / Tháng', N'MIPEC', N'Bạn hay nhóm của bạn cần không gian sáng tạo, tiện nghi và không phải lo về những thứ khác => gói linh hoạt giúp bạn tiết kiệm chi phí => bạn được sử dụng đầy đủ 700m2 chung.', 'GTV')

GO
INSERT INTO TB_SERVICES(ServiceName, ServicePrice, ServiceUnit, ServiceBase, ServiceContent, ServiceTypeCode)
VALUES (N'PHÒNG HỌP M01', 200000, N'1h', N'BisHub Mipec Tây Sơn', N'', 'PH')
	, (N'PHÒNG HỌP M03', 600000, N'1h', N'BisHub Mipec Tây Sơn', N'', 'PH')
GO
/*
	Quản trị phân quyền 
*/
CREATE TABLE SYS_ACTIONS
(
	ACTION_ID					nvarchar(50) NOT NULL			-- Ma Action
	,ACTION_NAME				nvarchar(100) NOT NULL			-- Ten Action
	,ACTION_ISMODULE			bit NOT NULL DEFAULT(0)			-- La module, mac dinh KHONG
	,ACTION_ISROOT				bit NOT NULL DEFAULT(0)			-- Vi tri goc, mac dinh KHONG
	,ACTION_ISSHOW				bit NOT NULL DEFAULT(1)			-- Hien thi, mac dinh CO
	,ACTION_ORDER				int NOT NULL DEFAULT(99)		--  Thu tu, mac dinh 99
	,ACTION_TYPE				nvarchar(10) NOT NULL DEFAULT('WEB')-- Loai action, WEB, MOBILE, DESKTOP
	,ACTION_CONTROLPATH			nvarchar(255)					-- Duong dan
	,ACTION_DESCRIPTION			nvarchar(255)					-- Mo ta them
	,ACTION_ICON_CLASS			nvarchar(50)					-- Ten class Icon -- kien them 
	,ACTION_PARENT_ID			nvarchar(50)					-- Ma Module/Action cha
	,CONSTRAINT PK_SYS_ACTION PRIMARY KEY (ACTION_ID)
	,CONSTRAINT FK_ACTION_PARENT_ID FOREIGN KEY (ACTION_PARENT_ID) REFERENCES SYS_ACTIONS(ACTION_ID)
	,CONSTRAINT CK_ACTION_CONTROLPATH CHECK ((ACTION_ISMODULE = 0 AND ACTION_CONTROLPATH IS NOT NULL) OR (ACTION_ISMODULE = 1 AND (ACTION_CONTROLPATH IS NULL OR ACTION_CONTROLPATH = '')))
	,CONSTRAINT CK_ACTION_PARENT_ID CHECK ((ACTION_ISROOT = 0 AND ACTION_PARENT_ID IS NOT NULL) OR (ACTION_ISROOT = 1 AND ACTION_PARENT_ID IS NULL))
	,CONSTRAINT CK_ACTION_TYPE CHECK (ACTION_TYPE = 'WEB' OR ACTION_TYPE = 'MOBILE' OR ACTION_TYPE = 'DESKTOP')
)
GO
CREATE TABLE SYS_ROLES
(
	ROLE_ID						varchar(50) NOT NULL			-- Ma Role
	,ROLE_NAME					nvarchar(100) NOT NULL			-- Ten Role
	,ROLE_ACTIVE				bit NOT NULL DEFAULT(1)			-- Kich hoat, mac dinh CO
	,ROLE_DESCRIPTION			nvarchar(2000)					-- Mo ta them
	,ROLE_CREATEBY				varchar(50)						-- Nguoi tao, REFERENCES SYS_USER(USER_ID)
	,ROLE_CREATETIME			date NOT NULL DEFAULT(GETDATE())-- Ngay tao, mac dinh HIEN TAI
	,CONSTRAINT PK_SYS_ROLE PRIMARY KEY (ROLE_ID)
)
GO
CREATE TABLE SYS_ROLE_ACTIONS
(
	REL_ID						int NOT NULL					-- Identity
	,REL_ROLEID					varchar(50) NOT NULL			-- Ma Role
	,REL_ACTIONID				nvarchar(50) NOT NULL			-- Ma Action
	,REL_CREATEBY				nvarchar(50)					-- Nguoi tao, REFERENCES SYS_USER(USER_ID)
	,REL_CREATETIME				date NOT NULL DEFAULT(GETDATE())-- Ngay tao, mac dinh HIEN TAI
	,CONSTRAINT PK_SYS_ROLE_ACTION PRIMARY KEY (REL_ID)
	,CONSTRAINT UQ_SYS_ROLE_ACTION UNIQUE (REL_ROLEID, REL_ACTIONID)
	,CONSTRAINT FK_ROLE_ACTION_ACTION FOREIGN KEY (REL_ACTIONID) REFERENCES SYS_ACTIONS (ACTION_ID)
	,CONSTRAINT FK_ROLE_ACTION_ROLE FOREIGN KEY (REL_ROLEID) REFERENCES SYS_ROLES (ROLE_ID)
)
GO
CREATE TABLE SYS_GROUPS
(
	GROUP_ID					varchar(50) NOT NULL			-- Ma nhom
	,GROUP_NAME					nvarchar(100) NOT NULL			-- Ten nhom
	,GROUP_ACTIVE				bit NOT NULL DEFAULT(1)			-- Kich hoat, mac dinh CO
	,GROUP_DESCRIPTION			nvarchar(255)					-- Mo ta them
	,GROUP_CREATEBY				nvarchar(50)					-- Nguoi tao, REFERENCES SYS_USER(USER_ID)
	,GROUP_CREATETIME			date NOT NULL DEFAULT(GETDATE())-- Ngay tao, mac dinh HIEN TAI
	,CONSTRAINT PK_SYS_GROUP PRIMARY KEY (GROUP_ID)
)
GO
CREATE TABLE SYS_GROUP_USERS
(
	REL_ID						int NOT NULL					-- Identity
	,REL_GROUPID				varchar(50) NOT NULL			-- Ma nhom
	,REL_USERID					INT NOT NULL			-- Ma User
	,REL_CREATEBY				varchar(50)						-- Nguoi tao, REFERENCES SYS_USER(USER_ID)
	,REL_CREATETIME				date NOT NULL DEFAULT(GETDATE())-- Ngay tao, mac dinh HIEN TAI
	,CONSTRAINT PK_SYS_GROUP_USER PRIMARY KEY (REL_ID)
	,CONSTRAINT UQ_SYS_GROUP_USER UNIQUE (REL_GROUPID, REL_USERID)
	,CONSTRAINT FK_GROUP_USER_GROUP FOREIGN KEY (REL_GROUPID) REFERENCES SYS_GROUPS (GROUP_ID)
	,CONSTRAINT FK_GROUP_USER_USER FOREIGN KEY (REL_USERID) REFERENCES TB_USERS (UserId)
)
GO
CREATE TABLE SYS_GROUP_ROLES
(
	REL_ID						int NOT NULL					-- Identity
	,REL_GROUPID				varchar(50) NOT NULL			-- Ma nhom
	,REL_ROLEID					varchar(50) NOT NULL			-- Ma role
	,REL_CREATEBY				varchar(50)						-- Nguoi tao, REFERENCES SYS_USER(USER_ID)
	,REL_CREATETIME				date NOT NULL DEFAULT(GETDATE())-- Ngay tao, mac dinh HIEN TAI
	,CONSTRAINT PK_SYS_GROUPROLE_REL PRIMARY KEY (REL_ID)
	,CONSTRAINT UQ_SYS_GROUPROLE_REL UNIQUE (REL_ROLEID, REL_GROUPID)
	,CONSTRAINT FK_GROUP_ROLE_GROUP FOREIGN KEY (REL_GROUPID) REFERENCES SYS_GROUPS (GROUP_ID)
	,CONSTRAINT FK_GROUP_ROLE_ROLE FOREIGN KEY (REL_ROLEID) REFERENCES SYS_ROLES (ROLE_ID)
)
GO
CREATE SEQUENCE SYS_ROLE_ACTIONS_SEQ	START WITH 1 INCREMENT BY 1
GO
CREATE SEQUENCE SYS_ACTIONS_SEQ			START WITH 1 INCREMENT BY 1
GO
CREATE SEQUENCE SYS_GROUP_USER_SEQ		START WITH 1 INCREMENT BY 1
GO
CREATE SEQUENCE SYS_GROUP_SEQ			START WITH 1 INCREMENT BY 1
GO
CREATE SEQUENCE SYS_ROLES_SEQ			START WITH 1 INCREMENT BY 1
GO
CREATE SEQUENCE SYS_GROUP_ROLES_SEQ		START WITH 1 INCREMENT BY 1 
GO
CREATE TABLE SYS_CONTROLS(
CONTROL_ID VARCHAR(50) PRIMARY KEY,
CONTROL_NAME NVARCHAR(50),
CONTROL_URL VARCHAR(50),
CONTROL_ICON VARCHAR(50),
CONTROL_ACTION_ID NVARCHAR(50)
,CONSTRAINT [FK_CONTROL_ACTION] FOREIGN KEY(CONTROL_ACTION_ID)
		REFERENCES [dbo].[SYS_ACTIONS] (ACTION_ID) ON DELETE CASCADE
)
GO
-- INSERT DATA FROM CONTROLS 
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('1',N'Thêm mới','btnAdd','ACT00800010')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('2',N'Chỉnh sửa','btnEdit','ACT00800010')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('3',N'Xóa','btnDelete','ACT00800010')

--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('4',N'Thêm mới','btnAdd','ACT00802010')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('5',N'Chỉnh sửa','btnEdit','ACT00802010')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('6',N'Xóa','btnDelete','ACT00802010')

--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('7',N'Thêm mới','btnAdd','ACT00804010')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('8',N'Chỉnh sửa','btnEdit','ACT00804010')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('9',N'Xóa','btnDelete','ACT00804010')

--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('10',N'Thêm mới','btnAdd','ACT00804011')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('11',N'Chỉnh sửa','btnEdit','ACT00804011')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('12',N'Xóa','btnDelete','ACT00804011')

--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('13',N'Thêm mới','btnAdd','ACT00903010')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('14',N'Chỉnh sửa','btnEdit','ACT00903010')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('15',N'Xóa','btnDelete','ACT00903010')

--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('16',N'Thêm mới','btnAdd','ACT00904010')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('17',N'Chỉnh sửa','btnEdit','ACT00904010')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('18',N'Xóa','btnDelete','ACT00904010')

--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('18',N'Thêm mới','btnAdd','ACT00902000')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('19',N'Chỉnh sửa','btnEdit','ACT00902000')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('20',N'Xóa','btnDelete','ACT00902000')


--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('21',N'Thêm mới','btnAdd','ACTI00000003')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES ('22',N'Chỉnh sửa','btnEdit','ACTI00000003')
--INSERT INTO SYS_CONTROLS (CONTROL_ID,CONTROL_NAME,CONTROL_URL,CONTROL_ACTION_ID) VALUES (N'23','Xóa','btnDelete','ACTI00000003')
GO
CREATE TABLE SYS_ROLE_CONTROLS(
RC_ID INT IDENTITY PRIMARY KEY,
RC_ROLE_ID VARCHAR(50),
RC_CONTROL_ID VARCHAR(50),
RC_DESCRIPTION NVARCHAR(500)
,CONSTRAINT [FK_ROLE_CONTROL_CONTROL] FOREIGN KEY(RC_CONTROL_ID)
		REFERENCES [dbo].SYS_CONTROLS (CONTROL_ID) ON DELETE CASCADE
,CONSTRAINT [FK_ROLE_CONTROL_ROLE] FOREIGN KEY(RC_ROLE_ID)
		REFERENCES [dbo].SYS_ROLES (ROLE_ID) ON DELETE CASCADE
)
GO
/*
WEB ADMIN
	1, Trang chủ
	2, Quản lý phân quyền
	3, Quản lý dịch vụ
	4, Quản lý thành viên
	5, Quản lý bài viết

	6, Giải trí - thể thao

WEB CLIENT
	1, Trang chủ
	2, Dịch vụ
		Thông tin
		Đăng ký
	3, Bài viết

	4, Giỏ hàng
	5, Thanh toán
	6, Sản phẩm
		Danh sách
		Chi tiết

	7, Kết nối FB
*/