create user andrew identified by andrew --создание пользователя
default tablespace users quota 100m on users
temporary tablespace temp quota 10m on temp;

grant create session to andrew; --разрешение на подключение

connect andrew/andrew; --подключение

grant create table to andrew; --разрешение на создание таблиц и тд
grant create procedure to dummy;
grant create trigger to andrew;
grant create view to andrew;
grant create sequence to andrew;

grant alter any table to andrew; --разрешение на изменение таблиц и тд
grant alter any procedure to andrew;
grant alter any trigger to andrew;
grant alter profile to andrew;

grant delete any table to andrew; --разрешение на удаление таблиц и тд
grant drop any table to andrew;
grant drop any procedure to andrew;
grant drop any trigger to andrew;
grant drop any view to andrew;
grant drop profile to andrew;

