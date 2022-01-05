use AdventureWorks2019
go
--Tạo khung nhìn lấy ra thông tin cơ bản trong bảng Person.Contact
create view V_Contact_Info AS
select FirstName, MiddleName, LastName
from Person.Person
go
--Tạo khung nhìn lấy ra thông tin nhân viên
Create view V_Employee_Contact AS
select p.FirstName, p.LastName, e.BusinessEntityID, e.HireDate
from HumanResources.Employee e
join Person.Person AS p ON e.BusinessEntityID=p.BusinessEntityID;
go
--xem 1 khug hình
select*from V_Employee_Contact
go

--thay đổi khung nhìn V_Employee_Contact bảng việt  thêm cột Birthdate
alter view V_Employee_Contact AS
select p.FirstName,p.LastName, e.BusinessEntityID, e.HireDate
from HumanResources.Employee e
join Person.Person AS p ON e.BusinessEntityID=p.BusinessEntityID
where p.FirstName like '%B%';
go
 
 --xóa 1 khung nhìn
drop view V_Contact_Info
go
--xem định nghĩa khung nhìn V_Employee_Contact
sp_helptext 'V_Employee_Contact'
--xem các thành phần mà khung nhìn phụ thuộc
sp_depends 'V_Employee_Contact'
go

--tạo khung nhìn ẩn mà định nghĩa bị ẩnđi (0 xem đc định nghĩa khung nhìn)
create view OrderRejects
with encryption
as
select PurchaseOrderID, ReceivedQty, rejectedQty,
     RejectedQty / ReceivedQty as RejectedRatio, DueDate
from Purchasing.PurchaseOrderDetail
where RejectedQty/ReceivedQty >0
and DueDate>CONVERT(datetime,'20010630',101);

--Không xem đc định nghĩa khung nhìn V_Contact_Info
sp_helptext 'OrderRejects'
go
-- thay đổi khung nhìn thêm tuyd chọn Check option
alter view V_Employee_Contact AS
select p.FirstName, p.LastName, e.BusinessEntityID, e.HireDate
from HumanResources.Employee e
join Person.Person as p ON e.BusinessEntityID=p.BusinessEntityID
where p.FirstName like 'A%'
with check option
go
--cập nhật được khung hình nhìn LastName bắt đầu bằng A
update V_Employee_Contact set FirstName ='Atest' where LastName='Amy'
--không cập nhật được khung hình nhìn LastName bắt đầu bằng A
update V_Employee_Contact set FirstName='BCD' where LastName='Atest'
go
--phải xóa khung nhìn trước 
drop view V_Contact_Info
go
--tạo khung nhìn có giản đồ 
Create view V_Contact_Info with schemabinding as
select FirstName, MiddleName,LastName,EmailAddress
from Person.Contact
go
--không thể truy vấn đc khung nhìn tên V_Contact_Info
select*from V_Contact_Info
go
--tạo chỉ mục duy nhất trên cột EmailAddress trên khung nhìn V_Contact_Info
create UNIQUE clustered index IX_Contact_Email
on V_Contact_Info(EmailAddress)
go

--thực hiện đổi tên khung nhìn 
exec sp_rename V_Contact_Info, V_Contact_Infomation
--truy vấn khung nhìn 
select*from V_Contact_Infomation


