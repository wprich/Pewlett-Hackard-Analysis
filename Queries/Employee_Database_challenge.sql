--Create retirement titles table
select e.emp_no,
	   e.first_name, 
	   e.last_name, 
	   ti.title,
	   ti.from_date,
	   ti.to_date
into retirement_titles
from employees as e
inner join titles as ti
on e.emp_no = ti.emp_no
where (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
order by emp_no


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


--Creating mentorship eligibilty table
select distinct on(e.emp_no) e.emp_no,
    e.first_name,
    e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
into mentorship_eligibilty
from employees as e
left join dept_emp as de
on e.emp_no = de.emp_no
left join titles as ti
on ti.emp_no = ce.emp_no
where de.to_date = ('9999-01-01')
and (e.birth_date between '1965-01-01' AND '1965-12-31')
order by e.emp_no asc


-- Get retirement totals for each department with name attatched
select d.dept_no,
	   d.dept_name,
	   dr.count
into retirement_dept_totals
from dept_retirement as dr
left join departments as d
on d.dept_no = dr.dept_no
order by count desc

--Get total number of employees still working at company
select count (emp_no) 
from dept_emp
WHERE to_date = ('9999-01-01');