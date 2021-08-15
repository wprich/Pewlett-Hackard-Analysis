--Create retirement titles table
select e.first_name, 
	   e.last_name, 
	   e.emp_no, 
	   ti.title,
	   ti.from_date,
	   ti.to_date
into retirement_titles
from employees as e
inner join titles as ti
on e.emp_no = ti.emp_no
where (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
order by emp_no;

-- Use Dictinct with Orderby to remove duplicate rows and create unique titles table
select distinct on (emp_no) emp_no,
first_name,
last_name,
title
into unique_titles
from retirement_titles
order by emp_no asc, to_date desc;

--Retirement count by job title
select count(emp_no), title
into retiring_titles
from unique_titles
group by title
order by count desc
