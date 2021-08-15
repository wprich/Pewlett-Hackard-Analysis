--Tailored list 1, sales retirees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
ce.dept_name
INTO sales_info
FROM dept_info as ce
where (dept_name = 'Sales')

select * from sales_info

select count(*)
from sales_info

select * from dept_retirement

--Tailored list 2, sales and development retirees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
ce.dept_name
INTO sd_info
FROM dept_info as ce
where dept_name in ('Development', 'Sales')

select * from sd_info

select count(*)
from sd_info

select * from dept_retirement