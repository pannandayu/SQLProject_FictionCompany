use company;

create table employee(
emp_id int primary key,
first_name varchar(40),
last_name varchar(40),
birth_day date,
sex varchar(1),
salary int,
super_id int,
branch_id int);

alter table employee 
add foreign key(branch_id)
references branch(branch_id)
on delete set null;

alter table employee 
add foreign key(super_id)
references employee(emp_id)
on delete set null;

create table branch(
branch_id int primary key,
branch_name varchar(40),
mgr_id int,
mgr_start_date date);
foreign key(mgr_id) references employee(emp_id) on delete set null);

alter table branch 
add foreign key(mgr_id) references employee(emp_id) on delete set null;

create table client(
client_id int primary key,
client_name varchar(40),
branch_id int,
foreign key(branch_id) references branch(branch_id) on delete set null);


create table works_with(
emp_id int,
client_id int,
total_sales int,
primary key(emp_id, client_id),
foreign key(emp_id) references employee(emp_id) on delete cascade,
foreign key(client_id) references client(client_id) on delete cascade);

create table branch_supplier(
branch_id int,
supplier_name varchar(40),
supply_type varchar(40),
primary key(branch_id, supplier_name),
foreign key(branch_id) references branch(branch_id) on delete cascade);

-- corporate
insert into employee
values(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, null, null);

insert into branch
values(1, 'Corporate', 100, '2006-02-09');

update employee 
set branch_id = 1
where emp_id = 100;

insert into employee
values(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);


-- scranton
insert into employee
values(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, null);

insert into branch
values(2, 'Scranton', 102, '1992-04-06');

update employee
set branch_id = 2
where emp_id = 102;

insert into employee
values(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);

insert into employee
values(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);

insert into employee
values(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);


-- stamford
insert into employee
values(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, 3);

insert into branch
values(3, 'Stamford', 106, '1998-02-13');

update employee
set branch_id = 2
where emp_id = 102;

insert into employee
values(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);

insert into employee
values(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

-- client
insert into client values(400, 'Dunmore Highschool', 2);
insert into client values(401, 'Lackawana Country', 2);
insert into client values(402, 'FedEx', 3);
insert into client values(403, 'John Daly Law', 3);
insert into client values(404, 'Scranton Whitepages', 2);
insert into client values(405, 'Times', 3);
insert into client values(406, 'FedEx', 2);

-- works_with
insert into works_with values(105, 400, 55000);
insert into works_with values(102, 401, 267000);
insert into works_with values(108, 402, 22500);
insert into works_with values(107, 403, 5000);
insert into works_with values(108, 403, 12000);
insert into works_with values(105, 404, 33000);
insert into works_with values(107, 405, 26000);
insert into works_with values(102, 406, 15000);
insert into works_with values(105, 406, 80000);

select *
from employee limit 3 offset 1;

select first_name as forename, last_name as surname
from employee;

select *
from employee
order by sex desc, first_name, last_name;

select distinct sex
from employee;

select *
from employee
where birth_day > '1969-12-31' and sex = 'F' and salary > 60000 and last_name = 'Martin';

select avg(salary)
from employee;

delete from employee 
where emp_id = 106;

select sex, count(sex) as jumlah
from employee
group by sex
order by jumlah desc;

select sum(total_sales), emp_id 
from works_with
group by emp_id ;

select *
from client c 
where client_name  like '%school%';

select *
from employee e 
where birth_day like '196_-__-_5';
#where birth_day like '____-10%';

select first_name as union_1, last_name as union_2 
from employee e
union
select branch_name, branch_id 
from branch b
union
select client_id, client_name
from client c;

select sum(total_sales),sum(salary)
from works_with as ww, employee as e;

select *
from works_with
where total_sales  > (select avg(salary) from employee e)  ;

select e.emp_id, e.first_name, e.last_name, e.salary, b.branch_name 
from employee e 
join branch b 
on e.emp_id = b.mgr_id;

select e.first_name, e.last_name
from employee e 
where e.emp_id in (
	select ww.emp_id
	from works_with as ww
	where ww.total_sales > (
			select avg(ww2.total_sales) 
			from works_with ww2)
);

select ww.emp_id, ww.total_sales 
from works_with as ww
where total_sales > (select avg(total_sales) from works_with ww2) ;

select c.client_name 
from client c 
where c.branch_id = (select b.branch_id 
					from branch b 
					where b.mgr_id = 102);
# in bisa multiple values, = hanya 1

select b.branch_id 
from branch b 
where b.mgr_id = 102;

select * 
from client c
where c.branch_id = 2;

select emp_id, salary, (select max(salary) from employee)
from employee;

select *
from employee as e, branch as b
where e.emp_id = b.mgr_id;

select sex, avg(salary) as avg_salary
from employee e 
group by sex
having avg_salary > (select avg(salary) from employee e2);

select avg(salary) from employee e2;

describe client;

describe branch_supplier ;

describe works_with ;