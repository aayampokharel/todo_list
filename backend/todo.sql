create database todo_list;

use todo_list;
create table todolist(
Id int primary key,
Subdirectory varchar(20),
Data varchar(40),
Timing time,
Completed_or_not bool

);

select * from todo_list;