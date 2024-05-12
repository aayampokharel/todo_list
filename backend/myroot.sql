create database if not exists todo_listdb;
use todo_listdb;

create table if not exists todolist(
Id int primary key,

Subdirectory varchar(25),
Data varchar(40),
Timing time,
Completed_or_not bool
);



insert into todolist values(1,"hello","hello bro","12:12:12",false);


-- Inserting multiple values in a single statement
insert into todolist (Id, Subdirectory, Data, Timing, Completed_or_not)
values
(2, 'example', 'example data 1', '08:30:00', false),
(3, 'example', 'example data 2', '10:45:00', true),
(5, 'another', 'another example 2', '16:30:00', true),
(6, 'additional', 'additional example', '12:00:00', false),
(7, 'extra', 'extra example', '09:00:00', true),
(4, 'another', 'another example', '14:15:00', false);

select * from todolist;
drop database todo_listdb;





