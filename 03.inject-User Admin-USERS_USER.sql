use WISE_STAGING
go
declare @password nvarchar(max) = '3HkdCCCZwGgRtuYzzGAv9dr0V7GoZ0hRcmq+9vwVb3w='
if (select count(1) from users_user where username='admin')>0
begin
update a
set password=@password
from users_user a 
where username='admin'
end
else
begin
	insert into users_user (username, password, is_staff, is_superuser)
	values('admin',@password,'1','1')
end